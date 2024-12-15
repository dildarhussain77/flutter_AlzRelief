
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'add_diary_screen.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final List<Map<String, dynamic>> _diaryEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchDiaryEntries(); // Fetch diary entries when the screen loads
  }

  // Fetch diary entries from Firebase Firestore
  Future<void> _fetchDiaryEntries() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userId = user.uid;
    final diaryRef = FirebaseFirestore.instance
        .collection('alzheimer')
        .doc(userId)
        .collection('diary');

    // Order entries by the 'date' field in ascending order
    final snapshot = await diaryRef.orderBy('date', descending: true).get();

    setState(() {
      _diaryEntries.clear();
      for (var doc in snapshot.docs) {
        var entry = doc.data();
        entry['id'] = doc.id; // Add document ID to the entry
        _diaryEntries.add(entry);
      }
    });
  }
}


  // Format date to a readable format
  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMM dd, yyyy h:mm a').format(dateTime);
  }

  // Delete diary entry from Firebase
  Future<void> _deleteDiaryEntry(String entryId) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userId = user.uid;
    final diaryRef = FirebaseFirestore.instance
        .collection('alzheimer')
        .doc(userId)
        .collection('diary');

    // Show confirmation dialog before deletion
    final shouldDelete = await _showDeleteConfirmationDialog();

    if (shouldDelete) {
      await diaryRef.doc(entryId).delete();
      _fetchDiaryEntries(); // Refresh the diary list after deletion
    }
  }
}

Future<bool> _showDeleteConfirmationDialog() async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete Entry'),
        content: Text('Are you sure you want to delete this diary entry?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Return false if "Cancel" is pressed
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Return true if "Delete" is pressed
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red), // Highlight delete action
            ),
          ),
        ],
      );
    },
  ) ??
      false; // Return false if dialog is dismissed
}


  void _showDiaryInfoDialog(Map<String, dynamic> entry) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Entry Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(entry['title']),
            // SizedBox(height: 10), // Spacing between sections
            // Text(
            //   'Content:',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text(entry['content']),
            SizedBox(height: 5),
            Text(
              'Date:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_formatDate(entry['date'])), // Use the date formatting method
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 6),
            _buildDiaryList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddDiaryScreen(isEditing: false)),
            ).then((_) => _fetchDiaryEntries()); // Refresh after adding a new entry
          },
          backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
          tooltip: 'Add New Diary Entry',
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // Header Widget
  Widget _buildHeader() {
    return Padding(
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
            child: Text(
              "Personal Diary", style: TextStyle(
                color: Colors.white, fontSize: 24, 
                fontWeight: FontWeight.bold),
            )
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Center(
              child: Image.asset(
                'assets/images/diary.png',
                height: 150,
                width: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Diary List Widget with PopMenuButton
  Widget _buildDiaryList() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: _diaryEntries.isEmpty
            ? Center(
                child: Text(
                  'No entries found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(5.0),
                itemCount: _diaryEntries.length,
                itemBuilder: (context, index) {
                  final entry = _diaryEntries[index];
                  final formattedDate = _formatDate(entry['date']);
                  return _buildDiaryCard(entry, formattedDate);
                },
              ),
      ),
    );
  }

  // Diary Card Widget with PopupMenuButton
  Widget _buildDiaryCard(Map<String, dynamic> entry, String formattedDate) {
  return Container(
    height: 80,
    margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        leading: Icon(
          Icons.menu_book, // Icon for the diary
          color: Colors.blue[400], // You can change the color to match your design
        ),
        title: Text(
          entry['title'],
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Text(
            entry['content'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        onTap: () {
          // Navigate to AddDiaryScreen with existing diary entry to edit
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDiaryScreen(
                isEditing: true,
                diaryEntry: entry,
              ),
            ),
          ).then((_) => _fetchDiaryEntries()); // Refresh after editing
        },
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _deleteDiaryEntry(entry['id']); // Delete diary entry
            } else if (value == 'information') {
              _showDiaryInfoDialog(entry); // Show information dialog
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'information',
                child: Row(
                  children: const [
                    Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Information'),
                  ],
                ),
              ),
            ];
          },
        ),
      ),

    ),
  );
}

}
