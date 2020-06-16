class DetailApproval {
  final String auth;
  final String branch;
  final String employeeNo;
  final String employeeName;
  final String registerDate;
  final String approvalDate;

  DetailApproval(
      {this.auth,
      this.branch,
      this.employeeNo,
      this.employeeName,
      this.registerDate,
      this.approvalDate});

  factory DetailApproval.fromJson(Map<String, dynamic> json) {
    return DetailApproval(
      auth: json['auth'] as String,
      branch: json['branch'] as String,
      employeeNo: json['employeeNo'] as String,
      employeeName: json['employeeName'] as String,
      registerDate: json['registerDate'] as String,
      approvalDate: json['approvalDate'] as String,
    );
  }
}
