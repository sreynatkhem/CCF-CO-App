class DetailApproval {
  final String authorizerEmpName;
  final String authorizationBranchCode;
  final String authorizerEmployeeNo;
  final String applicationDate;
  final String loanApprovalApplicationNo;
  final String acceptanceDate;

  DetailApproval({
    this.authorizerEmpName,
    this.authorizationBranchCode,
    this.authorizerEmployeeNo,
    this.applicationDate,
    this.loanApprovalApplicationNo,
    this.acceptanceDate,
  });

  factory DetailApproval.fromJson(Map<String, dynamic> json) {
    return DetailApproval(
      authorizerEmpName: json['authorizerEmpName'] as String,
      authorizationBranchCode: json['authorizationBranchCode'] as String,
      authorizerEmployeeNo: json['authorizerEmployeeNo'] as String,
      applicationDate: json['applicationDate'] as String,
      loanApprovalApplicationNo: json['loanApprovalApplicationNo'] as String,
      acceptanceDate: json['acceptanceDate'] as String,
    );
  }
}
