// import 'package:json_annotation/json_annotation.dart';

part 'branch.g.dart';

// @JsonSerializable()
class Branch {
  // Branch();

  String? bcode;
  String? bname;
  String? odate;
  String? bmname;
  String? procode;
  String? discode;
  String? comcode;
  String? vilcode;
  String? customer;

  // factory Branch.fromJson(Map<String?, dynamic> json) => _$BranchFromJson(json);
  Map<String?, dynamic> toJson() => _$BranchToJson(this);
}
