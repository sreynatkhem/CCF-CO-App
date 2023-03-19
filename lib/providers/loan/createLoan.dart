import 'package:chokchey_finance/models/listLoanNew.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class LoanInternal with ChangeNotifier {
  bool _isFetching = false;
  final data = [];
  final storage = new FlutterSecureStorage();
  var listCustomerByID = [];
  var totalLoans = '';
  var dataRegistration = [];

  // Future<List<ValueListCustomers>> fetchCustomerByUserLogin() async {
  //   _isFetching = true;
  //   var user_ucode = await storage.read(key: 'user_ucode');
  //   var token = await storage.read(key: 'user_token');
  //   try {
  //     _isFetching = false;
  //     final response = await api().get(
  //       baseURLInternal + 'valuelists/customers/' + user_ucode,
  //       headers: {
  //         "contentType": "application/json",
  //         "Authorization": "Bearer " + token
  //       },
  //     );
  //     final list = jsonDecode(response.body);
  //     data.add(list);
  //     notifyListeners();
  //     return list
  //         .map<ValueListCustomers>((json) => ValueListCustomers.fromJson(json))
  //         .toList();
  //   } catch (error) {
  //     _isFetching = false;
  //   }
  // }

  // Future<List<CreateLoan>> postLoanRegistration(
  //     idCcode,
  //     valueAmount,
  //     curcode,
  //     pcode,
  //     valueNumberofTerm,
  //     valueInterest,
  //     valueAdminFee,
  //     valueMaintenanceFee,
  //     valueRepaymentMethod,
  //     valueMaturityDate,
  //     valueFirstRepaymentDate,
  //     valueGenerateGracePeriodNumber,
  //     valueLoanPurpose,
  //     valueLTV,
  //     valueDscr,
  //     valueORARD,
  //     valueReferByWho) async {
  //   _isFetching = true;
  //   var user_ucode = await storage.read(key: 'user_ucode');
  //   var branch = await storage.read(key: 'branch');
  //   var token = await storage.read(key: 'user_token');
  //   try {
  //     _isFetching = false;
  //     final boyrow =
  //         "{\n\t\"ucode\": \"$user_ucode\",\n\t\"bcode\": \"$branch\",\n\t\"ccode\": \"$idCcode\",\n\t\"curcode\": \"$curcode\",\n\t\"pcode\": \"$pcode\",\n\t\"lamt\": $valueAmount,\n\t\"ints\": $valueNumberofTerm,\n\t\"intrate\": $valueInterest,\n\t\"mfee\": $valueMaintenanceFee,\n\t\"afee\": $valueAdminFee,\n\t\"rmode\": \"$valueRepaymentMethod\",\n\t\"odate\": \"\",\n\t\"mdate\": \"$valueMaturityDate\",\n\t\"firdate\": \"$valueFirstRepaymentDate\",\n\t\"graperiod\": $valueGenerateGracePeriodNumber,\n\t\"lpourpose\": \"$valueLoanPurpose\",\n\t\"ltv\": $valueLTV,\n\t\"dscr\": $valueDscr,\n\t\"refby\": \"$valueReferByWho\"}";
  //     final response = await api().post(baseURLInternal + 'loans',
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer " + token
  //         },
  //         body: boyrow);
  //     final parsed = jsonDecode(response.body);
  //     dataRegistration.addAll(parsed);
  //     notifyListeners();
  //   } catch (error) {
  //     print('error: $error');
  //     _isFetching = false;
  //   }
  // }

  //Request list loan
  // Future<List<ListLoanNew>> getListLoan(
  Future getListLoan(
      _pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    _isFetching = true;
    try {
      _isFetching = false;
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var level = await storage.read(key: "level");
      var sdates = sdate != null ? sdate : '';
      var edates = edate != null ? edate : '';
      var codes = code != null ? code : '';
      var statuses = status != null ? status : '';
      var btlcode = status != null ? status : '';
      var bcodes;
      var ucode;
      if (level == '3') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        btlcode = '';
        ucode = codes != null && codes != "" ? codes : "";
      }

      if (level == '2') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        btlcode = user_ucode;
        ucode = code != null && code != "" ? code : '';
      }

      if (level == '1') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        ucode = user_ucode;
        btlcode = '';
      }

      if (level == '4' || level == '5' || level == '6') {
        bcodes = bcode != null && bcode != "" ? bcode : '';
        btlcode = '';
        ucode = code != null && code != "" ? code : '';
      }
      // bodyRow =
      //     "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      // bodyRow =
      //     "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";
      final Map<String, dynamic> bodyRow = {
        "pageSize": "$_pageSize",
        "pageNumber": "$_pageNumber",
        "ucode": "$ucode",
        "bcode": "$bcodes",
        "btlcode": "",
        "status": "",
        "code": "",
        "sdate": "$sdates",
        "edate": "$edates"
      };
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'loans/all/mobile'),
          headers: headers,
          body: json.encode(bodyRow));
      if (response.statusCode == 200) {
        final dynamic parsed = [];
        parsed.addAll(jsonDecode(response.body));
        data.addAll(parsed[0]['listLoans']);
        totalLoans = parsed[0]['totalLoan'].toString();
        notifyListeners();
        return parsed
            .map<ListLoanNew>((json) => ListLoanNew.fromJson(json))
            .toList();
      }
    } catch (error) {
      _isFetching = false;
    }
  }

  // get loan by id
  // Future<List<CreateLoan>> getLoanByID(loansID) async {
  Future getLoanByID(loansID) async {
    _isFetching = true;
    try {
      _isFetching = false;
      var token = await storage.read(key: 'user_token');
      final Response response = await api().get(
        Uri.parse(baseURLInternal + 'loans/' + loansID),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + '$token'
        },
      );
      final parsed = jsonDecode(response.body);
      // dynamic data = [];
      // data.add(parsed);
      notifyListeners();
      return parsed;
      // return data.map<CreateLoan>((json) => CreateLoan.fromJson(json)).toList();
    } catch (error) {
      print("error $error");
      _isFetching = false;
    }
  }

  // Future<List<CreateLoan>> eidtLoanRegistration(
  Future eidtLoanRegistration(
      lcode,
      idCcode,
      valueAmount,
      curcode,
      pcode,
      valueNumberofTerm,
      valueInterest,
      valueAdminFee,
      valueMaintenanceFee,
      valueRepaymentMethod,
      valueMaturityDate,
      valueFirstRepaymentDate,
      valueGenerateGracePeriodNumber,
      valueLoanPurpose,
      valueLTV,
      valueDscr,
      valueReferByWho) async {
    _isFetching = true;
    var user_ucode = await storage.read(key: 'user_ucode');
    var branch = await storage.read(key: 'branch');
    var token = await storage.read(key: 'user_token');
    try {
      _isFetching = false;
      // final boyrow =
      //     "{\n\t\"ucode\": \"$user_ucode\",\n\t\"bcode\": \"$branch\",\n\t\"ccode\": \"$idCcode\",\n\t\"curcode\": \"$curcode\",\n\t\"pcode\": \"$pcode\",\n\t\"lamt\": $valueAmount,\n\t\"ints\": $valueNumberofTerm,\n\t\"intrate\": $valueInterest,\n\t\"mfee\": $valueMaintenanceFee,\n\t\"afee\": $valueAdminFee,\n\t\"rmode\": \"$valueRepaymentMethod\",\n\t\"odate\": \"\",\n\t\"mdate\": \"$valueMaturityDate\",\n\t\"firdate\": \"$valueFirstRepaymentDate\",\n\t\"graperiod\": $valueGenerateGracePeriodNumber,\n\t\"lpourpose\": \"$valueLoanPurpose\",\n\t\"ltv\": $valueLTV,\n\t\"dscr\": $valueDscr,\n\t\"refby\": \"$valueReferByWho\",\n\t\"lstatus\": \"O\",\n\t\"lcode\": \"$lcode\"\n}";
      final Map<String, dynamic> bodyRow = {
        "ucode": "$user_ucode",
        "bcode": "$branch",
        "ccode": "$idCcode",
        "curcode": "$curcode",
        "pcode": "$pcode",
        "lamt": valueAmount,
        "ints": valueNumberofTerm,
        "intrate": valueInterest,
        "mfee": valueMaintenanceFee,
        "afee": valueAdminFee,
        "rmode": "$valueRepaymentMethod",
        "odate": "",
        "mdate": "$valueMaturityDate",
        "firdate": "$valueFirstRepaymentDate",
        "graperiod": "$valueGenerateGracePeriodNumber",
        "lpourpose": "$valueLoanPurpose",
        "ltv": "$valueLTV",
        "dscr": "$valueDscr",
        "refby": "$valueReferByWho",
        "lstatus": "O",
        "lcode": "$lcode"
      };
      final Response response = await api().put(
          Uri.parse(baseURLInternal + 'loans/' + lcode),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + '$token'
          },
          body: json.encode(bodyRow));
      final parsed = jsonDecode(response.body);
      data.add(parsed);
      notifyListeners();
    } catch (error) {
      print('error: $error');
      _isFetching = false;
    }
  }

  bool get isFetching => _isFetching;
  dynamic get dataRegist => dataRegistration;
}
