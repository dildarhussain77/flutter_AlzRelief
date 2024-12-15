class Expense {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'isIncome': isIncome,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      isIncome: map['isIncome'] ?? false,
      date: DateTime.parse(map['date']),
    );
  }
}
