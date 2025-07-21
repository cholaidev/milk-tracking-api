class MilkSale {
  int? id;
  int customerId;
  String date;
  double quantity;
  double rate;

  MilkSale({
    this.id,
    required this.customerId,
    required this.date,
    required this.quantity,
    required this.rate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'date': date,
      'quantity': quantity,
      'rate': rate,
    };
  }

  factory MilkSale.fromMap(Map<String, dynamic> map) {
    return MilkSale(
      id: map['id'],
      customerId: map['customer_id'],
      date: map['date'],
      quantity: map['quantity'],
      rate: map['rate'],
    );
  }
}
