import 'package:chokchey_finance/models/customerRegistration.dart';
import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ListCustomerRegistrationProvider with ChangeNotifier {
  bool _isFetching = false;
  final data = [];
  var totalCustomer = '';
  final storage = new FlutterSecureStorage();
  Future<List<Customers>> fetchListCustomerRegistration(
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
        bcodes = bcode != null ? bcode : branch;
        btlcode = '';
        ucode = code != null ? code : '';
      }

      if (level == '2') {
        bcodes = bcode != null ? bcode : branch;
        btlcode = user_ucode;
        ucode = code != null ? code : '';
      }

      if (level == '1') {
        bcodes = bcode != null ? bcode : branch;
        ucode = user_ucode;
        btlcode = '';
      }

      if (level == '4' || level == '5' || level == '6') {
        bcodes = bcode != null ? bcode : '';
        btlcode = '';
        ucode = code != null ? code : '';
      }
      bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"btlcode\": \"\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      print('bodyRow: ${bodyRow}');
      var uri = baseURLInternal + 'customers/all';
      final response = await api().post(uri, headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        final dynamic parsed = [];
        parsed.addAll(jsonDecode(response.body));
        data.addAll(parsed[0]['listCustomers']);
        totalCustomer = parsed[0]['totalCustomer'].toString();
        print('data: ${jsonDecode(response.body)}');
        print('data 2: ${parsed[0]['listCustomers'].length}');

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

  Future<List<CustomerRegistration>> editCustomerRegistration(
      ccode,
      acode,
      rdate,
      valueKhmerName,
      valueEnglishName,
      valueDatehofBrith,
      gender,
      valuePhone1,
      valuePhone2,
      valueOccupationOfCustomer,
      ntypes,
      valueNationIdentification,
      valueNextVisitDate,
      valueProspective,
      valueGurantorCustomer,
      selectedValueProvince,
      selectedValueDistrict,
      selectedValueCommune,
      idVillage,
      currentAddress) async {
    _isFetching = true;
    var user_ucode = await storage.read(key: 'user_ucode');
    var branch = await storage.read(key: 'branch');
    var token = await storage.read(key: 'user_token');
    try {
      _isFetching = false;
      var body = {
        'ccode': ccode,
        'ucode': user_ucode,
        'bcode': branch,
        'rdate': rdate,
        'acode': acode,
        'comcode': selectedValueCommune,
        'cstatus': valueGurantorCustomer,
        'discode': selectedValueDistrict,
        'dob': '2020-09-11',
        'gender': gender,
        'goglocation': currentAddress,
        'nameeng': valueEnglishName,
        'namekhr': valueKhmerName,
        'ndate': '2020-09-11',
        'ntype': ntypes,
        'nid': valueNationIdentification,
        'occupation': valueOccupationOfCustomer,
        'phone1': valuePhone1,
        'phone2': valuePhone2,
        'pro': valueProspective,
        'procode': selectedValueProvince,
        'ucode': user_ucode,
        'vilcode': idVillage,
      };
      final boyrow =
          "{\n    \"ccode\": \"$ccode\",\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"acode\": \"$acode\",\n    \"rdate\": \"$rdate\",\n    \"namekhr\": \"$valueKhmerName\",\n    \"nameeng\": \"$valueEnglishName\",\n    \"dob\": \"$valueDatehofBrith\",\n    \"gender\": \"$gender\",\n    \"phone1\": \"$valuePhone1\",\n    \"phone2\": \"$valuePhone2\",\n    \"procode\": \"$selectedValueProvince\",\n    \"discode\": \"$selectedValueDistrict\",\n    \"comcode\": \"$selectedValueCommune\",\n    \"vilcode\": \"$idVillage\",\n    \"goglocation\": \"$currentAddress\",\n    \"occupation\": \"$valueOccupationOfCustomer\",\n    \"ntype\": \"$ntypes\",\n    \"nid\": \"$valueNationIdentification\",\n    \"ndate\": \"$valueNextVisitDate\",\n    \"pro\": \"$valueProspective\",\n    \"cstatus\": \"$valueGurantorCustomer\"\n}";
      final response = await api().put(
          baseURLInternal + 'Customers/' + '$ccode',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: boyrow);
      final parsed = jsonDecode(response.body);
      data.add(parsed);
      notifyListeners();
    } catch (error) {
      _isFetching = false;
      print('error :: ${error}');
    }
  }

//request customer by id
  Future<List<CustomerRegistration>> getCustomerByID(customerID) async {
    _isFetching = true;
    try {
      _isFetching = false;
      var token = await storage.read(key: 'user_token');
      final response = await api().get(
        baseURLInternal + 'customers/' + customerID,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      dynamic data = [];
      data.add(parsed);
      notifyListeners();
      return data
          .map<CustomerRegistration>(
              (json) => CustomerRegistration.fromJson(json))
          .toList();
    } catch (error) {
      _isFetching = false;
    }
  }

  bool get isFetching => _isFetching;
  get isFetchData => data;
  get isTotalListCustomer => totalCustomer;
}
