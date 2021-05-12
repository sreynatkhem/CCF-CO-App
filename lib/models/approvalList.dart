class Approval {
  final String? standardCodeDomainName2;
  final String? authorizationRequestBranchCode;
  final String? standardCodeDomainName1;
  final String? authorizationRequestEmpNo;
  final String? authorizationRequestDate;
  final String? authorizationRequestTime;
  final String? branchName;
  final String? authorizationRequestEmpName;
  final String? loanApprovalApplicationNo;
  final String? authorizationOpinionContents;

  Approval({
    this.standardCodeDomainName2,
    this.authorizationRequestBranchCode,
    this.standardCodeDomainName1,
    this.authorizationRequestEmpNo,
    this.authorizationRequestDate,
    this.authorizationRequestTime,
    this.branchName,
    this.authorizationRequestEmpName,
    this.loanApprovalApplicationNo,
    this.authorizationOpinionContents,
  });

  factory Approval.fromJson(Map<String?, dynamic> json) {
    return Approval(
      standardCodeDomainName2: json['standardCodeDomainName2'] as String?,
      authorizationRequestBranchCode:
          json['authorizationRequestBranchCode'] as String?,
      standardCodeDomainName1: json['standardCodeDomainName1'] as String?,
      authorizationRequestEmpNo: json['authorizationRequestEmpNo'] as String?,
      authorizationRequestDate: json['authorizationRequestDate'] as String?,
      authorizationRequestTime: json['authorizationRequestTime'] as String?,
      branchName: json['branchName'] as String?,
      authorizationRequestEmpName:
          json['authorizationRequestEmpName'] as String?,
      loanApprovalApplicationNo: json['loanApprovalApplicationNo'] as String?,
      authorizationOpinionContents:
          json['authorizationOpinionContents'] as String?,
    );
  }
}
