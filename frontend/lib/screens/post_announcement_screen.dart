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

  List<String> _selectedStudentIds = [];

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
      _selectedStudentIds =
          List<String>.from(widget.announcement!['targetIds'] ?? []);
    }

    // Fetch students for the selector
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchStudents();
    });
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
                icon: Icons.groups_outlined,
                iconBg: Colors.grey.withOpacity(0.15),
                title: "Target Audience",
                subtitle: _selectedStudentIds.isEmpty
                    ? "Visible to All Students"
                    : "${_selectedStudentIds.length} Students Selected",
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: _showStudentSelector,
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
                    backgroundColor: const Color(0xFF3A4F9B),
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

  // ================= STUDENT SELECTOR =================
  void _showStudentSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<AdminProvider>(
          builder: (context, provider, _) {
            final students = provider.students;
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Select Target Audience",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (_selectedStudentIds.length ==
                                    students.length) {
                                  _selectedStudentIds.clear();
                                } else {
                                  _selectedStudentIds = students
                                      .map((s) => s['_id'].toString())
                                      .toList();
                                }
                              });
                            },
                            child: Text(
                              _selectedStudentIds.length == students.length
                                  ? "Deselect All"
                                  : "Select All",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: students.length,
                              itemBuilder: (context, index) {
                                final student = students[index];
                                final id = student['_id'];
                                final isSelected =
                                    _selectedStudentIds.contains(id);
                                return CheckboxListTile(
                                  value: isSelected,
                                  title: Text(student['name'] ?? "Unknown"),
                                  subtitle: Text(student['email'] ?? ""),
                                  secondary: CircleAvatar(
                                    backgroundColor: const Color(0xFF3A4F9B)
                                        .withOpacity(0.1),
                                    child: Text(
                                      (student['name'] ?? "U")[0].toUpperCase(),
                                      style: const TextStyle(
                                          color: Color(0xFF3A4F9B)),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        _selectedStudentIds.add(id);
                                      } else {
                                        _selectedStudentIds.remove(id);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A4F9B),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Done"),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
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
        'targetIds': _selectedStudentIds,
        'audience':
            _selectedStudentIds.isEmpty ? "All Students" : "Selected Students",
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
