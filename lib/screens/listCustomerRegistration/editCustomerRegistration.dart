import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chokchey_finance/components/dropdownCustomersRegister.dart';
import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
import 'package:chokchey_finance/providers/manageService.dart';
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

import 'detailCustomerRegistration.dart';

class EditCustomerRegister extends StatefulWidget {
  final dynamic list;
  EditCustomerRegister({this.list});
  @override
  _CustomerRegister createState() => _CustomerRegister(list: list);
}

class _CustomerRegister extends State {
  final dynamic list;
  _CustomerRegister({this.list});
  var _isIint = false;
  var _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      controllerFullNameKhmer.text = list.namekhr;
      valueKhmerName = list.namekhr;
      controllerFullNameEnglish.text = list.nameeng;
      valueEnglishName = list.nameeng;
      controllerDatehofBrith.text =
          getDateTimeYMD(list.dob ?? DateTime.now().toString());
      valueDatehofBrith = getDateTimeYMD(list.dob ?? DateTime.now().toString());
      gender = list.gender;
      valuePhone1 = list.phone1 ?? "";
      controllerPhone1.text = list.phone1 ?? "";
      valuePhone2 = list.phone2 ?? "";
      controllerPhone2.text = list.phone2 ?? "";
      controllerOccupationofCustomer.text = list.occupation;
      valueOccupationOfCustomer = list.occupation;
      valueTextNationBookFamily = list.ntype;
      ntypes = list.ntype;
      controllerValueNationIdentification.text = list.nid;
      valueNationIdentification = list.nid;
      valueNextVisitDate = list.ndate;
      valueProspective = list.pro;
      valueGurantorCustomer = list.cstatus;
      selectedValueProvince = list.provinceName;
      selectedValueDistrict = list.districtName;
      selectedValueCommune = list.communeName;
      selectedValueVillage = list.villageName;

      idProvince = list.procode;
      idDistrict = list.discode;
      idCommune = list.comcode;
      idVillage = list.vilcode;

      controllerGoogleLocation.text = list.goglocation;
      _currentAddress = list.goglocation;
    });
    getListNationID();
    getListProvince();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      _isIint = true;
      _loading = true;
    });
    if (_isIint == true) {
      setState(() {
        _isIint = false;
        _loading = false;
      });
    }
    super.didChangeDependencies();
  }

  var valueKhmerName;
  var valueEnglishName;
  var valueDatehofBrith;
  var gender;
  var ntypes;
  var valuePhone1;
  var valuePhone2;
  var valueDateOfRegister;
  var valueOccupationOfCustomer;
  var valueNextVisitDate;
  var valueProspective;
  var valueGurantorCustomer;
  var valueTextNationBookFamily;
  String valueNationIdentification;
  String valueSelectedNativeID;
  String selectedValueProvince;
  String selectedValueDistrict;
  String selectedValueCommune;
  String selectedValueVillage;
  bool validateVillage = false;
  var idProvince;
  var idDistrict;
  var idCommune;
  var idVillage;

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

  final GlobalKey<FormBuilderState> _gender = GlobalKey<FormBuilderState>();
  final TextEditingController controllerDatehofBrith = TextEditingController();

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
  final TextEditingController controllerValueNationIdentification =
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

  var listID = [];
  var listProvince = [];
  var getProvinceID;
  var listDistricts = [];
  var listComunes = [];
  var listVillages = [];

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;

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

  var ccode;
  onSubmit(context) async {
    try {
      print({
        list.ccode,
        list.acode,
        list.rdate,
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
        _currentAddress
      });
      if (khmerName.currentState.saveAndValidate() &&
          englishName.currentState.saveAndValidate()) {
        var ccdoe = list.ccode;
        var acode = list.acode;
        var rdate = list.rdate;
        await Provider.of<ListCustomerRegistrationProvider>(context,
                listen: false)
            .editCustomerRegistration(
                ccdoe,
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
                idProvince,
                idDistrict,
                idCommune,
                idVillage,
                _currentAddress)
            .then((value) async => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CardDetailCustomer(
                          isRefresh: true,
                          list: ccdoe,
                        ),
                      ),
                      ModalRoute.withName('/')),
                });
      }
    } catch (error) {
      print('error :::: $error');
    }
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

  onBack() {}

  @override
  Widget build(BuildContext context) {
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 20.0 : 5.0;
    return Header(
      headerTexts: 'Edit Customers Register',
      actionsNotification: <Widget>[
        // Using Stack to show edit registration
        new Stack(
          children: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.save,
                  size: 25,
                ),
                onPressed: () {
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
                      title: 'Succes',
                      desc: 'Thank you',
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
                      btnCancelText: "Cancel",
                      btnCancelOnPress: () {},
                      btnCancelIcon: Icons.close,
                      btnOkIcon: Icons.check_circle,
                      btnOkColor: logolightGreen,
                    )..show();
                  }
                }),
          ],
        ),
      ],
      bodys: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(10),
                child: new Column(
                  children: <Widget>[
                    GroupFromBuilder(
                      icons: Icons.person,
                      keys: khmerName,
                      childs: FormBuilderTextField(
                        attribute: 'name',
                        focusNode: khmerNameFocus,
                        controller: controllerFullNameKhmer,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(englishNameFocus);
                        },
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Full Khmer Name'),
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
                        controller: controllerFullNameEnglish,
                        focusNode: englishNameFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context)
                              .requestFocus(datehofBrithFocus);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Full English Name',
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
                        focusNode: datehofBrithFocus,
                        controller: controllerDatehofBrith,
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
                          labelText: list.dob.toString() != ''
                              ? getDateTimeYMD(
                                  list.dob ?? DateTime.now().toString())
                              : "Date of brith",
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: fontSizeXs,
                          color: Colors.black,
                        ),
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
                          gender ?? 'Select Gender',
                          style: TextStyle(color: Colors.black),
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
                      childs: FormBuilderTextField(
                        attribute: 'name',
                        focusNode: phoneKeyFocus,
                        controller: controllerPhone1,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number 1',
                          border: InputBorder.none,
                        ),
                        maxLength: 14,
                        onChanged: (v) {
                          valuePhone1 = v;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        valueTransformer: (text) {
                          return text == null ? null : text;
                        },
                      ),
                    ),
                    GroupFromBuilder(
                      icons: Icons.phone,
                      keys: phoneKey2,
                      childs: FormBuilderTextField(
                        attribute: 'name',
                        focusNode: phoneKey2Focus,
                        controller: controllerPhone2,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number 2',
                          border: InputBorder.none,
                        ),
                        maxLength: 14,
                        onChanged: (v) {
                          valuePhone2 = v;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        valueTransformer: (text) {
                          return text == null ? null : text;
                        },
                      ),
                    ),
                    GroupFromBuilder(
                      icons: Icons.work,
                      keys: occupationOfCustomer,
                      childs: FormBuilderTextField(
                        attribute: 'name',
                        focusNode: occupationOfCustomerFocus,
                        controller: controllerOccupationofCustomer,
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
                            valueTextNationBookFamily ??
                                'Nation ID, Famliy book, Passport',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(color: Colors.black),
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
                    GroupFromBuilder(
                      icons: Icons.payment,
                      keys: nationIdentificationValue,
                      childs: FormBuilderTextField(
                        focusNode: nationIdentificationValueFocus,
                        attribute: 'name',
                        controller: controllerValueNationIdentification,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(nextVisitDateFocus),
                        maxLength: 9,
                        decoration: const InputDecoration(
                          labelText: 'Nation ID, Famliy book, Passport',
                          border: InputBorder.none,
                        ),
                        onChanged: (v) {
                          setState(() {
                            valueNationIdentification = v;
                          });
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
                        controller: controllerNextVisitDate,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(datehofRegisterFocus),
                        onChanged: (v) {
                          valueNextVisitDate = v;
                        },
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(
                          labelText: getDateTimeYMD(
                                  list.ndate ?? DateTime.now().toString()) ??
                              "Next visit date",
                          labelStyle: list.ndate != null
                              ? TextStyle(color: Colors.black)
                              : null,
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
                          labelText: "Prospective",
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          valueProspective ?? 'Prospective Y=Yes, N=No',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: TextStyle(color: Colors.black),
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
                          labelText: "G=Gurantor, C=Customer",
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          valueGurantorCustomer ?? 'G=Gurantor, C=Customer',
                          style: TextStyle(color: Colors.black),
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
                                onTap: () => print(
                                    '${selectedValueProvincefocus = true}'),
                                child: Text(
                                  "$valueGurantorCustomer",
                                )))
                            .toList(),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    DropDownCustomerRegister(
                      icons: Icons.location_on,
                      validate: validateVillage
                          ? RoundedRectangleBorder(
                              side: BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      onInSidePress: () {
                        SelectDialog.showModal<String>(
                          context,
                          label: 'Search',
                          items: List.generate(listProvince.length,
                              (index) => "${listProvince[index]['prodes']}"),
                          onChange: (value) {
                            setState(() {
                              selectedValueProvince = value;
                              selectedValueDistrict = '';
                              selectedValueCommune = '';
                              selectedValueVillage = '';
                              districtreadOnlys = true;
                            });
                          },
                        );
                      },
                      selectedValue: selectedValueProvince,
                      texts: selectedValueProvince,
                      title: 'Province code',
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
                          : 'District code',
                      title: 'District code',
                      iconsClose: Icon(Icons.close),
                      onInSidePress: () async {
                        if (districtreadOnlys == true) {
                          await getDistrict();
                          await SelectDialog.showModal<String>(
                            context,
                            label: 'Search',
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
                            label: 'Search',
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
                      title: 'Commune code',
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
                          : "Commune code",
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
                      onInSidePress: () async {
                        if (villagereadOnlys == true) {
                          await getVillage();
                          SelectDialog.showModal<String>(
                            context,
                            label: 'Search',
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
                          : "Village code",
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
                                        _currentAddress ?? "Get location",
                                        textAlign: TextAlign.center,
                                        style: _currentAddress != ""
                                            ? TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: 17,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400)
                                            : TextStyle(
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
                      text: 'Submit',
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
                            title: 'Succes',
                            desc: 'Thank you',
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
                            btnCancelText: "Cancel",
                            btnCancelOnPress: () {},
                            btnCancelIcon: Icons.close,
                            btnOkIcon: Icons.check_circle,
                            btnOkColor: logolightGreen,
                          )..show();
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
