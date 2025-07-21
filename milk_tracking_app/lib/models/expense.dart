class Expense {
  int? id;
  String date;
  String description;
  double amount;

  Expense({
    this.id,
    required this.date,
    required this.description,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'description': description,
      'amount': amount,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      date: map['date'],
      description: map['description'],
      amount: map['amount'],
    );
  }
}
