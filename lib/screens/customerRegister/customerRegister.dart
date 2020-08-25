import 'dart:convert';
import 'package:chokchey_finance/components/dropdownCustomersRegister.dart';
import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/customerRegistration.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/listCustomerRegistration/listCustomerRegistration.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CustomerRegister extends StatefulWidget {
  final dynamic list;
  CustomerRegister({this.list});
  @override
  _CustomerRegister createState() => _CustomerRegister(list: list);
}

class _CustomerRegister extends State {
  final dynamic list;
  _CustomerRegister({this.list});

  var valueKhmerName;
  var valueEnglishName;
  var valueDatehofBrith;
  var gender;
  var ntypes;
  var valuePhone1;
  var valuePhone2;
  // var valueDateOfRegister;
  var valueOccupationOfCustomer;
  var valueNextVisitDate;
  var valueProspective;
  var valueGurantorCustomer;
  var valueNationIdentification;
  var valueSelectedNativeID;
  String selectedValueProvince = 'Province code';
  String selectedValueDistrict = 'District code';
  String selectedValueCommune = 'Commune code';
  String selectedValueVillage = 'Village code';
  bool validateVillage = false;
  var idProvince;
  var idDistrict;
  var idCommune;
  var idVillage;

  Position _currentPosition;
  String _currentAddress;

  var getListNationIDs;

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

  var districtreadOnlys = false;
  var communereadOnlys = false;
  var villagereadOnlys = false;

  final GlobalKey<FormBuilderState> _gender = GlobalKey<FormBuilderState>();
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

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

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
      });
    } catch (e) {
      print(e);
    }
  }

  var postCustomer;

  onSubmit(context) async {
    try {
      if (khmerName.currentState.saveAndValidate() &&
          englishName.currentState.saveAndValidate() &&
          datehofBrith.currentState.saveAndValidate() &&
          _gender.currentState.saveAndValidate()) {
        await Provider.of<CustomerRegistrationProvider>(context, listen: false)
            .postCustomerRegistration(
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
                idProvince,
                idDistrict,
                idCommune,
                idVillage,
                _currentAddress)
            .then((value) => {
                  // Navigator.pop(context)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListCustomerRegistration()),
                  )
                });
      }
    } catch (error) {}
  }

  var _isIint = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      _isIint = true;
      _loading = true;
    });

    if (_isIint == true) {
      getListNationID();
      getListProvince();
      setState(() {
        _isIint = false;
        _loading = false;
      });
    }

    super.didChangeDependencies();
  }

  var listID = [];
  var listProvince = [];
  var getProvinceID;
  var listDistricts = [];
  var listComunes = [];
  var listVillages = [];

  var _loading = false;
  getListNationID() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');

    try {
      final response = await api().get(
        baseURLInternal + 'valuelists/idtypes',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      setState(() {
        listID = parsed;
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _loading = false;
      });
    }
  }

  getListProvince() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');

    try {
      final response = await api().get(
        baseURLInternal + 'addresses/provinces',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      listProvince.addAll(parsed);
    } catch (error) {}
  }

  getDistrict() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    listProvince.forEach((item) async {
      if (selectedValueProvince == item['prodes']) {
        setState(() {
          idProvince = item['procode'];
        });
      }
    });
    try {
      final response = await api().get(
        baseURLInternal + 'addresses/districts/' + idProvince,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      setState(() {
        listDistricts = parsed;
      });
      await response.close();
    } catch (error) {
      print('error $error');
    }
  }

  getCommune() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    listDistricts.forEach((item) async {
      if (selectedValueDistrict == item['disdes']) {
        setState(() {
          idDistrict = item['discode'];
        });
      }
    });

    try {
      final response = await api().get(
        baseURLInternal + 'addresses/communes/' + idDistrict,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      setState(() {
        listComunes = parsed;
      });
      await response.close();
    } catch (error) {}
  }

  getVillage() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    listComunes.forEach((item) async {
      if (selectedValueCommune == item['comdes']) {
        setState(() {
          idCommune = item['comcode'];
        });
      }
    });
    try {
      final response = await api().get(
        baseURLInternal + 'addresses/Villages/' + idCommune,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      setState(() {
        listVillages = parsed;
      });
      await response.close();
    } catch (error) {}
  }

  getIDVillage() async {
    listVillages.forEach((item) async {
      if (selectedValueVillage == item['vildes']) {
        await setState(() {
          idVillage = item['vilcode'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 20.0 : 5.0;
    return Header(
      headerTexts: 'customer_registration',
      bodys: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                        // onFieldSubmitted: (v) {
                        //   FocusScope.of(context).requestFocus(englishNameFocus);
                        // },
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context)
                                    .translate('full_khmer_name') ??
                                'Full Khmer Name'),
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
                          FocusScope.of(context)
                              .requestFocus(datehofBrithFocus);
                        },
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context)
                                    .translate('full_english_name') ??
                                'Full English Name'),
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
                        focusNode: datehofBrithFocus,
                        textInputAction: TextInputAction.next,
                        inputType: InputType.date,
                        onChanged: (v) {
                          setState(() {
                            valueDatehofBrith = v ?? '';
                          });
                        },
                        validators: [FormBuilderValidators.required()],
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context)
                                    .translate('date_of_brith') ??
                                "Date of brith"),
                      ),
                    ),
                    GroupFromBuilder(
                      icons: Icons.date_range,
                      keys: _gender,
                      childs: FormBuilderDropdown(
                        attribute: "gender",
                        decoration: InputDecoration(
                          labelText: "Gender",
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          AppLocalizations.of(context)
                                  .translate('select_gender') ??
                              'Select Gender',
                        ),
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        validators: [FormBuilderValidators.required()],
                        items: ['M', 'F', 'O']
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
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(phoneKey2Focus),
                        attribute: 'phone_number',
                        initialValue: '0',
                        defaultSelectedCountryIsoCode: 'KH',
                        cursorColor: Colors.black,
                        maxLength: 10,
                        maxLengthEnforced: true,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context)
                                    .translate('phone_number_1') ??
                                'Phone Number 1'),
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
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(datehofRegisterFocus),
                        initialValue: '0',
                        maxLength: 10,
                        maxLengthEnforced: true,
                        defaultSelectedCountryIsoCode: 'KH',
                        cursorColor: Colors.black,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context)
                                    .translate('phone_number_2') ??
                                'Phone Number 2'),
                        onChanged: (v) {
                          setState(() {
                            valuePhone2 = v;
                          });
                        },
                        priorityListByIsoCode: ['KH'],
                      ),
                    ),
                    GroupFromBuilder(
                      icons: Icons.work,
                      keys: occupationOfCustomer,
                      childs: FormBuilderDropdown(
                        attribute: "Name",
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('occupation_of_customer') ??
                              "Occupation of customer",
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          AppLocalizations.of(context)
                                  .translate('occupation_of_customer') ??
                              'Occupation of customer',
                        ),
                        onChanged: (value) {
                          setState(() {
                            valueOccupationOfCustomer = value;
                          });
                        },
                        validators: [FormBuilderValidators.required()],
                        items: ['Employee', 'Business ownership']
                            .map((v) => DropdownMenuItem(
                                value: v,
                                child: Text(
                                  "$v",
                                )))
                            .toList(),
                      ),
                    ),
                    GroupFromBuilder(
                      icons: Icons.check,
                      keys: nationIdentification,
                      childs: FormBuilderDropdown(
                          attribute: 'name',
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('nation_id_family_book') ??
                                "Nation ID, Family book, Passport",
                            border: InputBorder.none,
                          ),
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                          hint: Text(
                            AppLocalizations.of(context)
                                    .translate('nation_id_family_book') ??
                                'Nation ID, Famliy book, Passport',
                          ),
                          items: listID
                              .map((e) => DropdownMenuItem(
                                    value: e['name'].toString(),
                                    onTap: () => {
                                      setState(() {
                                        valueSelectedNativeID = '';
                                        ntypes = e['id'];
                                      })
                                    },
                                    child: Text("${e['name']}"),
                                  ))
                              .toList()),
                    ),
                    if (valueSelectedNativeID != null)
                      GroupFromBuilder(
                        icons: Icons.payment,
                        keys: nationIdentificationValue,
                        childs: FormBuilderTextField(
                          attribute: 'name',
                          focusNode: nationIdentificationValueFocus,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(nextVisitDateFocus),
                          maxLength: 9,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('nation_id_family_book') ??
                                "Nation ID, Family book, Passport",
                            border: InputBorder.none,
                          ),
                          onChanged: (v) {
                            setState(() {
                              valueNationIdentification = v;
                            });
                          },
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
                        onChanged: (v) {
                          valueNextVisitDate = v;
                        },
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('next_visit_date') ??
                              "Next visit date",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GroupFromBuilder(
                      icons: Icons.check,
                      keys: prospective,
                      childs: FormBuilderDropdown(
                        attribute: 'name',
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('prospective') ??
                              "Prospective",
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          AppLocalizations.of(context)
                                  .translate('prospective') ??
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
                        attribute: 'name',
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('guarantor_customer') ??
                              "G=Gurantor, C=Customer",
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          AppLocalizations.of(context)
                                  .translate('guarantor_customer') ??
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
                      autofocus: true,
                      validate: validateVillage
                          ? RoundedRectangleBorder(
                              side: BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      onInSidePress: () {
                        SelectDialog.showModal<String>(
                          context,
                          label: AppLocalizations.of(context)
                                  .translate('search') ??
                              'Search',
                          items: List.generate(listProvince.length,
                              (index) => "${listProvince[index]['prodes']}"),
                          onChange: (value) async {
                            setState(() {
                              selectedValueProvince = value ?? '';
                              selectedValueDistrict = '';
                              selectedValueCommune = '';
                              selectedValueVillage = '';
                              districtreadOnlys = true;
                            });
                          },
                        );
                      },
                      selectedValue: selectedValueProvince,
                      onChanged: (value) {
                        setState(() {
                          selectedValueProvince = value ?? '';
                        });
                      },
                      texts: selectedValueProvince,
                      title: 'province_code',
                      clear: true,
                      readOnlys: true,
                      iconsClose: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          selectedValueProvince = 'Province code';
                          selectedValueDistrict = 'District code';
                          selectedValueCommune = 'Commune code';
                          selectedValueVillage = 'Village code';
                          districtreadOnlys = false;
                          communereadOnlys = false;
                          villagereadOnlys = false;
                        });
                      },
                      styleTexts: selectedValueProvince != ''
                          ? TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSizeXs,
                              color: Colors.black,
                              fontWeight: fontWeight500)
                          : TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSizeXs,
                              color: Colors.grey,
                              fontWeight: fontWeight500),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    DropDownCustomerRegister(
                      icons: Icons.location_on,
                      selectedValue: selectedValueDistrict,
                      validate: validateVillage
                          ? RoundedRectangleBorder(
                              side: BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      texts: selectedValueDistrict != ''
                          ? selectedValueDistrict
                          : 'district_code',
                      title: 'district_code',
                      clear: true,
                      iconsClose: Icon(Icons.close),
                      onInSidePress: () async {
                        if (districtreadOnlys == true) {
                          await getDistrict();
                          await SelectDialog.showModal<String>(
                            context,
                            label: AppLocalizations.of(context)
                                    .translate('search') ??
                                'Search',
                            items: List.generate(listDistricts.length,
                                (index) => "${listDistricts[index]['disdes']}"),
                            onChange: (value) {
                              setState(() {
                                selectedValueDistrict = value ?? '';
                                communereadOnlys = true;
                              });
                            },
                          );
                        }
                      },
                      onPressed: () {
                        setState(() {
                          selectedValueDistrict = 'District code';
                          selectedValueCommune = 'Commune code';
                          selectedValueVillage = 'Village code';
                          villagereadOnlys = false;
                          communereadOnlys = false;
                        });
                      },
                      readOnlys: districtreadOnlys,
                      styleTexts: selectedValueDistrict != ''
                          ? TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSizeXs,
                              color: Colors.black,
                              fontWeight: fontWeight500)
                          : TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSizeXs,
                              color: Colors.grey,
                              fontWeight: fontWeight500),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    DropDownCustomerRegister(
                      icons: Icons.location_on,
                      selectedValue: selectedValueCommune,
                      validate: validateVillage
                          ? RoundedRectangleBorder(
                              side: BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      iconsClose: Icon(Icons.close),
                      onInSidePress: () async {
                        if (communereadOnlys == true) {
                          await getCommune();
                          SelectDialog.showModal<String>(
                            context,
                            label: AppLocalizations.of(context)
                                    .translate('search') ??
                                'Search',
                            items: List.generate(listComunes.length,
                                (index) => "${listComunes[index]['comdes']}"),
                            onChange: (value) {
                              setState(() {
                                selectedValueCommune = value ?? '';
                                villagereadOnlys = true;
                              });
                            },
                          );
                        }
                      },
                      onPressed: () {
                        setState(() {
                          selectedValueCommune = 'Commune code';
                          selectedValueVillage = 'Village code';
                          villagereadOnlys = false;
                        });
                      },
                      title: 'commune_code',
                      clear: true,
                      styleTexts: selectedValueCommune != ''
                          ? TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSizeXs,
                              color: Colors.black,
                              fontWeight: fontWeight500)
                          : TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSizeXs,
                              color: Colors.grey,
                              fontWeight: fontWeight500),
                      texts: selectedValueCommune != ''
                          ? selectedValueCommune
                          : "commune_code",
                      readOnlys: communereadOnlys,
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    DropDownCustomerRegister(
                      icons: Icons.location_on,
                      selectedValue: selectedValueVillage,
                      validate: validateVillage
                          ? RoundedRectangleBorder(
                              side: BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      clear: true,
                      onInSidePress: () async {
                        if (villagereadOnlys == true) {
                          await getVillage();
                          SelectDialog.showModal<String>(
                            context,
                            label: AppLocalizations.of(context)
                                    .translate('search') ??
                                'Search',
                            items: List.generate(listVillages.length,
                                (index) => "${listVillages[index]['vildes']}"),
                            onChange: (value) async {
                              setState(() {
                                selectedValueVillage = value ?? '';
                              });
                              listVillages.forEach((item) {
                                if (selectedValueVillage == item['vildes']) {
                                  setState(() {
                                    idVillage = item['vilcode'];
                                  });
                                }
                              });
                            },
                          );
                        }
                      },
                      iconsClose: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          selectedValueVillage = 'Village code';
                          villagereadOnlys = false;
                        });
                      },
                      styleTexts: selectedValueVillage != ''
                          ? TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSizeXs,
                              color: Colors.black,
                              fontWeight: fontWeight500)
                          : TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSizeXs,
                              color: Colors.grey,
                              fontWeight: fontWeight500),
                      texts: selectedValueVillage != ''
                          ? selectedValueVillage
                          : "village_code",
                      title: 'village_code',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.navigation,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  FlatButton(
                                    child: Container(
                                      width: 240,
                                      child: Text(
                                        _currentAddress ??
                                            AppLocalizations.of(context)
                                                .translate('get_location') ??
                                            "Get location",
                                        textAlign: TextAlign.center,
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
                    Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                    AnimatedButton(
                      text: AppLocalizations.of(context).translate('submit') ??
                          'Submit',
                      color: logolightGreen,
                      pressEvent: () {
                        if (selectedValueVillage == 'Village code') {
                          setState(() {
                            validateVillage = true;
                          });
                        } else {
                          AwesomeDialog(
                              context: context,
                              // animType: AnimType.LEFTSLIDE,
                              headerAnimationLoop: false,
                              dialogType: DialogType.SUCCES,
                              title: AppLocalizations.of(context)
                                      .translate('succes') ??
                                  'Succes',
                              desc: AppLocalizations.of(context)
                                      .translate('thank_you') ??
                                  'Thank you',
                              btnOkOnPress: () async {
                                if (selectedValueVillage == 'Village code') {
                                  setState(() {
                                    validateVillage = true;
                                  });
                                } else {
                                  await onSubmit(context);
                                  setState(() {
                                    validateVillage = false;
                                  });
                                }
                              },
                              btnCancelText: AppLocalizations.of(context)
                                      .translate('cancel') ??
                                  "cancel",
                              btnCancelOnPress: () {},
                              btnCancelIcon: Icons.close,
                              btnOkIcon: Icons.check_circle,
                              btnOkColor: logolightGreen,
                              btnOkText: AppLocalizations.of(context)
                                      .translate('okay') ??
                                  'Okay')
                            ..show();
                        }
                      },
                    ),
                    Padding(padding: EdgeInsets.only(bottom: bottomPadding))
                  ],
                ),
              ),
            ),
    );
  }
}
