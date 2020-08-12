import 'package:json_annotation/json_annotation.dart';
import "customerRegistration.dart";
part 'listLoanRequests.g.dart';

@JsonSerializable()
class ListLoanRequests {
    ListLoanRequests();

    String rcode;
    String ucode;
    String bcode;
    String lcode;
    String rdate;
    String rstatus;
    String user;
    CustomerRegistration loan;
    
    factory ListLoanRequests.fromJson(Map<String,dynamic> json) => _$ListLoanRequestsFromJson(json);
    Map<String, dynamic> toJson() => _$ListLoanRequestsToJson(this);
}
