import 'package:json_annotation/json_annotation.dart';
import "loan.dart";
import "loanApplications.dart";
part 'requestDetailLoan.g.dart';

@JsonSerializable()
class RequestDetailLoan {
    RequestDetailLoan();

    String rcode;
    String ucode;
    String bcode;
    String lcode;
    String rdate;
    String rstatus;
    String user;
    Loan loan;
    LoanApplications loanApplications;
    
    factory RequestDetailLoan.fromJson(Map<String,dynamic> json) => _$RequestDetailLoanFromJson(json);
    Map<String, dynamic> toJson() => _$RequestDetailLoanToJson(this);
}
