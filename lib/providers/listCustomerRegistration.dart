import 'package:chokchey_finance/models/customerRegistration.dart';
import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class ListCustomerRegistrationProvider with ChangeNotifier {
  bool _isFetching = false;
  final data = [];
  var totalCustomer = '';
  bool statusCode = false;
  final storage = new FlutterSecureStorage();
  // Future<List<Customers>> fetchListCustomerRegistration(
  Future fetchListCustomerRegistration(
      _pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    _isFetching = true;
    try {
      _isFetching = false;
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var level = await storage.read(key: "level");
      var bodyRow;
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
      bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"btlcode\": \"\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      var uri = baseURLInternal + 'customers/all';
      final response = await api().post(uri, headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        final dynamic parsed = [];
        parsed.addAll(jsonDecode(response.body));
        data.addAll(parsed[0]['listCustomers']);
        totalCustomer = parsed[0]['totalCustomer'].toString();
        notifyListeners();
        if (parsed[0]['listCustomers'].length > 1) {
          return parsed[0]['listCustomers']
              .map<Customers>((json) => Customers.fromJson(json))
              .toList();
        } else {
          return [].map<Customers>((json) => Customers.fromJson(json)).toList();
        }
      } else {
        print('statusCode::: ${response.statusCode}');
      }
    } catch (error) {
      print('error: $error');
      _isFetching = false;
    }
  }

  // Future<List<CustomerRegistration>> editCustomerRegistration(
  Future editCustomerRegistration(
      ccode,
      acode,
      rdate,
      valueKhmerName,
      valueEnglishName,
      gender,
      valuePhone1,
      valuePhone2,
      valueOccupationOfCustomer,
      valueNextVisitDate,
      valueProspective,
      selectedValueProvince,
      selectedValueDistrict,
      selectedValueCommune,
      idVillage,
      currentAddress) async {
    _isFetching = true;
    var user_ucode = await storage.read(key: 'user_ucode');
    var branch = await storage.read(key: 'branch');
    var token = await storage.read(key: 'user_token');
    var nextDate = valueNextVisitDate != null && valueNextVisitDate != ''
        ? valueNextVisitDate
        : '';
    try {
      _isFetching = false;

      final boyrow =
          "{\n    \"ccode\": \"$ccode\",\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"acode\": \"$acode\",\n    \"rdate\": \"$rdate\",\n    \"namekhr\": \"$valueKhmerName\",\n    \"nameeng\": \"$valueEnglishName\",\n    \"dob\": \"\",\n    \"gender\": \"$gender\",\n    \"phone1\": \"$valuePhone1\",\n    \"phone2\": \"$valuePhone2\",\n    \"procode\": \"$selectedValueProvince\",\n    \"discode\": \"$selectedValueDistrict\",\n    \"comcode\": \"$selectedValueCommune\",\n    \"vilcode\": \"$idVillage\",\n    \"goglocation\": \"$currentAddress\",\n    \"occupation\": \"$valueOccupationOfCustomer\",\n    \"ntype\": \"\",\n    \"nid\": \"\",\n    \"ndate\": \"$nextDate\",\n    \"pro\": \"$valueProspective\",\n    \"cstatus\": \"\"\n}";
      final response = await api().put(
          baseURLInternal + 'Customers/' + '$ccode',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: boyrow);
      if (response.statusCode == 201) {
        statusCode = true;
        final parsed = jsonDecode(response.body);
        data.add(parsed);
        notifyListeners();
        return parsed;
      }
    } catch (error) {
      _isFetching = false;
      print('error :: ${error}');
    }
  }

//request customer by id
  // Future<List<CustomerRegistration>> getCustomerByID(customerID) async {
  Future getCustomerByID(customerID) async {
    _isFetching = true;
    try {
      _isFetching = false;
      var token = await storage.read(key: 'user_token');
      final Response response = await api().get(
        Uri.parse(baseURLInternal + 'customers/' + customerID),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      logger().e(parsed);
      notifyListeners();
      return parsed;
    } catch (error) {
      _isFetching = false;
    }
  }

  bool get isFetching => _isFetching;
  get isFetchData => data;
  get isTotalListCustomer => totalCustomer;
  bool get isStatusCode => statusCode;
}
