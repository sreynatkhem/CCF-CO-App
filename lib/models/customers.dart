import 'package:json_annotation/json_annotation.dart';
// part 'customers.g.dart';

@JsonSerializable()
class Customers {
  num id;
  String name;
  String username;
  String email;
  String profile_image;
  String phone;
  String website;
  Map<String, dynamic> company;
  Customers({
    this.id,
    this.name,
    this.username,
    this.email,
    this.profile_image,
    this.phone,
    this.website,
    this.company,
  });

  factory Customers.fromJson(Map<String, dynamic> json) {
    return Customers(
      id: json['id'] as num,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      profile_image: json['profile_image'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      company: json['company'] as Map<String, dynamic>,
    );
  }
}
