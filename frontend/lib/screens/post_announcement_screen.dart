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

  bool _urgent = false;
  bool _pushNotification = true;
  String _audience = "All Students";

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.announcement?['title'],
    );
    _messageController = TextEditingController(
      text: widget.announcement?['message'],
    );
    if (widget.announcement != null) {
      _urgent = widget.announcement!['urgent'] ?? false;
      _audience = widget.announcement!['audience'] ?? "All Students";
    }
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
              const SizedBox(height: 28),

              const Text(
                "DELIVERY SETTINGS",
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              _settingTile(
                icon: Icons.warning_amber_rounded,
                iconBg: Colors.orange.withOpacity(0.15),
                title: "Urgent / High Priority",
                trailing: Switch(
                  value: _urgent,
                  onChanged: (v) => setState(() => _urgent = v),
                ),
              ),

              _settingTile(
                icon: Icons.notifications_active,
                iconBg: Color(0xFF3A4F9B).withOpacity(0.15),
                title: "Push Notification",
                subtitle: "Notify all students immediately",
                trailing: Switch(
                  value: _pushNotification,
                  onChanged: (v) => setState(() => _pushNotification = v),
                ),
              ),

              _settingTile(
                icon: Icons.groups_outlined,
                iconBg: Colors.grey.withOpacity(0.15),
                title: "Target Audience",
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _audience,
                      style: const TextStyle(
                        color: Color(0xFF3A4F9B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () {},
              ),

              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text(
                    "Post Announcement",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3A4F9B),
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

  // ================= SETTINGS TILE =================
  Widget _settingTile({
    required IconData icon,
    required Color iconBg,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.black54),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
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
        'urgent': _urgent,
        'audience': _audience,
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
