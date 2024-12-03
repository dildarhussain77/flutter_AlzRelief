
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/Personal%20Diary/note_class.dart';
import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      // Remove leading blank lines from content
      final lines = content.split('\n');
      int startIndex = 0;

      // Find the index of the first non-blank line
      while (startIndex < lines.length && lines[startIndex].trim().isEmpty) {
        startIndex++;
      }

      // Join lines from the first non-blank line onwards
      final trimmedContent = lines.sublist(startIndex).join('\n');

      final note = Note(
        title: title,
        content: trimmedContent,
        date: DateTime.now(),
      );
      Navigator.pop(context, note);
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
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, top:7.0),
                    child: Text(
                      "Add Note",
                      style: TextStyle(
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
                      child: Text(
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
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 5,
                  right: 5,
                ),
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
                        decoration: InputDecoration(labelText: "Title"),
                      ),
                      TextField(
                        controller: _contentController,
                        decoration: InputDecoration(labelText: "Content"),
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                      ),
                    ]                  
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
