import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddDiaryScreen extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? diaryEntry;

  const AddDiaryScreen({super.key, required this.isEditing, this.diaryEntry});

  @override
  State<AddDiaryScreen> createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.diaryEntry != null) {
      _titleController.text = widget.diaryEntry!['title'];
      _contentController.text = widget.diaryEntry!['content'];
    }
  }

  // Save or update diary entry
  Future<void> _saveNote() async {
    final title = _titleController.text;
    String content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        final diaryRef = FirebaseFirestore.instance
            .collection('alzheimer')
            .doc(userId)
            .collection('diary');

        if (widget.isEditing && widget.diaryEntry != null) {
          await diaryRef.doc(widget.diaryEntry!['id']).update({
            'title': title,
            'content': content,
            'date': DateTime.now().toString(),
          });
        } else {
          await diaryRef.add({
            'title': title,
            'content': content,
            'date': DateTime.now().toString(),
          });
        }

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, top: 7.0),
                    child: Text(
                      widget.isEditing ? "Edit Note" : "Add Note",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 270),
                    child: TextButton(
                      onPressed: _saveNote,
                      child: const Text(
                        'SAVE',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: "Title"),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _contentController,
                        decoration: const InputDecoration(labelText: "Content"),
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
