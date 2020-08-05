import 'package:json_annotation/json_annotation.dart';

import 'branch.dart';
// part 'customers.g.dart';

@JsonSerializable()
class Customers {
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
  String ntype;
  String nid;
  String ndate;
  String pro;
  String cstatus;
  Branch branch;
  String loan;
  String provinceName;
  String districtName;
  String communeName;
  String villageName;

  Customers(
      {this.ccode,
      this.ucode,
      this.bcode,
      this.acode,
      this.namekhr,
      this.nameeng,
      this.dob,
      this.gender,
      this.phone1,
      this.phone2,
      this.rdate,
      this.procode,
      this.discode,
      this.comcode,
      this.vilcode,
      this.goglocation,
      this.occupation,
      this.ntype,
      this.nid,
      this.ndate,
      this.pro,
      this.cstatus,
      this.branch,
      this.loan,
      this.provinceName,
      this.districtName,
      this.communeName,
      this.villageName});

  factory Customers.fromJson(Map<String, dynamic> json) {
    return Customers(
      ccode: json['ccode'] as String,
      ucode: json['ucode'] as String,
      bcode: json['bcode'] as String,
      acode: json['acode'] as String,
      namekhr: json['namekhr'] as String,
      nameeng: json['nameeng'] as String,
      dob: json['dob'] as String,
      gender: json['gender'] as String,
      phone1: json['phone1'] as String,
      phone2: json['phone2'] as String,
      rdate: json['rdate'] as String,
      procode: json['procode'] as String,
      discode: json['discode'] as String,
      comcode: json['comcode'] as String,
      vilcode: json['vilcode'] as String,
      goglocation: json['goglocation'] as String,
      occupation: json['occupation'] as String,
      ntype: json['ntype'] as String,
      nid: json['nid'] as String,
      ndate: json['ndate'] as String,
      pro: json['pro'] as String,
      cstatus: json['cstatus'] as String,
      branch: json['branch'] == null
          ? null
          : Branch.fromJson(json['branch'] as Map<String, dynamic>),
      loan: json['loan'] as String,
      provinceName: json['provinceName'] as String,
      districtName: json['districtName'] as String,
      communeName: json['communeName'] as String,
      villageName: json['villageName'] as String,
    );
  }
}
