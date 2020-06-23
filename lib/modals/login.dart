class LoginModals {
  final String userId;
  final String name;

  LoginModals({this.userId, this.name});

  factory LoginModals.fromJson(Map<String, dynamic> json) {
    return LoginModals(
      userId: json['user_id'] as String,
      name: json['user_name'] as String,
    );
  }
}
