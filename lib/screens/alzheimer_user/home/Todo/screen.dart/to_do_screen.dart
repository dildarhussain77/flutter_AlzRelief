import 'package:flutter/material.dart';
import 'package:alzrelief/screens/alzheimer_user/home/Todo/custom_textfield.dart';
import 'package:alzrelief/screens/alzheimer_user/home/Todo/model/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks(); // Load tasks when the page is initialized
  }

  Future<void> fetchTasks() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('alzheimer')
          .doc(user.uid)
          .collection('tasks')
          
          .get();

      setState(() {
        _tasks = snapshot.docs
        .map((doc) => Task.fromMap(doc.data(), doc.id))
        .toList();

        // Sort tasks by date (ascending order)
        _tasks.sort((a, b) => a.date.compareTo(b.date));
      });
    }
  }

  Future<void> addTask(String taskName, String date, String time) async {
    final user = _auth.currentUser;
    if (user != null) {
      final taskId = _firestore.collection('tasks').doc().id;
      final task = Task(id: taskId, taskName: taskName, date: date, time: time,isCompleted: false,);

      await _firestore
          .collection('alzheimer')
          .doc(user.uid)
          .collection('tasks')
          .doc(taskId)
          .set(task.toMap());

      fetchTasks(); // Refresh tasks
    }
  }

  Future<void> deleteTask(String taskId) async {
  final user = _auth.currentUser;

  if (user == null) {
    debugPrint("User not authenticated.");
    return;
  }

  final userId = user.uid;
  final tasksRef = _firestore
      .collection('alzheimer')
      .doc(userId)
      .collection('tasks');

  // Show confirmation dialog before deletion
  final shouldDelete = await _showDeleteConfirmationDialog(context);

  if (shouldDelete) {
    try {
      // Correct the task reference
      await tasksRef.doc(taskId).delete();
      debugPrint("Task deleted successfully.");
      fetchTasks(); // Refresh tasks after deletion
    } catch (e) {
      debugPrint("Error while deleting task: $e");
    }
  }
}


Future<bool> _showDeleteConfirmationDialog(BuildContext dialogContext) async {
  return await showDialog<bool>(
        context: dialogContext,
        builder: (context) => AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete"),
            ),
          ],
        ),
      ) ??
      false;
}



// ... similar modifications for updateTaskStatus

Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
  final user = _auth.currentUser;

  if (user != null) {
    final docRef = _firestore
        .collection('alzheimer')
        .doc(user.uid)
        .collection('tasks')
        .doc(taskId);

    try {
      // Check if the document exists before updating
      final taskDoc = await docRef.get();
      if (taskDoc.exists) {
        await docRef.update({'isCompleted': isCompleted});
        debugPrint("Task status updated.");
        fetchTasks().then((_) => setState(() {})); // Refresh tasks
      } else {
        debugPrint("Task not found: $taskId");
      }
    } catch (error) {
      debugPrint("Error updating task status: $error");
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        body: Column(
          children: [
            // Header Section
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
                  Center(
                    child: Text(
                      "To-Do List", style: TextStyle(
                        color: Colors.white, fontSize: 24, 
                        fontWeight: FontWeight.bold),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/todo.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main ListView Section
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                  bottom: 50,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: _tasks.isEmpty
                    ? const Center(
                        child: Text(
                          "No tasks available",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          return GestureDetector(
                            onTap: () {
                              // Toggle task completion state
                              setState(() {
                                task.isCompleted = !task.isCompleted;
                              });
                              updateTaskStatus(task.id, task.isCompleted);
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                title: Text(
                                  task.taskName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: task.isCompleted ? Colors.grey : Colors.black,
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                                  ),
                                ),
                                subtitle: Text(
                                  "Due: ${task.date} at ${task.time}",
                                  style: TextStyle(
                                    color: task.isCompleted ? Colors.grey : Colors.black54,
                                    fontStyle: task.isCompleted ? FontStyle.italic : FontStyle.normal,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: task.isCompleted ? Colors.green[500] : Colors.grey,
                                      size: 28,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        // Delete the task
                                        deleteTask(task.id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 5),
                      ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
          onPressed: () => _showCreateTaskDialog(context),
          child: const Icon(Icons.add, size: 35, color: Colors.white),
        ),
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    final TextEditingController taskController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final double sh = MediaQuery.sizeOf(context).height;
        final double sw = MediaQuery.sizeOf(context).width;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            height: sh * 0.5,
            width: sw * 0.8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Create New Task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 15),
                  const Text("What has to be done?", style: TextStyle(color: Colors.black)),
                  CustomTextField1(hint: "Enter Task", controller: taskController),
                  const SizedBox(height: 40),
                  const Text("Due Date", style: TextStyle(color: Colors.black)),
                  CustomTextField1(
                    hint: "Pick a Date",
                    readOnly: true,
                    icon: Icons.calendar_today,
                    controller: dateController,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        dateController.text = "${date.year}-${date.month}-${date.day}";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField1(
                    hint: "Pick a Time",
                    readOnly: true,
                    icon: Icons.timer,
                    controller: timeController,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        timeController.text = time.format(context);
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
                      ),
                      onPressed: () {
                        final taskName = taskController.text;
                        final date = dateController.text;
                        final time = timeController.text;

                        if (taskName.isNotEmpty && date.isNotEmpty && time.isNotEmpty) {
                          addTask(taskName, date, time);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Add Task", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
