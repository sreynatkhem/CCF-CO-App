import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
    User();

    String ucode;
    String uid;
    String upassword;
    num ulevel;
    String bcode;
    String datecreate;
    String isapprover;
    String ustatus;
    String exdate;
    String uname;
    String u1;
    String u2;
    String u3;
    String u4;
    String u5;
    String loan;
    String customer;
    
    factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}
