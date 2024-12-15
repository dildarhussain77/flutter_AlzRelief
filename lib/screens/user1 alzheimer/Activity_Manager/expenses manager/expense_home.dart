import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/expenses%20manager/expenses_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'expense_history.dart';

class ExpensesHome extends StatefulWidget {
  const ExpensesHome({super.key});

  @override
  _ExpensesHomeState createState() => _ExpensesHomeState();
}

class _ExpensesHomeState extends State<ExpensesHome> {
  @override
  void initState() {
    super.initState();
    // Fetch all expenses when the widget initializes.
    final expenseProvider = Provider.of<ExpenseData>(context, listen: false);
    expenseProvider.fetchAllExpenses(); // Ensure this function loads all user expenses.
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseData>(context);
    final formatter = DateFormat('yyyy-MM-dd');

    // Get current hour for greeting
    final currentHour = DateTime.now().hour;
    final greeting = currentHour < 12
        ? "Good Morning!"
        : currentHour < 17
            ? "Good Afternoon!"
            : "Good Evening!";

    void showAddDialog(bool isIncome) {
      showDialog(
        context: context,
        builder: (context) {
          double amount = 0.0;
          String title = '';
          return AlertDialog(
            title: Text(isIncome ? 'Add Income' : 'Add Expense'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount',
                  ),
                  onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (amount > 0) {
                    if (isIncome) {
                      expenseProvider.addIncome(amount, title);
                    } else {
                      expenseProvider.addExpense(amount, title);
                    }
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Add'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(95, 37, 133, 1.0),
        body: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    greeting,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.history, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HistoryScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Linear Progress Bar
                  Expanded(
                    child: LinearProgressIndicator(
                      value: expenseProvider.progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                      minHeight: 10,
                    ),
                  ),
                  // Progress Percentage
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${(expenseProvider.progress * 100).toStringAsFixed(0)}%', // Shows percentage
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Totals and Balance Display
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    'Total Income: ${expenseProvider.totalIncome.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Total Expenses: ${expenseProvider.totalExpenses.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Balance: ${expenseProvider.balance.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),


            // Current Date Text
          

            // List of Expenses
            Expanded(
              
              
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  )
                ),

                
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Today\'s Transactions: ${formatter.format(DateTime.now())}',  // Display today's date
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                
              

                    
                    Expanded(
                      child: ListView.builder(
                        itemCount: expenseProvider.expensesForDate.length,
                        itemBuilder: (context, index) {
                          final expense = expenseProvider.expensesForDate[index];
                          return ListTile(
                            title: Text(
                              expense.title,
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              '${formatter.format(expense.date)}   - ${expense.amount.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Icon(
                              expense.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                              color: expense.isIncome ? Colors.green[400] : Colors.red[400],
                            ),
                          );
                        },
                      ),
                    ),
                 ],
                ),
              ),
            ),

            // Add Income/Expense Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => showAddDialog(true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
                    child: Text('Add Income',style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () => showAddDialog(false),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
                    child: Text('Add Expense',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
