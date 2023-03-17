// import "createLoan.dart";
// // part 'listLoan.g.dart';

// // @JsonSerializable()
// class ListLoan {
//   // ListLoan();

//   num? totalLoan;
//   num? totalPage;
//   num? totalOpen;
//   num? totalApprove;
//   num? totalRequest;
//   num? totalReturn;
//   num? totalDisapprove;
//   CreateLoan? listLoans;

//   ListLoan(
//       {this.totalApprove,
//       this.totalDisapprove,
//       this.totalLoan,
//       this.totalOpen,
//       this.totalPage,
//       this.totalRequest,
//       this.totalReturn,
//       this.listLoans});

//   factory ListLoan.fromJson(Map<String, dynamic> json) {
//     return ListLoan(
//       totalApprove: json['totalApprove'] as num?,
//       totalDisapprove: json['totalDisapprove'] as num?,
//       totalLoan: json['totalLoan'] as num?,
//       totalOpen: json['totalOpen'] as num?,
//       totalPage: json['totalPage'] as num?,
//       totalRequest: json['totalRequest'] as num?,
//       totalReturn: json['totalReturn'] as num?,
//       // listLoans: json['listLoans'] == null
//       //     ? null
//       //     : CreateLoan.fromJson(json['listLoans'] as Map<String, dynamic>
//       //     )
//     );
//   }

//   // factory ListLoan.fromJson(Map<String,dynamic> json) :> _$ListLoanFromJson(json);
//   // Map<String, dynamic> toJson() :> _$ListLoanToJson(this);

//   // String lcode;
//   // String ucode;
//   // String bcode;
//   // String ccode;
//   // String curcode;
//   // String pcode;
//   // double lamt;
//   // double ints;
//   // double intrate;
//   // double mfee;
//   // double afee;
//   // double irr;
//   // String rmode;
//   // String expdate;
//   // String odate;
//   // String mdate;
//   // String firdate;
//   // double graperiod;
//   // String lpourpose;
//   // double ltv;
//   // double dscr;
//   // String refby;
//   // String lstatus;
//   // String u1;
//   // String u2;
//   // String u3;
//   // String u4;
//   // String u5;
//   // String branch;
//   // String customer;
//   // String user;
//   // String loanProduct;
//   // String currency;
//   // String customerOccupation;
//   // LoanRequest loanRequest;

//   // ListLoan(
//   //     {this.lcode,
//   //     this.ucode,
//   //     this.bcode,
//   //     this.ccode,
//   //     this.curcode,
//   //     this.pcode,
//   //     this.lamt,
//   //     this.ints,
//   //     this.intrate,
//   //     this.mfee,
//   //     this.afee,
//   //     this.irr,
//   //     this.rmode,
//   //     this.expdate,
//   //     this.odate,
//   //     this.mdate,
//   //     this.firdate,
//   //     this.graperiod,
//   //     this.lpourpose,
//   //     this.ltv,
//   //     this.dscr,
//   //     this.refby,
//   //     this.lstatus,
//   //     this.u1,
//   //     this.u2,
//   //     this.u3,
//   //     this.u4,
//   //     this.u5,
//   //     this.branch,
//   //     this.customer,
//   //     this.user,
//   //     this.currency,
//   //     this.loanProduct,
//   //     this.customerOccupation,
//   //     this.loanRequest});
//   // factory ListLoan.fromJson(Map<String, dynamic> json) {
//   //   return ListLoan(
//   //       lcode: json['lcode'] as String,
//   //       ucode: json['ucode'] as String,
//   //       bcode: json['bcode'] as String,
//   //       ccode: json['ccode'] as String,
//   //       curcode: json['curcode'] as String,
//   //       pcode: json['pcode'] as String,
//   //       lamt: (json['lamt'] as num?).toDouble(),
//   //       ints: (json['ints'] as num?).toDouble(),
//   //       intrate: (json['intrate'] as num?).toDouble(),
//   //       mfee: (json['mfee'] as num?).toDouble(),
//   //       afee: (json['afee'] as num?).toDouble(),
//   //       irr: (json['irr'] as num?).toDouble(),
//   //       rmode: json['rmode'] as String,
//   //       expdate: json['expdate'] as String,
//   //       odate: json['odate'] as String,
//   //       mdate: json['mdate'] as String,
//   //       firdate: json['firdate'] as String,
//   //       graperiod: json['graperiod'] as double,
//   //       lpourpose: json['lpourpose'] as String,
//   //       ltv: (json['ltv'] as num?).toDouble(),
//   //       dscr: (json['dscr'] as num?).toDouble(),
//   //       refby: json['refby'] as String,
//   //       lstatus: json['lstatus'] as String,
//   //       u1: json['u1'] as String,
//   //       u2: json['u2'] as String,
//   //       u3: json['u3'] as String,
//   //       u4: json['u4'] as String,
//   //       u5: json['u5'] as String,
//   //       branch: json['branch'] as String,
//   //       customer: json['customer'] as String,
//   //       user: json['user'] as String,
//   //       loanProduct: json['loanProduct'] as String,
//   //       currency: json['currency'] as String,
//   //       customerOccupation: json['customerOccupation'] as String,
//   //       loanRequest: json['loanRequest'] == null
//   //           ? null
//   //           : LoanRequest.fromJson(
//   //               json['loanRequest'] as Map<String, dynamic>));
//   // }
// }
