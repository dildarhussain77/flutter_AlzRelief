import 'package:flutter/material.dart';
import 'note_class.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  final Function(Note) onUpdate;
  final Function(Note) onDelete;

  const NoteDetailScreen({
    super.key,
    required this.note,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

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

      final updatedNote = Note(
        title: title,
        content: trimmedContent,
        date: widget.note.date,
      );
      Navigator.pop(context, updatedNote);
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
                      "Edit Note",
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
                      SizedBox(height: 5.0,),
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
