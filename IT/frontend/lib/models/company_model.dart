class Company {
  final int? id;
  final int userId;
  final String companyName;
  final String? website;
  final String? email;
  final String? emailSource;
  final String? contact;
  final String? contactSource;
  final String? createdAt;

  Company({
    this.id,
    required this.userId,
    required this.companyName,
    this.website,
    this.email,
    this.emailSource,
    this.contact,
    this.contactSource,
    this.createdAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      userId: json['user_id'],
      companyName: json['company_name'],
      website: json['website'],
      email: json['email'],
      emailSource: json['email_source'],
      contact: json['contact'],
      contactSource: json['contact_source'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'company_name': companyName,
      'website': website,
      'email': email,
      'email_source': emailSource,
      'contact': contact,
      'contact_source': contactSource,
    };
  }
}
