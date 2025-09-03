class User {
  final String id;
  final String email;
  final String token;
  final DateTime? expiryDate;

  User({
    required this.id,
    required this.email,
    required this.token,
    this.expiryDate,
  });
} 