// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customerRegistration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerRegistration _$CustomerRegistrationFromJson(Map<String, dynamic> json) {
  return CustomerRegistration()
    ..ccode = json['ccode'] as String
    ..ucode = json['ucode'] as String
    ..bcode = json['bcode'] as String
    ..acode = json['acode'] as String
    ..namekhr = json['namekhr'] as String
    ..nameeng = json['nameeng'] as String
    ..dob = json['dob'] as String
    ..gender = json['gender'] as String
    ..phone1 = json['phone1'] as String
    ..phone2 = json['phone2'] as String
    ..rdate = json['rdate'] as String
    ..procode = json['procode'] as String
    ..discode = json['discode'] as String
    ..comcode = json['comcode'] as String
    ..vilcode = json['vilcode'] as String
    ..goglocation = json['goglocation'] as String
    ..occupation = json['occupation'] as String
    ..nid = json['nid'] as String
    ..ndate = json['ndate'] as String
    ..pro = json['pro'] as String
    ..cstatus = json['cstatus'] as String
    ..u1 = json['u1'] as String
    ..u2 = json['u2'] as String
    ..u3 = json['u3'] as String
    ..u4 = json['u4'] as String
    ..u5 = json['u5'] as String
    ..ntype = json['ntype'] as String
    ..provinceName = json['provinceName'] as String
    ..districtName = json['districtName'] as String
    ..communeName = json['communeName'] as String
    ..villageName = json['villageName'] as String
    ..fullAddress = json['fullAddress'] as String
    ..user = json['user'] as String
    ..loan = json['loan'] as String;
  // ..branch = json['branch'] == null
  //     ? null
  //     : Branch.fromJson(json['branch'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CustomerRegistrationToJson(
        CustomerRegistration instance) =>
    <String, dynamic>{
      'ccode': instance.ccode,
      'ucode': instance.ucode,
      'bcode': instance.bcode,
      'acode': instance.acode,
      'namekhr': instance.namekhr,
      'nameeng': instance.nameeng,
      'dob': instance.dob,
      'gender': instance.gender,
      'phone1': instance.phone1,
      'phone2': instance.phone2,
      'rdate': instance.rdate,
      'procode': instance.procode,
      'discode': instance.discode,
      'comcode': instance.comcode,
      'vilcode': instance.vilcode,
      'goglocation': instance.goglocation,
      'occupation': instance.occupation,
      'nid': instance.nid,
      'ndate': instance.ndate,
      'pro': instance.pro,
      'cstatus': instance.cstatus,
      'u1': instance.u1,
      'u2': instance.u2,
      'u3': instance.u3,
      'u4': instance.u4,
      'u5': instance.u5,
      'ntype': instance.ntype,
      'provinceName': instance.provinceName,
      'districtName': instance.districtName,
      'communeName': instance.communeName,
      'villageName': instance.villageName,
      'fullAddress': instance.fullAddress,
      'user': instance.user,
      'loan': instance.loan,
      'branch': instance.branch
    };
