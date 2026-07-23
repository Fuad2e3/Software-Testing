class Company {
  final int? id;
  final int userId;
  final String companyName;
  final String? email;
  final String? contact;
  final String? createdAt;

  Company({
    this.id,
    required this.userId,
    required this.companyName,
    this.email,
    this.contact,
    this.createdAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      userId: json['user_id'],
      companyName: json['company_name'],
      email: json['email'],
      contact: json['contact'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'company_name': companyName,
      'email': email,
      'contact': contact,
    };
  }
}
