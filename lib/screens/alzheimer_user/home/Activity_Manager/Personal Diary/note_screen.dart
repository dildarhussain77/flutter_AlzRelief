
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/Personal%20Diary/add_note.dart';
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/Personal%20Diary/note_detail_screen.dart';
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/Personal%20Diary/note_class.dart';
import 'package:alzrelief/util/image_logo_helper.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final List<Note> _notes = [];

  void _deleteNote(Note note) {
    setState(() {
      _notes.remove(note);
    });
  }

  void _showNoteInformation(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Note Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Title: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Optional, set the color as needed
                        ),
                      ),
                      TextSpan(
                        text: '${note.title}\n', // Adding a newline if needed
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Date Created: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${note.date}',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
                // Adjust this as per your date format
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Initial notes can be loaded here if needed
  }

  void _addNote() async {
    Note? newNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNoteScreen()),
    );
    if (newNote != null) {
      setState(() {
        _notes.add(newNote);
      });
    }
  }

  void _viewNoteDetails(Note note) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(
          note: note,
          onUpdate: (updatedNote) {
            setState(() {
              int index = _notes.indexWhere((n) => n.date == updatedNote.date);
              if (index != -1) {
                _notes[index] = updatedNote;
              }
            });
          },
          onDelete: (noteToDelete) {
            setState(() {
              _notes.remove(noteToDelete);
            });
          },
        ),
      ),
    );
    if (updatedNote != null) {
      setState(() {
        int index = _notes.indexWhere((n) => n.date == updatedNote.date);
        if (index != -1) {
          _notes[index] = updatedNote;
        }
      });
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
                  Center(
                    child: LogoImage(
                      imagePath: 'assets/images/diary.png',
                      borderColor: null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                
                
                                                                           
                child: Column(
                  children: [
                    SizedBox(height: 8,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Notes', // The text you want to display
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    
                    Expanded(
                      child: ListView.builder(
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {                      
                          final note = _notes[index];
                          return Container(
                            height: 75, // Set the height you prefer
                            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),                                          
                            child: Card(
                              color: Colors.white, // Set the card color to white                       
                              child: Stack(
                                children: [                            
                                  ListTile(
                                    
                                    contentPadding: EdgeInsets.only(right: 45,left: 15), // Add space on the right for the PopupMenuButton
                                    title: Text(note.title, style: TextStyle(fontWeight: FontWeight.bold),),
                                    subtitle: Text(note.content,  maxLines: 1,),
                                    onTap: () => _viewNoteDetails(note),
                                  ),
                                  Positioned(
                                    right: 0, // Position it at the right edge
                                    top: 0,
                                    bottom: 0,
                                    child: Align(
                                      alignment: Alignment.centerRight, // Center it vertically
                                      child: PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'info') {
                                            _showNoteInformation(note);
                                          } else if (value == 'delete') {
                                            _deleteNote(note);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            PopupMenuItem<String>(
                                              value: 'info',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.info),
                                                  SizedBox(width: 8),
                                                  Text('Information'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete),
                                                  SizedBox(width: 8),
                                                  Text('Delete'),
                                                ],
                                              ),
                                            ),
                                          ];
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(95, 37, 133, 1.0),
          onPressed: _addNote,
          child: Icon(Icons.add, color: Colors.white,),
        ),
      ),
    );
  }
}
