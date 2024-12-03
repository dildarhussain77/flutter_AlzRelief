import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/expenses%20manager/expense_history.dart';
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/expenses%20manager/expenses_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import the intl package for DateFormat

class ExpensesHome extends StatelessWidget {
  const ExpensesHome({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseData = Provider.of<ExpenseData>(context);
    final formatter = DateFormat('yyyy-MM-dd');

      // Get current hour
    final currentHour = DateTime.now().hour;

    // Determine the greeting based on the current hour
    String greeting;
    if (currentHour < 12) {
      greeting = "Good Morning!";
    } else if (currentHour < 17) {
      greeting = "Good Afternoon!";
    } else {
      greeting = "Good Evening!";
    }


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
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount',
                  ),
                  onChanged: (value) {
                    amount = double.tryParse(value) ?? 0.0;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (amount > 0) {
                    if (isIncome) {
                      expenseData.addIncome(amount, title);
                    } else {
                      expenseData.addExpense(amount, title);
                    }
                  }
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

    void changeDate(bool next) {
      DateTime newDate = next
          ? expenseData.currentDate.add(Duration(days: 1))
          : expenseData.currentDate.subtract(Duration(days: 1));
      expenseData.changeDate(newDate);
    }

    final progressPercentage = expenseData.progress * 100;
    final remainingPercentage = 100 - progressPercentage;


    return SafeArea(
      child: Scaffold(      
        backgroundColor: Color.fromRGBO(95, 37, 133, 1.0),
        body: Column(
          children: [          
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 30, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.history,color: Colors.white,size: 30,),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HistoryScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.white, size: 30),
                  onPressed: () => changeDate(false), // Previous date
                ),
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: expenseData.progress,
                            strokeWidth: 7,
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation(Colors.red),
                          ),
                        ),
                        Column(
                          children: [                                                 
                            Text(
                              'Expenses: ${progressPercentage.toStringAsFixed(0)}%', // Expenses percentage
                              style: TextStyle(color: Colors.red, fontSize: 16,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5,),                                                                      
                            Text(
                              'Balance: ${remainingPercentage.toStringAsFixed(0)}%', // Remaining balance percentage
                              style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),                        
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text(
                      formatter.format(expenseData.currentDate), // Show current date
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 30),
                  onPressed: () => changeDate(true), // Next date
                ),
              ],
            ),
            SizedBox(height: 30,),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(expenseData.totalIncome  > expenseData.totalExpenses  ? 30.0 : 15.0),
                    topRight: Radius.circular(expenseData.totalIncome  > expenseData.totalExpenses  ? 30.0 : 15.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,                      
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Income: ${expenseData.totalIncome .toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Expenses: ${expenseData.totalExpenses .toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Balance: ${expenseData.balance.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.grey,fontSize: 16),
                            ),
                          ],
                        ),

                        Column(                          
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(                      
                              onPressed: () => showAddDialog(true), // Prompt for income
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Text color for Add Income button
                                minimumSize: Size(100, 40), // Set the size of the button (width, height)
                              ),
                              child: Text('Add Income',style: TextStyle(color: Colors.white),),
                            ),
                            ElevatedButton(                                                    
                              onPressed: () => showAddDialog(false), // Prompt for expense
                              style: ElevatedButton.styleFrom(                                
                                backgroundColor: Colors.red, // Text color for Add Income button
                                minimumSize: Size(100, 40), // Set the size of the button (width, height)
                              ),
                              child: Text('Add Expense',style: TextStyle(color: Colors.white,),),
                            ),
                          ],
                        ),
                      ],
                    ),                                      
                    
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: expenseData.expensesForDate.length,
                        itemBuilder: (context, index) {
                          final expense = expenseData.expensesForDate[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(10),
                            color: expense.isIncome ? Colors.green : Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  expense.title,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  expense.amount.toStringAsFixed(2),
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}