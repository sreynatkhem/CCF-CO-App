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
  Future fetchListCustomerRegistration(
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
      //     "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"btlcode\": \"\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      final Map<String, dynamic> bodyRow = {
        "pageSize": "$_pageSize",
        "pageNumber": "$_pageNumber",
        "ucode": "$ucode",
        "bcode": "$bcodes",
        "btlcode": "",
        "status": "",
        "code": "",
        "sdate": "",
        "edate": ""
      };
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      var uri = Uri.parse(baseURLInternal + 'customers/all');
      final Response response =
          await api().post(uri, headers: headers, body: json.encode(bodyRow));
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
      }
    } catch (error) {
      print('error: $error');
      _isFetching = false;
    }
  }

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

      final Map<String, dynamic> boyrow = {
        "ccode": "$ccode",
        "ucode": "$user_ucode",
        "bcode": "$branch",
        "acode": "$acode",
        "rdate": "$rdate",
        "namekhr": "$valueKhmerName",
        "nameeng": "$valueEnglishName",
        "dob": "",
        "gender": "$gender",
        "phone1": "$valuePhone1",
        "phone2": "$valuePhone2",
        "procode": "$selectedValueProvince",
        "discode": "$selectedValueDistrict",
        "comcode": "$selectedValueCommune",
        "vilcode": "$idVillage",
        "goglocation": "$currentAddress",
        "occupation": "$valueOccupationOfCustomer",
        "ntype": "",
        "nid": "",
        "ndate": "$nextDate",
        "pro": "$valueProspective",
        "cstatus": ""
      };

      final Response response = await api().put(
          Uri.parse(baseURLInternal + 'Customers/' + '$ccode'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: json.encode(boyrow));
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
