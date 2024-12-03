import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/expenses%20manager/expense.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  final Map<DateTime, List<Expense>> _expenses = {};
  DateTime _currentDate = DateTime.now();

  double get totalIncome {
    return _expenses.entries
        .where((entry) => entry.key.isBefore(_currentDate) || entry.key.isAtSameMomentAs(_currentDate))
        .expand((entry) => entry.value)
        .where((exp) => exp.isIncome)
        .fold(0.0, (sum, exp) => sum + exp.amount);
  }

  double get totalExpenses {
    return _expenses.entries
        .where((entry) => entry.key.isBefore(_currentDate) || entry.key.isAtSameMomentAs(_currentDate))
        .expand((entry) => entry.value)
        .where((exp) => !exp.isIncome)
        .fold(0.0, (sum, exp) => sum + exp.amount);
  }

  double get balance => totalIncome - totalExpenses;

  double get progress {
    return totalIncome > 0 ? (totalExpenses / totalIncome) : 0.0;
  }

  DateTime get currentDate => _currentDate;

  List<Expense> get expensesForDate => _expenses[_currentDate] ?? [];

  void addExpense(double amount, String title) {
    final expense = Expense(amount, title, false, _currentDate);
    if (_expenses[_currentDate] == null) _expenses[_currentDate] = [];
    _expenses[_currentDate]!.add(expense);
    notifyListeners();
  }

  void addIncome(double amount, String title) {
    final income = Expense(amount, title, true, _currentDate);
    if (_expenses[_currentDate] == null) _expenses[_currentDate] = [];
    _expenses[_currentDate]!.add(income);
    notifyListeners();
  }

  void changeDate(DateTime newDate) {
    _currentDate = newDate;
    notifyListeners();
  }
  
  List<Expense> get allTransactions {
  return _expenses.values.expand((list) => list).toList();
  }

}
