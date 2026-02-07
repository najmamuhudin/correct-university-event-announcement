import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';

class PostAnnouncementScreen extends StatefulWidget {
  final Map<String, dynamic>? announcement;
  const PostAnnouncementScreen({super.key, this.announcement});

  @override
  State<PostAnnouncementScreen> createState() => _PostAnnouncementScreenState();
}

class _PostAnnouncementScreenState extends State<PostAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.announcement?['title'],
    );
    _messageController = TextEditingController(
      text: widget.announcement?['message'],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),
      appBar: _appBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create New Post",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Broadcast official news to the university community.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _label("Announcement Title"),
              _input(
                controller: _titleController,
                hint: "e.g. Fall Semester Registration Now Open",
              ),
              const SizedBox(height: 20),
              _label("Message Body"),
              _messageBox(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    "Post Announcement",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A4F9B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= APP BAR =================
  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Color(0xFF3A4F9B)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.announcement == null
            ? "Post Announcement"
            : "Update Announcement",
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      actions: [
        if (widget.announcement != null)
          IconButton(
            onPressed: _deleteAnnouncement,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        TextButton(
          onPressed: _submit,
          child: Text(
            widget.announcement == null ? "Post" : "Save",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A4F9B),
            ),
          ),
        ),
      ],
    );
  }

  // ================= INPUTS =================
  Widget _input({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      validator: (v) => v!.isEmpty ? "Required" : null,
      decoration: _decoration(hint),
    );
  }

  Widget _messageBox() {
    return TextFormField(
      controller: _messageController,
      maxLines: 6,
      validator: (v) => v!.isEmpty ? "Required" : null,
      decoration: _decoration("Type the official announcement message here..."),
    );
  }

  void _deleteAnnouncement() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Announcement"),
        content: const Text(
          "Are you sure you want to delete this announcement?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await Provider.of<AdminProvider>(
        context,
        listen: false,
      ).deleteAnnouncement(widget.announcement!['_id']);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  // ================= SUBMIT =================
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final data = {
        'title': _titleController.text.trim(),
        'message': _messageController.text.trim(),
        'targetIds': [],
        'audience': "All Student",
      };

      if (widget.announcement == null) {
        await adminProvider.postAnnouncement(data);
      } else {
        await adminProvider.updateAnnouncement(
          widget.announcement!['_id'],
          data,
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  // ================= HELPERS =================
  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
