import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LoginModels {
  LoginModels(
      {this.branch,
      this.level,
      this.token,
      this.ucode,
      this.uid,
      this.uname,
      this.changePassword,
      this.roles});

  String ucode;
  String uid;
  String token;
  num level;
  String branch;
  String uname;
  List<dynamic> roles;
  String changePassword;

  factory LoginModels.fromJson(Map<String, dynamic> json) {
    return LoginModels(
      ucode: json['ucode'] as String,
      uid: json['uid'] as String,
      token: json['token'] as String,
      level: json['level'] as num,
      branch: json['branch'] as String,
      uname: json['uname'] as String,
      changePassword: json['changePassword'] as String,
      roles: json['roles'] as List<dynamic>,
    );
  }
}
