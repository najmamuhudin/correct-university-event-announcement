<<<<<<< HEAD
# University Events & Announcement System

A comprehensive mobile application designed to streamline communication within the university. This system allows administrators to manage events and announcements while students can stay updated with the latest university happenings.

## 🚀 Features

### for Students
*   **View Events:** Browse through a list of upcoming university events.
*   **View Announcements:** Stay informed with important university announcements.
*   **Event Registration:** Register for events (if supported).
*   **Dashboard:** View relevant statistics or summaries.
*   **Authentication:** Secure login and profile management.

### for Administrators
*   **Manage Events:** Create, edit, and delete events.
*   **Manage Announcements:** Post and manage announcements.
*   **Image Uploads:** Upload images for events to make them visually appealing.
*   **Dashboard:** View insights and analytics (visualized with charts).
*   **User Management:** Oversee registered students (implied).

## 🛠️ Tech Stack

### Frontend (Mobile App)
*   **Framework:** [Flutter](https://flutter.dev/)
*   **Language:** Dart
*   **State Management:** Provider
*   **UI Components:** Flutter Zoom Drawer, Font Awesome, Google Fonts, Dotted Border, FL Chart
*   **Networking:** Http
*   **Storage:** Shared Preferences
*   **Utilities:** Image Picker, Intl

### Backend (API)
*   **Runtime:** [Node.js](https://nodejs.org/)
*   **Framework:** [Express.js](https://expressjs.com/)
*   **Database:** [MongoDB](https://www.mongodb.com/) (Mongoose ODM)
*   **Authentication:** JWT (JSON Web Tokens) & BCryptJS
*   **File Handling:** Multer (for image uploads)
*   **Other:** Dotenv, CORS, Nodemon

## 📦 Installation & Setup

Follow these steps to get the project running locally.

### Prerequisites
*   Node.js & npm installed
*   Flutter SDK installed
*   MongoDB installed and running (or a MongoDB Atlas connection string)

### 1. Backend Setup
The backend handles the API and database connections.

1.  Navigate to the backend directory:
    ```bash
    cd backend
    ```
2.  Install dependencies:
    ```bash
    npm install
    ```
3.  **Environment Variables:** Create a `.env` file in the `backend` root and add your configuration (example):
    ```env
    PORT=5000
    MONGO_URI=your_mongodb_connection_string
    JWT_SECRET=your_jwt_secret_key
    ```
4.  Start the server:
    ```bash
    npm start
    ```
    *   *For development with auto-restart:*
    ```bash
    npm run dev
    ```

### 2. Frontend Setup
The frontend is the Flutter mobile application.

1.  Navigate to the frontend directory:
    ```bash
    cd frontend
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the app:
    ```bash
    flutter run
    ```

## 📱 Usage
*   Ensure the backend server is running before launching the mobile app.
*   The app mimics a real-world scenario with separate interfaces for Students and Admins based on their login credentials.

## 🤝 Contributing
Feel free to fork this repository and submit pull requests to contribute to the project.

## 📄 License
=======
🎓 University Events & Announcement System

A comprehensive mobile application designed to streamline communication within the university. This system allows administrators to manage events and announcements while students can stay updated with the latest university happenings.

🚀 Features
👩‍🎓 For Students

View Events: Browse through a list of upcoming university events.

View Announcements: Stay informed with important university announcements.

Event Registration: Register for events (if supported).

Dashboard: View relevant statistics or summaries.

Authentication: Secure login and profile management.

🧑‍💼 For Administrators

Manage Events: Create, edit, and delete events.

Manage Announcements: Post and manage announcements.

Image Uploads: Upload images for events to make them visually appealing.

Dashboard: View insights and analytics (visualized with charts).

User Management: Oversee registered students (implied).

🛠️ Tech Stack
📱 Frontend (Mobile App)

Framework: Flutter

Language: Dart

State Management: Provider

UI Components: Flutter Zoom Drawer, Font Awesome, Google Fonts, Dotted Border, FL Chart

Networking: Http

Storage: Shared Preferences

Utilities: Image Picker, Intl

💻 Backend (API)

Runtime: Node.js

Framework: Express.js

Database: MongoDB
 (Mongoose ODM)

Authentication: JWT (JSON Web Tokens) & BCryptJS

File Handling: Multer (for image uploads)

Other: Dotenv, CORS, Nodemon

📦 Installation & Setup

Follow these steps to get the project running locally.

🔹 Prerequisites

Node.js & npm installed

Flutter SDK installed

MongoDB installed and running (or a MongoDB Atlas connection string)

1️⃣ Backend Setup

Navigate to the backend directory:

cd backend


Install dependencies:

npm install


Environment Variables: Create a .env file in the backend root:

PORT=5000
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret_key


Start the server:

npm start


For development with auto-restart:

npm run dev

2️⃣ Frontend Setup

Navigate to the frontend directory:

cd frontend


Install dependencies:

flutter pub get


Run the app:

flutter run

📱 Usage

Make sure the backend server is running before launching the mobile app.

The app provides separate interfaces for Students and Admins based on login credentials.

🤝 Contributing

Feel free to fork this repository and submit pull requests to contribute to the project.

📄 License

>>>>>>> 3ff2f31cc39519c6e82bd20762f2ad53e21af396
This project is licensed under the ISC License.
