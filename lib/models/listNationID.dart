import 'package:json_annotation/json_annotation.dart';
// part 'customers.g.dart';

@JsonSerializable()
class ListNationID {
  String id;
  String name;

  ListNationID({
    this.id,
    this.name,
  });

  factory ListNationID.fromJson(Map<String, dynamic> json) {
    return ListNationID(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
