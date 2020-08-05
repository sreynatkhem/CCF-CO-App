import 'package:json_annotation/json_annotation.dart';

part 'customerRegistration.g.dart';

@JsonSerializable()
class CustomerRegistration {
  CustomerRegistration();

  String ccode;
  String ucode;
  String bcode;
  String acode;
  String namekhr;
  String nameeng;
  String dob;
  String gender;
  String phone1;
  String phone2;
  String rdate;
  String procode;
  String discode;
  String comcode;
  String vilcode;
  String goglocation;
  String occupation;
  String nid;
  String ndate;
  String pro;
  String cstatus;
  String u1;
  String u2;
  String u3;
  String u4;
  String u5;
  String ntype;
  String provinceName;
  String districtName;
  String communeName;
  String villageName;

  factory CustomerRegistration.fromJson(Map<String, dynamic> json) =>
      _$CustomerRegistrationFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerRegistrationToJson(this);
}
