import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/expenses%20manager/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expenses_data.dart'; // Update the path based on your folder structure.

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch all expenses when the screen is initialized
    final expenseData = Provider.of<ExpenseData>(context, listen: false);
    expenseData.fetchAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final expenseData = Provider.of<ExpenseData>(context);

    // Group expenses by date
    Map<String, List<Expense>> groupedExpenses = {};
    for (var expense in expenseData.expenses) {
      String dateKey = '${expense.date.year}-${expense.date.month}-${expense.date.day}';
      if (groupedExpenses.containsKey(dateKey)) {
        groupedExpenses[dateKey]!.add(expense);
      } else {
        groupedExpenses[dateKey] = [expense];
      }
    }

    List<String> dates = groupedExpenses.keys.toList();
    dates.sort((a, b) => b.compareTo(a));  // Sort dates in descending order

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Transactions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: dates.isEmpty
          ? const Center(child: Text('No Expenses Found'))
          : ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, dateIndex) {
                String dateKey = dates[dateIndex];
                List<Expense> expensesForDate = groupedExpenses[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider and date header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        color: Color.fromRGBO(95, 37, 133, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            dateKey,  // Date header
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    // Expenses for this date
                    ...expensesForDate.map((expense) {
                      return ListTile(
                        title: Text(expense.title),
                        subtitle: Text(expense.date.toString()),
                        trailing: Text(
                          '${expense.isIncome ? '+' : '-'}${expense.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: expense.isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    }),
                    // Divider after the last expense for this date
                    if (dateIndex < dates.length - 1)
                      const Divider(),  // Divider between groups of expenses
                  ],
                );
              },
            ),
    );
  }
}
