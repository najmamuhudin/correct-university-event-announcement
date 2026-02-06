import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';

class RegisteredStudentsScreen extends StatefulWidget {
  final List<dynamic>? attendeeIds;

  const RegisteredStudentsScreen({super.key, this.attendeeIds});

  @override
  State<RegisteredStudentsScreen> createState() =>
      _RegisteredStudentsScreenState();
}

class _RegisteredStudentsScreenState extends State<RegisteredStudentsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AdminProvider>(context, listen: false).fetchStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registered Students"),
        backgroundColor: const Color(0xFF3A4F9B),
        foregroundColor: Colors.white,
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          if (provider.students.isEmpty) {
            return const Center(child: Text("No students found."));
          }

          final studentsToShow = widget.attendeeIds == null
              ? provider.students
              : provider.students.where((student) {
                  return widget.attendeeIds!.contains(student['_id']);
                }).toList();

          if (studentsToShow.isEmpty) {
            return const Center(
                child: Text("No students registered for this event."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: studentsToShow.length,
            itemBuilder: (context, index) {
              final student = studentsToShow[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF3A4F9B).withOpacity(0.1),
                    child: Text(
                      (student['name'] ?? "S")[0].toUpperCase(),
                      style: const TextStyle(
                          color: Color(0xFF3A4F9B),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(student['name'] ?? "Unknown Name",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student['email'] ?? "No Email",
                          style: TextStyle(color: Colors.grey[600])),
                      if (student['studentId'] != null)
                        Text("ID: ${student['studentId']}",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
