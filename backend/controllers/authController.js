const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const asyncHandler = require('express-async-handler');
const User = require('../models/User');

/**
 * @desc    Register new user
 * @route   POST /api/auth/register
 * @access  Public
 * @param   {Object} req.body - Contains name, email, password, studentId, etc.
 */
const registerUser = asyncHandler(async (req, res) => {
    const { name, email, password, studentId } = req.body;

    // Validate required fields
    if (!name || !email || !password || !studentId) {
        res.status(400);
        throw new Error('Please add all fields');
    }

    // Check if a user with this email already exists
    const userExists = await User.findOne({ email });
    if (userExists) {
        res.status(400);
        throw new Error('User with this email already exists');
    }

    // Check if a user with this student ID already exists
    const idExists = await User.findOne({ studentId });
    if (idExists) {
        res.status(400);
        throw new Error('A user with this ID Number already exists');
    }

    // Default role assignment: Force role to be 'student' for public registrations to prevent unauthorized admin creation
    const role = 'student';

    // Password Hashing: Generate salt and hash the password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create the new user in the database
    const user = await User.create({
        name,
        email,
        password: hashedPassword, // Store hashed password only
        studentId,
        role,
        department: req.body.department || 'General',
        year: req.body.year || 'Freshman'
    });

    if (user) {
        res.status(201).json({
            _id: user.id,
            name: user.name,
            email: user.email,
            studentId: user.studentId,
            role: user.role,
            token: generateToken(user._id) // Return JWT for immediate login
        });
    } else {
        res.status(400);
        throw new Error('Invalid user data');
    }
});

/**
 * @desc    Authenticate a user (Login)
 * @route   POST /api/auth/login
 * @access  Public
 * @param   {Object} req.body - email and password
 */
const loginUser = asyncHandler(async (req, res) => {
    const { email, password } = req.body;

    // Check for user by email
    const user = await User.findOne({ email });

    // Compare plain-text password with hashed password in DB
    if (user && (await bcrypt.compare(password, user.password))) {
        res.json({
            _id: user.id,
            name: user.name,
            email: user.email,
            studentId: user.studentId,
            role: user.role,
            token: generateToken(user._id)
        });
    } else {
        res.status(401);
        throw new Error('Invalid credentials');
    }
});

/**
 * @desc    Get current logged-in user data
 * @route   GET /api/auth/me
 * @access  Private
 */
const getMe = asyncHandler(async (req, res) => {
    // Returns the user data attached to req by the protect middleware
    res.status(200).json(req.user);
});

/**
 * Generate JWT Token
 * @param {string} id - User ID
 * @returns {string} JWT Token
 */
const generateToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET, {
        expiresIn: '30d', // Token expires in 30 days
    });
};

/**
 * @desc    Verify identity and get reset token
 * @route   POST /api/users/forgot-password
 * @access  Public
 */
const forgotPassword = asyncHandler(async (req, res) => {
    const { email, studentId } = req.body;

    // Verify user exists with matching email AND studentId
    const user = await User.findOne({ email, studentId });

    if (!user) {
        res.status(404);
        throw new Error('User not found with provided Email and ID.');
    }

    // Generate a temporary reset token (valid for 15 mins)
    const resetToken = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
        expiresIn: '15m',
    });

    // In a real app, you would send this via email.
    // For this demo/mock, we return it to the client to proceed.
    res.status(200).json({
        message: 'Identity Verified. Proceed to reset password.',
        token: resetToken,
    });
});

/**
 * @desc    Reset password using token
 * @route   POST /api/users/reset-password
 * @access  Public
 */
const resetPassword = asyncHandler(async (req, res) => {
    const { token, newPassword } = req.body;

    if (!token || !newPassword) {
        res.status(400);
        throw new Error('Missing token or new password');
    }

    try {
        // Verify token
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        const user = await User.findById(decoded.id);
        if (!user) {
            res.status(404);
            throw new Error('User not found');
        }

        // Hash new password
        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(newPassword, salt);

        await user.save();

        res.status(200).json({ message: 'Password updated successfully' });
    } catch (error) {
        res.status(400);
        throw new Error('Invalid or expired token');
    }
});

module.exports = {
    registerUser,
    loginUser,
    getMe,
    forgotPassword,
    resetPassword,
};