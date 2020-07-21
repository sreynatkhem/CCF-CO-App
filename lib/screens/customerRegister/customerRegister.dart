import 'package:chokchey_finance/components/dateTimePicker.dart';
import 'package:chokchey_finance/components/dropdownCustomersRegister.dart';
import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/components/textInput.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class CustomerRegister extends StatefulWidget {
  @override
  _CustomerRegister createState() => _CustomerRegister();
}

class _CustomerRegister extends State {
  var valueKhmerName;
  var valueEnglishName;
  var valueDatehofBrith;
  var gender;
  var valuePhone1;
  var valuePhone2;
  var valueDateOfRegister;
  var valueOccupationOfCustomer;
  var valueNationIdentification;
  var valueNextVisitDate;
  var valueProspective;
  var valueGurantorCustomer;
  String selectedValueProvince;
  String selectedValueDistrict;
  String selectedValueCommune;
  String selectedValueVillage;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> datehofBrith =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> englishName = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> khmerName = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> phoneKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> phoneKey2 = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> datehofRegister =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> occupationOfCustomer =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> nationIdentification =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> nextVisitDate =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> prospective = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> gurantorCustomer =
      GlobalKey<FormBuilderState>();

  final TextEditingController controllerFullNameKhmer = TextEditingController();
  final TextEditingController controllerFullNameEnglish =
      TextEditingController();
  final TextEditingController controllerPhone1 = TextEditingController();
  final TextEditingController controllerPhone2 = TextEditingController();

  final TextEditingController controllerProvinceCode = TextEditingController();
  final TextEditingController controllerDistrictCode = TextEditingController();
  final TextEditingController controllerCommuneCode = TextEditingController();
  final TextEditingController controllerVillageCode = TextEditingController();
  final TextEditingController controllerGoogleLocation =
      TextEditingController();
  final TextEditingController controllerOccupationofCustomer =
      TextEditingController();
  final TextEditingController controllerNationIdentification =
      TextEditingController();
  final TextEditingController controllerNextVisitDate = TextEditingController();
  final TextEditingController controllerProspective = TextEditingController();
  final TextEditingController controllerGurantorCustomer =
      TextEditingController();
  final TextEditingController controllerU1 = TextEditingController();
  final TextEditingController controllerU2 = TextEditingController();
  final TextEditingController controllerU3 = TextEditingController();
  final TextEditingController controllerU4 = TextEditingController();
  final TextEditingController controllerU5 = TextEditingController();

  var provinceOnlys = true;
  var districtreadOnlys = true;
  var communereadOnlys = true;
  var villagereadOnlys = true;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  onSubmit() {
    print({
      valueKhmerName,
      valueEnglishName,
      valueDatehofBrith,
      gender,
      valuePhone1,
      valuePhone2,
      valueDateOfRegister,
      _currentAddress,
      valueOccupationOfCustomer,
      valueNationIdentification,
      valueNextVisitDate,
      valueProspective,
      valueGurantorCustomer,
      selectedValueProvince,
      selectedValueDistrict,
      selectedValueCommune,
      selectedValueVillage,
    });
  }

  final ValueChanged _onChanged = (val) => print(val);
  @override
  Widget build(BuildContext context) {
    return Header(
      headerTexts: 'Customers Register',
      bodys: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            GroupFromBuilder(
              icons: Icons.person,
              keys: khmerName,
              childs: FormBuilderTextField(
                // attribute: ,
                decoration: const InputDecoration(
                  labelText: 'Full Name Khmer',
                ),
                onChanged: (v) {
                  // setState(() {
                  //   valueKhmerName = v;
                  // });
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                validators: [
                  FormBuilderValidators.required(),
                ],
                keyboardType: TextInputType.text,
              ),
            ),
            GroupFromBuilder(
              icons: Icons.person,
              keys: englishName,
              childs: FormBuilderTextField(
                // attribute: ,
                decoration: const InputDecoration(
                  labelText: 'Full Name English',
                ),
                onChanged: (v) {
                  setState(() {
                    valueEnglishName = v;
                  });
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                validators: [
                  FormBuilderValidators.required(),
                ],
                keyboardType: TextInputType.text,
              ),
            ),
            GroupFromBuilder(
              icons: Icons.date_range,
              keys: datehofBrith,
              childs: FormBuilderDateTimePicker(
                inputType: InputType.date,
                onChanged: (v) {
                  setState(() {
                    valueDatehofBrith = v;
                  });
                },
                validators: [FormBuilderValidators.required()],
                format: DateFormat("yyyy-MM-dd"),
                decoration: InputDecoration(labelText: "Date of brith"),
              ),
            ),
            GroupFromBuilder(
              icons: Icons.date_range,
              keys: _fbKey,
              childs: FormBuilderDropdown(
                attribute: "gender",
                decoration: InputDecoration(
                  labelText: "Gender",
                ),
                hint: Text(
                  'Select Gender',
                ),
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
                onSaved: (v) {
                  print('value $v');
                },
                validators: [FormBuilderValidators.required()],
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(
                          "$gender",
                        )))
                    .toList(),
              ),
            ),
            GroupFromBuilder(
              icons: Icons.phone,
              keys: phoneKey,
              childs: FormBuilderPhoneField(
                attribute: 'phone_number',
                initialValue: '0',
                defaultSelectedCountryIsoCode: 'KH',
                cursorColor: Colors.black,
                // style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: const InputDecoration(
                  // border: Border(
                  //   bottom: BorderSide(width: 1.0, color: Colors.grey),
                  // ),
                  labelText: 'Phone Number 1',
                ),
                onChanged: (v) {
                  setState(() {
                    valuePhone1 = v;
                  });
                },
                priorityListByIsoCode: ['KH'],
                validators: [
                  FormBuilderValidators.numeric(
                      errorText: 'Invalid phone number'),
                  FormBuilderValidators.required(
                      errorText: 'This field reqired')
                ],
              ),
            ),
            GroupFromBuilder(
              icons: Icons.phone,
              keys: phoneKey2,
              childs: FormBuilderPhoneField(
                attribute: 'phone_number',
                initialValue: '0',
                defaultSelectedCountryIsoCode: 'KH',
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  labelText: 'Phone Number 2',
                ),
                onChanged: (v) {
                  setState(() {
                    valuePhone2 = v;
                  });
                },
                priorityListByIsoCode: ['KH'],
              ),
            ),
            GroupFromBuilder(
              icons: Icons.timeline,
              keys: datehofRegister,
              childs: FormBuilderDateTimePicker(
                // attribute: 'date',
                inputType: InputType.date,
                onChanged: (v) {
                  valueDateOfRegister = v ?? DateTime.now();
                },
                validators: [FormBuilderValidators.required()],
                format: DateFormat("yyyy-MM-dd"),
                decoration: InputDecoration(labelText: "Date of Register"),
              ),
            ),
            Container(
              width: 375,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      if (_currentPosition != null)
                        Container(
                            padding: EdgeInsets.only(left: 52, top: 10),
                            child: Text(_currentAddress ?? '',
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: fontSizeXs,
                                    color: Colors.black,
                                    fontWeight: fontWeight500))),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.navigation,
                          color: Colors.grey,
                        ),
                        Row(
                          children: <Widget>[
                            FlatButton(
                              padding: EdgeInsets.only(left: 27),
                              child: Text(
                                "Get location",
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 17,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                _getCurrentLocation();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 68, right: 18),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
            ),
            GroupFromBuilder(
              icons: Icons.work,
              keys: occupationOfCustomer,
              childs: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Occupation of customer',
                ),
                onChanged: (v) {
                  valueOccupationOfCustomer = v;
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                keyboardType: TextInputType.number,
              ),
            ),
            GroupFromBuilder(
              icons: Icons.payment,
              keys: nationIdentification,
              childs: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Nation Identification',
                ),
                onChanged: (v) {
                  valueNationIdentification = v;
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                keyboardType: TextInputType.number,
              ),
            ),
            GroupFromBuilder(
              icons: Icons.date_range,
              keys: nextVisitDate,
              childs: FormBuilderDateTimePicker(
                inputType: InputType.date,
                onChanged: (v) {
                  valueNextVisitDate = v;
                },
                format: DateFormat("yyyy-MM-dd"),
                decoration: InputDecoration(labelText: "Next visit date"),
              ),
            ),
            GroupFromBuilder(
              icons: Icons.check,
              keys: prospective,
              childs: FormBuilderDropdown(
                decoration: InputDecoration(
                  labelText: "Prospective",
                ),
                hint: Text(
                  'Prospective Y=Yes, N=No',
                ),
                onChanged: (value) {
                  setState(() {
                    valueProspective = value;
                  });
                },
                items: [
                  'Y',
                  'N',
                ]
                    .map((valueProspective) => DropdownMenuItem(
                        value: valueProspective,
                        child: Text(
                          "$valueProspective",
                        )))
                    .toList(),
              ),
            ),
            GroupFromBuilder(
              icons: Icons.check,
              keys: gurantorCustomer,
              childs: FormBuilderDropdown(
                decoration: InputDecoration(
                  labelText: "G=Gurantor, C=Customer",
                ),
                hint: Text(
                  'G=Gurantor, C=Customer',
                ),
                onChanged: (value) {
                  setState(() {
                    valueGurantorCustomer = value;
                  });
                },
                items: [
                  'G',
                  'C',
                ]
                    .map((valueGurantorCustomer) => DropdownMenuItem(
                        value: valueGurantorCustomer,
                        child: Text(
                          "$valueGurantorCustomer",
                        )))
                    .toList(),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            DropDownCustomerRegister(
              icons: Icons.location_on,
              items: List.generate(50, (index) => "Item $index"),
              selectedValue: selectedValueProvince,
              onChanged: (value) {
                setState(() {
                  selectedValueProvince = value ?? '';
                  districtreadOnlys = false;
                });
              },
              texts: selectedValueProvince,
              title: 'Province code',
              readOnlys: false,
              styleTexts: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: fontSizeXs,
                  color: Colors.black,
                  fontWeight: fontWeight500),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            DropDownCustomerRegister(
              icons: Icons.location_on,
              items: List.generate(50, (index) => "Item $index"),
              selectedValue: selectedValueDistrict,
              onChanged: (value) {
                setState(() {
                  selectedValueDistrict = value ?? '';
                  communereadOnlys = false;
                });
              },
              texts: selectedValueDistrict,
              title: 'District code',
              readOnlys: districtreadOnlys ?? true,
              styleTexts: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: fontSizeXs,
                  color: Colors.black,
                  fontWeight: fontWeight500),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            DropDownCustomerRegister(
              icons: Icons.location_on,
              items: List.generate(50, (index) => "Item $index"),
              selectedValue: selectedValueCommune,
              onChanged: (value) {
                setState(() {
                  selectedValueCommune = value ?? '';
                  villagereadOnlys = false;
                });
              },
              title: 'Commune code',
              styleTexts: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: fontSizeXs,
                  color: Colors.black,
                  fontWeight: fontWeight500),
              texts: selectedValueCommune,
              readOnlys: communereadOnlys ?? true,
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            DropDownCustomerRegister(
              icons: Icons.location_on,
              items: List.generate(50, (index) => "Item $index"),
              selectedValue: selectedValueVillage,
              onChanged: (value) {
                setState(() {
                  selectedValueVillage = value ?? '';
                });
              },
              styleTexts: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: fontSizeXs,
                  color: Colors.black,
                  fontWeight: fontWeight500),
              texts: selectedValueVillage,
              title: 'Village code',
              readOnlys: villagereadOnlys ?? true,
            ),

            // TextInput(
            //   icons: const Icon(Icons.label_important),
            //   textInput: "U1",
            //   controllers: controllerU1,
            // ),
            // TextInput(
            //   icons: const Icon(Icons.label_important),
            //   textInput: "U2",
            //   controllers: controllerU2,
            // ),
            // TextInput(
            //   icons: const Icon(Icons.label_important),
            //   textInput: "U3",
            //   controllers: controllerU3,
            // ),
            // TextInput(
            //   icons: const Icon(Icons.label_important),
            //   textInput: "U4",
            //   controllers: controllerU4,
            // ),
            // TextInput(
            //   icons: const Icon(Icons.label_important),
            //   textInput: "U5",
            //   controllers: controllerU5,
            // ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                height: 90,
                padding: EdgeInsets.only(top: 40, left: 10, bottom: 10),
                child: new RaisedButton(
                  onPressed: () {
                    onSubmit();
                  },
                  color: logolightGreen,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: logolightGreen, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
