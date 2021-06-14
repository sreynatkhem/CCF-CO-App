import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class CustomerRegistrationProvider with ChangeNotifier {
  bool _isFetching = false;
  final data = [];
  final storage = new FlutterSecureStorage();
  var listCustomerByID = [];
  bool isOkay = false;
  // Future<List<CustomerRegistration>> postCustomerRegistration(
  Future postCustomerRegistration(
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
      final Map<String, dynamic> boyrow = {
        "ucode": "$user_ucode",
        "bcode": "$branch",
        "namekhr": "$valueKhmerName",
        "nameeng": "$englishName",
        "dob": "$dateOfBirth",
        "gender": "$gender",
        "phone1": "$valuePhone1",
        "phone2": "$phoneNumber2",
        "procode": "$selectedValueProvince",
        "discode": "$selectedValueDistrict",
        "comcode": "$selectedValueCommune",
        "vilcode": "$idVillage",
        "goglocation": "$currentAdd",
        "occupation": "$valueOccupationOfCustomer",
        "ntype": "$ntype",
        "nid": "$nationIdentification",
        "ndate": "$ndate",
        "pro": "$prospective",
        "cstatus": "$gurantorCustomer"
      };
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'Customers'),
          headers: {
            "content-type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: json.encode(boyrow));
      final parsed = jsonDecode(response.body);
      if (response.statusCode == 201) {
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
  // Future<List<ListNationID>> getDropdownNationIDList() async {
  Future getDropdownNationIDList() async {
    _isFetching = true;
    try {
      _isFetching = false;
      var token = await storage.read(key: 'user_token');
      final Response response = await api().get(
        Uri.parse(baseURLInternal + 'valuelists/idtypes'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      data.add(parsed);
      notifyListeners();
      // return parsed
      //     .map<ListNationID>((json) => ListNationID.fromJson(json))
      //     .toList();
      return parsed;
    } catch (error) {
      _isFetching = false;
    }
  }

  bool get isFetching => _isFetching;
  bool get isFetchingOkay => isOkay;
}
