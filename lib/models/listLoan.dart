import 'package:json_annotation/json_annotation.dart';
import "createLoan.dart";
part 'listLoan.g.dart';

@JsonSerializable()
class ListLoan {
    ListLoan();

    num totalLoan;
    num totalPage;
    num totalApprove;
    num totalRequest;
    num totalReturn;
    num totalDisapprove;
    CreateLoan listLoans;
    
    factory ListLoan.fromJson(Map<String,dynamic> json) => _$ListLoanFromJson(json);
    Map<String, dynamic> toJson() => _$ListLoanToJson(this);
}
