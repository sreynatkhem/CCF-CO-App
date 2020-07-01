class ListApproval {
  final double applicationAmount;
  final dynamic customerNo;
  final dynamic customerName;
  final dynamic applicationDate;
  final dynamic loanApprovalApplicationNo;
  final dynamic creditRiskRatingGrade;
  final dynamic currencyCode;

  ListApproval({
    this.applicationAmount,
    this.customerNo,
    this.customerName,
    this.applicationDate,
    this.loanApprovalApplicationNo,
    this.creditRiskRatingGrade,
    this.currencyCode,
  });

  factory ListApproval.fromJson(Map<String, dynamic> json) {
    return ListApproval(
      applicationAmount: json['applicationAmount'] as double,
      customerNo: json['customerNo'] as dynamic,
      customerName: json['customerName'] as dynamic,
      applicationDate: json['applicationDate'] as dynamic,
      loanApprovalApplicationNo: json['loanApprovalApplicationNo'] as dynamic,
      creditRiskRatingGrade: json['creditRiskRatingGrade'] as dynamic,
      currencyCode: json['currencyCode'] as dynamic,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'applicationAmount': applicationAmount,
  //     'customerNo': customerNo,
  //     'customerName': customerName,
  //     'applicationDate': applicationDate,
  //     'loanApprovalApplicationNo': loanApprovalApplicationNo,
  //     'creditRiskRatingGrade': creditRiskRatingGrade,
  //     'currencyCode': currencyCode,
  //   };
  // }
}
