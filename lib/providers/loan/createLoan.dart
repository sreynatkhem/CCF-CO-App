import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/models/listLoan.dart';
import 'package:chokchey_finance/models/valueListCustomers.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoanInternal with ChangeNotifier {
  bool _isFetching = false;
  final data = [];
  final storage = new FlutterSecureStorage();
  var listCustomerByID = [];
  var totalLoans = '';
  var dataRegistration = [];

  Future<List<ValueListCustomers>> fetchCustomerByUserLogin() async {
    _isFetching = true;
    var user_ucode = await storage.read(key: 'user_ucode');
    var token = await storage.read(key: 'user_token');
    try {
      _isFetching = false;
      final response = await api().get(
        baseURLInternal + 'valuelists/customers/' + user_ucode,
        headers: {
          "contentType": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final list = jsonDecode(response.body);
      data.add(list);
      notifyListeners();
      return list
          .map<ValueListCustomers>((json) => ValueListCustomers.fromJson(json))
          .toList();
    } catch (error) {
      _isFetching = false;
    }
  }

  Future<List<CreateLoan>> postLoanRegistration(
      idCcode,
      valueAmount,
      curcode,
      pcode,
      valueNumberofTerm,
      valueInterest,
      valueAdminFee,
      valueMaintenanceFee,
      valueRepaymentMethod,
      valueOpenDate,
      valueMaturityDate,
      valueFirstRepaymentDate,
      valueGenerateGracePeriodNumber,
      valueLoanPurpose,
      valueLTV,
      valueDscr,
      valueORARD,
      valueReferByWho) async {
    _isFetching = true;
    var user_ucode = await storage.read(key: 'user_ucode');
    var branch = await storage.read(key: 'branch');
    var token = await storage.read(key: 'user_token');
    try {
      _isFetching = false;
      final boyrow =
          "{\n\t\"ucode\": \"$user_ucode\",\n\t\"bcode\": \"$branch\",\n\t\"ccode\": \"$idCcode\",\n\t\"curcode\": \"$curcode\",\n\t\"pcode\": \"$pcode\",\n\t\"lamt\": $valueAmount,\n\t\"ints\": $valueNumberofTerm,\n\t\"intrate\": $valueInterest,\n\t\"mfee\": $valueMaintenanceFee,\n\t\"afee\": $valueAdminFee,\n\t\"rmode\": \"$valueRepaymentMethod\",\n\t\"odate\": \"$valueOpenDate\",\n\t\"mdate\": \"$valueMaturityDate\",\n\t\"firdate\": \"$valueFirstRepaymentDate\",\n\t\"graperiod\": $valueGenerateGracePeriodNumber,\n\t\"lpourpose\": \"$valueLoanPurpose\",\n\t\"ltv\": $valueLTV,\n\t\"dscr\": $valueDscr,\n\t\"refby\": \"$valueReferByWho\"}";
      final response = await api().post(baseURLInternal + 'loans',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: boyrow);
      final parsed = jsonDecode(response.body);
      dataRegistration.add(parsed);
      notifyListeners();
    } catch (error) {
      print('error: $error');
      _isFetching = false;
    }
  }

  //Request list loan
  Future<List<ListLoan>> getListLoan(_pageSize, _pageNumber) async {
    _isFetching = true;
    try {
      _isFetching = false;
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api().post(baseURLInternal + 'loans/byuser',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        final dynamic parsed = [];
        parsed.addAll(jsonDecode(response.body));
        data.addAll(parsed[0]['listLoans']);
        totalLoans = parsed[0]['totalLoan'].toString();
        notifyListeners();
        return jsonDecode(response.body)
            .map<ListLoan>((json) => ListLoan.fromJson(json))
            .toList();
      } else {
        print('statusCode::: ${response.statusCode}');
      }
    } catch (error) {
      _isFetching = false;
    }
  }

  // get loan by id
  Future<List<CreateLoan>> getLoanByID(loansID) async {
    _isFetching = true;
    try {
      _isFetching = false;
      var token = await storage.read(key: 'user_token');
      final response = await api().get(
        baseURLInternal + 'loans/' + loansID,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      dynamic data = [];
      data.add(parsed);
      notifyListeners();
      return data.map<CreateLoan>((json) => CreateLoan.fromJson(json)).toList();
    } catch (error) {
      print("error $error");

      _isFetching = false;
    }
  }

  Future<List<CreateLoan>> eidtLoanRegistration(
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
      valueOpenDate,
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
      final boyrow =
          "{\n\t\"ucode\": \"$user_ucode\",\n\t\"bcode\": \"$branch\",\n\t\"ccode\": \"$idCcode\",\n\t\"curcode\": \"$curcode\",\n\t\"pcode\": \"$pcode\",\n\t\"lamt\": $valueAmount,\n\t\"ints\": $valueNumberofTerm,\n\t\"intrate\": $valueInterest,\n\t\"mfee\": $valueMaintenanceFee,\n\t\"afee\": $valueAdminFee,\n\t\"rmode\": \"$valueRepaymentMethod\",\n\t\"odate\": \"$valueOpenDate\",\n\t\"mdate\": \"$valueMaturityDate\",\n\t\"firdate\": \"$valueFirstRepaymentDate\",\n\t\"graperiod\": $valueGenerateGracePeriodNumber,\n\t\"lpourpose\": \"$valueLoanPurpose\",\n\t\"ltv\": $valueLTV,\n\t\"dscr\": $valueDscr,\n\t\"refby\": \"$valueReferByWho\",\n\t\"lstatus\": \"O\",\n\t\"lcode\": \"$lcode\"\n}";
      final response = await api().put(baseURLInternal + 'loans/' + lcode,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: boyrow);
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
