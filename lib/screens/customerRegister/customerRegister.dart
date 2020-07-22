import 'package:chokchey_finance/components/dateTimePicker.dart';
import 'package:chokchey_finance/components/dropdownCustomersRegister.dart';
import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/components/textInput.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var valueNextVisitDate;
  var valueProspective;
  var valueGurantorCustomer;
  String valueNationIdentification;
  String valueSelectedNativeID;
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
  final GlobalKey<FormBuilderState> nationIdentificationValue =
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

  var districtreadOnlys = false;
  var communereadOnlys = false;
  var villagereadOnlys = false;

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
            "${place.subLocality}, ${place.locality}, ${place.postalCode} ${place.country}";
        FocusScope.of(context).requestFocus(occupationOfCustomerFocus);
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
      valueSelectedNativeID,
      valueNextVisitDate,
      valueProspective,
      valueGurantorCustomer,
      selectedValueProvince,
      selectedValueDistrict,
      selectedValueCommune,
      selectedValueVillage,
    });
  }

  final khmerNameFocus = FocusNode();
  final englishNameFocus = FocusNode();
  final datehofBrithFocus = FocusNode();
  final phoneKeyFocus = FocusNode();
  final phoneKey2Focus = FocusNode();
  final datehofRegisterFocus = FocusNode();
  final occupationOfCustomerFocus = FocusNode();
  final nationIdentificationValueFocus = FocusNode();
  final nextVisitDateFocus = FocusNode();
  var selectedValueProvincefocus = false;

  @override
  Widget build(BuildContext context) {
    return Header(
      headerTexts: 'Customers Register',
      bodys: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: new Column(
            children: <Widget>[
              GroupFromBuilder(
                icons: Icons.person,
                keys: khmerName,
                childs: FormBuilderTextField(
                  attribute: 'name',
                  focusNode: khmerNameFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(englishNameFocus);
                  },
                  decoration: new InputDecoration(
                      border: InputBorder.none, labelText: 'Full Name Khmer'),
                  onChanged: (v) {
                    setState(() {
                      valueKhmerName = v;
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
                icons: Icons.person,
                keys: englishName,
                childs: FormBuilderTextField(
                  attribute: 'name',
                  focusNode: englishNameFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(datehofBrithFocus);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Full Name English',
                    border: InputBorder.none,
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
                  attribute: 'date',
                  focusNode: datehofBrithFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(englishNameFocus);
                  },
                  inputType: InputType.date,
                  onChanged: (v) {
                    setState(() {
                      valueDatehofBrith = v;
                    });
                  },
                  validators: [FormBuilderValidators.required()],
                  format: DateFormat("yyyy-MM-dd"),
                  decoration: InputDecoration(
                    labelText: "Date of brith",
                    border: InputBorder.none,
                  ),
                ),
              ),
              GroupFromBuilder(
                icons: Icons.date_range,
                keys: _fbKey,
                childs: FormBuilderDropdown(
                  attribute: "gender",
                  decoration: InputDecoration(
                    labelText: "Gender",
                    border: InputBorder.none,
                  ),
                  hint: Text(
                    'Select Gender',
                  ),
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                      FocusScope.of(context).requestFocus(phoneKeyFocus);
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
                  focusNode: phoneKeyFocus,
                  textInputAction: TextInputAction.next,
                  onSaved: (v) {
                    print('onSaved: $v');
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(phoneKey2Focus),
                  attribute: 'phone_number',
                  initialValue: '0',
                  defaultSelectedCountryIsoCode: 'KH',
                  cursorColor: Colors.black,
                  maxLength: 10,
                  maxLengthEnforced: true,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number 1',
                    border: InputBorder.none,
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
                  focusNode: phoneKey2Focus,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(datehofRegisterFocus),
                  initialValue: '0',
                  maxLength: 10,
                  maxLengthEnforced: true,
                  defaultSelectedCountryIsoCode: 'KH',
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number 2',
                    border: InputBorder.none,
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
                  attribute: 'date',
                  focusNode: datehofRegisterFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(datehofBrithFocus);
                  },
                  inputType: InputType.date,
                  onChanged: (v) {
                    valueDateOfRegister = v ?? DateTime.now();
                  },
                  validators: [FormBuilderValidators.required()],
                  format: DateFormat("yyyy-MM-dd"),
                  decoration: InputDecoration(
                    labelText: "Date of Register",
                    border: InputBorder.none,
                  ),
                ),
              ),

              // Center(
              //   child: Container(
              //     // width: 300,
              //     margin: EdgeInsets.only(left: 48, right: 25),
              //     decoration: const BoxDecoration(
              //       border: Border(
              //         bottom: BorderSide(width: 1.0, color: Colors.grey),
              //       ),
              //     ),
              //   ),
              // ),
              GroupFromBuilder(
                icons: Icons.work,
                keys: occupationOfCustomer,
                childs: FormBuilderTextField(
                  attribute: 'name',
                  focusNode: occupationOfCustomerFocus,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Occupation of customer',
                    border: InputBorder.none,
                  ),
                  onChanged: (v) {
                    valueOccupationOfCustomer = v;
                  },
                  valueTransformer: (text) {
                    return text == null ? null : text;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                ),
              ),
              GroupFromBuilder(
                icons: Icons.check,
                keys: nationIdentification,
                childs: FormBuilderDropdown(
                  attribute: 'name',
                  decoration: InputDecoration(
                    labelText: "Nation ID, Famliy book, Passport",
                    border: InputBorder.none,
                  ),
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                  hint: Text(
                    'Nation ID, Famliy book, Passport',
                  ),
                  onChanged: (value) {
                    setState(() {
                      valueSelectedNativeID = value;
                      FocusScope.of(context)
                          .requestFocus(nationIdentificationValueFocus);
                    });
                  },
                  items: [
                    'Nation Identification',
                    'Famliy book',
                    'Passport',
                  ]
                      .map((valueORARD) => DropdownMenuItem(
                          value: valueORARD,
                          onTap: () => setState(() {
                                valueNationIdentification = valueORARD;
                                FocusScope.of(context).requestFocus(
                                    nationIdentificationValueFocus);
                              }),
                          child: Text(
                            "$valueORARD",
                          )))
                      .toList(),
                ),
              ),
              if (valueSelectedNativeID != null)
                GroupFromBuilder(
                  icons: Icons.payment,
                  keys: nationIdentificationValue,
                  childs: FormBuilderTextField(
                    focusNode: nationIdentificationValueFocus,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(nextVisitDateFocus),
                    maxLength: 9,
                    decoration: const InputDecoration(
                      labelText: 'Nation ID, Famliy book, Passport',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      valueNationIdentification = v;
                      // FocusScope.of(context).requestFocus(nextVisitDateFocus);
                    },
                    // onTap: () =>
                    //     FocusScope.of(context).requestFocus(nextVisitDateFocus),
                    valueTransformer: (text) {
                      return text == null ? null : text;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
              GroupFromBuilder(
                icons: Icons.date_range,
                keys: nextVisitDate,
                childs: FormBuilderDateTimePicker(
                  inputType: InputType.date,
                  focusNode: nextVisitDateFocus,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(datehofRegisterFocus),
                  onChanged: (v) {
                    valueNextVisitDate = v;
                  },
                  format: DateFormat("yyyy-MM-dd"),
                  decoration: InputDecoration(
                    labelText: "Next visit date",
                    border: InputBorder.none,
                  ),
                ),
              ),
              GroupFromBuilder(
                icons: Icons.check,
                keys: prospective,
                childs: FormBuilderDropdown(
                  decoration: InputDecoration(
                    labelText: "Prospective",
                    border: InputBorder.none,
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
                    border: InputBorder.none,
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
                          onTap: () =>
                              print('${selectedValueProvincefocus = true}'),
                          child: Text(
                            "$valueGurantorCustomer",
                          )))
                      .toList(),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              DropDownCustomerRegister(
                icons: Icons.location_on,
                autofocus: true,
                items: List.generate(50, (index) => "Item $index"),
                selectedValue: selectedValueProvince,
                onChanged: (value) {
                  setState(() {
                    selectedValueProvince = value ?? '';
                    districtreadOnlys = true;
                  });
                },
                texts: selectedValueProvince,
                title: 'Province code',
                readOnlys: true,
                iconsClose: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    selectedValueProvince = '';
                    selectedValueDistrict = '';
                    selectedValueCommune = '';
                    selectedValueVillage = '';
                    districtreadOnlys = false;
                    communereadOnlys = false;
                    villagereadOnlys = false;
                  });
                },
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
                    communereadOnlys = true;
                  });
                },
                texts: selectedValueDistrict,
                title: 'District code',
                iconsClose: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    selectedValueDistrict = '';
                    selectedValueCommune = '';
                    selectedValueVillage = '';
                    villagereadOnlys = false;
                  });
                },
                readOnlys: districtreadOnlys,
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
                    villagereadOnlys = true;
                  });
                },
                iconsClose: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    selectedValueCommune = '';
                    selectedValueVillage = '';
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
                readOnlys: communereadOnlys,
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
                iconsClose: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    selectedValueVillage = '';
                  });
                },
                styleTexts: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: fontSizeXs,
                    color: Colors.black,
                    fontWeight: fontWeight500),
                texts: selectedValueVillage,
                title: 'Village code',
                readOnlys: villagereadOnlys,
              ),
              Card(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.navigation,
                              color: Colors.grey,
                            ),
                            FlatButton(
                              child: Container(
                                // width: 250,
                                child: Text(
                                  _currentAddress ?? "Get location",
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: 17,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              onPressed: () {
                                _getCurrentLocation();
                              },
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.map,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
      ),
    );
  }
}
