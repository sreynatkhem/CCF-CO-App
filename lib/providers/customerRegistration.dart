import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/models/listNationID.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomerRegistrationProvider with ChangeNotifier {
  bool _isFetching = false;
  final data = [];
  final storage = new FlutterSecureStorage();

  Future<List<CustomerRegistration>> postCustomerRegistration(
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
    print(gender);

    try {
      _isFetching = false;
      var body = {
        'bcode': branch,
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
      print('body: $body');
      print('selectedValueVillage: $idVillage');

      final boyrow =
          "{\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"namekhr\": \"$valueKhmerName\",\n    \"nameeng\": \"$valueEnglishName\",\n    \"dob\": \"$valueDatehofBrith\",\n    \"gender\": \"$gender\",\n    \"phone1\": \"$valuePhone1\",\n    \"phone2\": \"$valuePhone2\",\n    \"procode\": \"$selectedValueProvince\",\n    \"discode\": \"$selectedValueDistrict\",\n    \"comcode\": \"$selectedValueCommune\",\n    \"vilcode\": \"$idVillage\",\n    \"goglocation\": \"$currentAddress\",\n    \"occupation\": \"$valueOccupationOfCustomer\",\n    \"ntype\": \"$ntypes\",\n    \"nid\": \"$valueNationIdentification\",\n    \"ndate\": \"$valueNextVisitDate\",\n    \"pro\": \"$valueProspective\",\n    \"cstatus\": \"$valueGurantorCustomer\"\n}";
      final response = await api().post(baseURLInternal + 'Customers',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: boyrow);
      final parsed = jsonDecode(response.body);
      print('parsed: $parsed');

      data.add(parsed);
      notifyListeners();
      // return parsed
      //     .map<CustomerRegistration>(
      //         (json) => CustomerRegistration.fromJson(json))
      //     .toList();
    } catch (error) {
      print('error eeeee: $error');
      _isFetching = false;
    }
  }

  //request dropdown Nation ID Famliy and Passport
  Future<List<ListNationID>> getDropdownNationIDList() async {
    _isFetching = true;
    print("getDropdownNationIDList::: ");

    try {
      _isFetching = false;
      var token = await storage.read(key: 'user_token');
      print("token::: $token");

      final response = await api().get(
        baseURLInternal + 'valuelists/idtypes',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      print("parsed::: $parsed");
      data.add(parsed);
      notifyListeners();
      return parsed
          .map<ListNationID>((json) => ListNationID.fromJson(json))
          .toList();
    } catch (error) {
      print('error ListNationID : $error');
      _isFetching = false;
    }
  }

  bool get isFetching => _isFetching;
}
