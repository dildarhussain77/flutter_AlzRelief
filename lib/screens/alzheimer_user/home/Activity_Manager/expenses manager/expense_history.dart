import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/expenses%20manager/expense.dart';
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/expenses%20manager/expenses_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseData = Provider.of<ExpenseData>(context);
    final allTransactions = expenseData.allTransactions;

    // Group transactions by date
    final groupedTransactions = groupTransactionsByDate(allTransactions);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: ListView.builder(
        itemCount: groupedTransactions.length,
        itemBuilder: (context, index) {
          final date = groupedTransactions.keys.elementAt(index);
          final transactions = groupedTransactions[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat('MMMM d, yyyy').format(date),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    title: Text(transaction.title),
                    subtitle: Text(transaction.amount.toStringAsFixed(2)),
                    trailing: Text(
                      transaction.isIncome ? 'Income' : 'Expense',
                      style: TextStyle(
                        color: transaction.isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  Map<DateTime, List<Expense>> groupTransactionsByDate(List<Expense> transactions) {
    final groupedTransactions = <DateTime, List<Expense>>{};
    for (var transaction in transactions) {
      final date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }
    return Map.fromEntries(groupedTransactions.entries.toList()..sort((a, b) => b.key.compareTo(a.key)));
  }
}