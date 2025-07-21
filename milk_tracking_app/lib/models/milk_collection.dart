class MilkCollection {
  int? id;
  int vendorId;
  String date;
  double quantity;
  double rate;

  MilkCollection({
    this.id,
    required this.vendorId,
    required this.date,
    required this.quantity,
    required this.rate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'date': date,
      'quantity': quantity,
      'rate': rate,
    };
  }

  factory MilkCollection.fromMap(Map<String, dynamic> map) {
    return MilkCollection(
      id: map['id'],
      vendorId: map['vendor_id'],
      date: map['date'],
      quantity: map['quantity'],
      rate: map['rate'],
    );
  }
}
