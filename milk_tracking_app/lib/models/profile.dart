class Profile {
  int? id;
  String name;
  String email;
  String businessName;
  String contact;

  Profile({
    this.id,
    required this.name,
    required this.email,
    required this.businessName,
    required this.contact,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'business_name': businessName,
      'contact': contact,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      businessName: map['business_name'],
      contact: map['contact'],
    );
  }
}
