class ListLoanNew {
  String lcode;
  String bcode;
  String ucode;
  String customer;
  String purpose;
  String lamt;
  String currency;
  String intrate;
  String irr;
  String lstatus;
  String pcode;
  String odate;
  String expdate;
  String user;
  String branch;
  ListLoanNew(
      {this.bcode,
      this.branch,
      this.currency,
      this.customer,
      this.expdate,
      this.intrate,
      this.irr,
      this.lamt,
      this.lcode,
      this.lstatus,
      this.odate,
      this.pcode,
      this.purpose,
      this.ucode,
      this.user});
  factory ListLoanNew.fromJson(Map<String, dynamic> json) {
    return ListLoanNew(
      lcode: json['lcode'] as String,
      bcode: json['bcode'] as String,
      ucode: json['ucode'] as String,
      customer: json['customer'] as String,
      purpose: json['purpose'] as String,
      lamt: json['lamt'] as String,
      currency: json['currency'] as String,
      intrate: json['intrate'] as String,
      irr: json['irr'] as String,
      lstatus: json['lstatus'] as String,
      pcode: json['pcode'] as String,
      odate: json['odate'] as String,
      expdate: json['expdate'] as String,
      user: json['user'] as String,
      branch: json['branch'] as String,
    );
  }
}
