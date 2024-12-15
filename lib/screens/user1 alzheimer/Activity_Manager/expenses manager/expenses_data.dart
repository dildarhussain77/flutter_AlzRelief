import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/expenses%20manager/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseData with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  DateTime _currentDate = DateTime.now();
  List<Expense> _expenses = [];
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;

  DateTime get currentDate => _currentDate;
  List<Expense> get expensesForDate =>
      _expenses.where((e) => isSameDate(e.date, _currentDate)).toList();
  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;
  double get balance => _totalIncome - _totalExpenses;
  double get progress =>
      (_totalIncome == 0) ? 0.0 : (_totalExpenses / _totalIncome).clamp(0.0, 1.0);

   /// Getter for all expenses
  List<Expense> get expenses => _expenses;

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void changeDate(DateTime newDate) {
    _currentDate = newDate;
    notifyListeners(); // Notify UI about the date change.
  }

  Future<void> fetchAllExpenses() async {
    final user = _auth.currentUser;

    if (user != null) {
      final userId = user.uid;
      final snapshot = await _firestore
          .collection('alzheimer')
          .doc(userId)
          .collection('expenses')
          .orderBy('date', descending: true)
          .get();

      _expenses = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Store document ID if needed.
        return Expense.fromMap(data);
      }).toList();

      _calculateTotals();
      notifyListeners();
    }
  }

  Future<void> addIncome(double amount, String title) async {
    final user = _auth.currentUser;

    if (user != null) {
      final userId = user.uid;
      final expense = Expense(
        id: UniqueKey().toString(),
        title: title,
        amount: amount,
        isIncome: true,
        date: DateTime.now(),
      );

      await _firestore
          .collection('alzheimer')
          .doc(userId)
          .collection('expenses')
          .doc(expense.id)
          .set(expense.toMap());
      await fetchAllExpenses(); // Refresh all expenses.
    }
  }

  Future<void> addExpense(double amount, String title) async {
    final user = _auth.currentUser;

    if (user != null) {
      final userId = user.uid;
      final expense = Expense(
        id: UniqueKey().toString(),
        title: title,
        amount: amount,
        isIncome: false,
        date: DateTime.now(),
      );

      await _firestore
          .collection('alzheimer')
          .doc(userId)
          .collection('expenses')
          .doc(expense.id)
          .set(expense.toMap());
      await fetchAllExpenses(); // Refresh all expenses.
    }
  }

  void _calculateTotals() {
    _totalIncome = _expenses
        .where((expense) => expense.isIncome)
        .fold(0.0, (sum, expense) => sum + expense.amount);
    _totalExpenses = _expenses
        .where((expense) => !expense.isIncome)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }
}
