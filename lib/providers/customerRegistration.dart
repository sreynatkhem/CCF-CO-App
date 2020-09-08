import 'package:chokchey_finance/models/customerRegistration.dart';
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
  var listCustomerByID = [];
  bool isOkay = false;
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
    var ndate = valueNextVisitDate != null ? valueNextVisitDate : '';
    var prospective = valueProspective != null ? valueProspective : '';
    var gurantorCustomer =
        valueGurantorCustomer != null ? valueGurantorCustomer : '';
    var nationIdentification =
        valueNationIdentification != null ? valueNationIdentification : '';
    var currentAdd = currentAddress != null ? currentAddress : '';
    var ntype = ntypes != null ? ntypes : '';
    var englishName = valueEnglishName != null ? valueEnglishName : '';
    var dateOfBirth = valueDatehofBrith != null ? valueDatehofBrith : '';
    var phoneNumber2 = valuePhone2 != null ? valuePhone2 : '';

    isOkay = false;
    try {
      _isFetching = false;
      final boyrow =
          "{\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"namekhr\": \"$valueKhmerName\",\n    \"nameeng\": \"$englishName\",\n    \"dob\": \"$dateOfBirth\",\n    \"gender\": \"$gender\",\n    \"phone1\": \"$valuePhone1\",\n    \"phone2\": \"$phoneNumber2\",\n    \"procode\": \"$selectedValueProvince\",\n    \"discode\": \"$selectedValueDistrict\",\n    \"comcode\": \"$selectedValueCommune\",\n    \"vilcode\": \"$idVillage\",\n    \"goglocation\": \"$currentAdd\",\n    \"occupation\": \"$valueOccupationOfCustomer\",\n    \"ntype\": \"$ntype\",\n    \"nid\": \"$nationIdentification\",\n    \"ndate\": \"$ndate\",\n    \"pro\": \"$prospective\",\n    \"cstatus\": \"$gurantorCustomer\"\n}";
      final response = await api().post(baseURLInternal + 'Customers',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: boyrow);
      final parsed = jsonDecode(response.body);
      logger().e('parsed :: ${parsed}');

      if (response.statusCode == 201) {
        logger().e('response.statusCode :: ${response.statusCode}');

        isOkay = true;
      }
      data.add(parsed);
      notifyListeners();
    } catch (error) {
      isOkay = false;
      _isFetching = false;
    }
  }

  //request dropdown Nation ID Famliy and Passport
  Future<List<ListNationID>> getDropdownNationIDList() async {
    _isFetching = true;
    try {
      _isFetching = false;
      var token = await storage.read(key: 'user_token');
      final response = await api().get(
        baseURLInternal + 'valuelists/idtypes',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      data.add(parsed);
      notifyListeners();
      return parsed
          .map<ListNationID>((json) => ListNationID.fromJson(json))
          .toList();
    } catch (error) {
      _isFetching = false;
    }
  }

  bool get isFetching => _isFetching;
  bool get isFetchingOkay => isOkay;
}
