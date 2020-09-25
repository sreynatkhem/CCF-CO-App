import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chokchey_finance/components/dropdownCustomersRegister.dart';
import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
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
    _groupValue = list.gender == "F" ? 1 : 0;
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
  var stateProvince;

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

  getDistrict(stateProvince) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    stateProvince.forEach((item) async {
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

  var statusCodes;
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
              gender,
              valuePhone1,
              valuePhone2,
              valueOccupationOfCustomer,
              valueNextVisitDate,
              valueProspective,
              idProvince,
              idDistrict,
              idCommune,
              idVillage,
              _currentAddress)
          .then((value) async => {
                statusCodes =
                    await Provider.of<ListCustomerRegistrationProvider>(context,
                            listen: false)
                        .isStatusCode,
                if (statusCodes == true)
                  {
                    await Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => CardDetailCustomer(
                            list: ccdoe,
                          ),
                        ),
                        ModalRoute.withName('/')),
                  }
              });
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
  getGenderValueF(v) {
    setState(() {
      gender = 'F';
    });
  }

  checkMoreThenCurrentDay(dateToCheck) {
    var fullDatePicker = "0";
    var now = DateTime.now();
    var day = DateTime(now.year, now.month, now.day).day;
    var month = DateTime(now.year, now.month, now.day).month;
    var year = DateTime(now.year, now.month, now.day).year;
    var nday = day.toString().padLeft(2, "0");
    var nmonth = month.toString().padLeft(2, "0");
    var fullDate = "${year}${nmonth}${nday}";

    // final yesterday = DateTime(now.year, now.month, now.day - 1);
    // final tomorrow = DateTime(now.year, now.month, now.day + 1);
    var aDay;
    var aMonth;
    var aYear;

    if (dateToCheck != null) {
      aDay = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day).day;
      aMonth =
          DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day).month;
      aYear =
          DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day).year;

      var ndayPicker = aDay.toString().padLeft(2, "0");
      var nmonthPicker = aMonth.toString().padLeft(2, "0");
      fullDatePicker = "${aYear}${nmonthPicker}${ndayPicker}";
    }

    var val1 = int.parse(fullDate);
    var val2 = int.parse(fullDatePicker);
    int checkNext = val2 - val1;

// if(aDate == today) {
//   }
//  // ignore: unnecessary_statements
//  else (aDate == tomorrow)  {
// };
  }

  UnfocusDisposition disposition = UnfocusDisposition.scope;
  int _groupValue = -1;
  @override
  Widget build(BuildContext context) {
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 20.0 : 5.0;
    return Header(
      headerTexts: 'edit_customers_register',
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
                  if (khmerName.currentState.saveAndValidate() &&
                      englishName.currentState.saveAndValidate() &&
                      phoneKey.currentState.saveAndValidate()) {
                    // await onSubmit(context);
                    if (selectedValueVillage == null ||
                        selectedValueVillage ==
                            AppLocalizations.of(context)
                                .translate('village_code')) {
                      setState(() {
                        validateVillage = true;
                      });
                    } else {
                      AwesomeDialog(
                          context: context,
                          // animType: AnimType.LEFTSLIDE,
                          headerAnimationLoop: false,
                          dialogType: DialogType.INFO,
                          title: AppLocalizations.of(context)
                                  .translate('information') ??
                              'Information',
                          desc: AppLocalizations.of(context)
                                  .translate('are_you_sure_you') ??
                              'Are you sure you want to register the customer?',
                          btnOkOnPress: () async {
                            if (selectedValueVillage == null ||
                                selectedValueVillage ==
                                    AppLocalizations.of(context)
                                        .translate('village_code')) {
                              // await onSubmit(context);
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
                          btnCancelText:
                              AppLocalizations.of(context).translate('no') ??
                                  "No",
                          btnCancelOnPress: () {},
                          btnCancelIcon: Icons.close,
                          btnOkIcon: Icons.check_circle,
                          btnOkColor: logolightGreen,
                          btnOkText:
                              AppLocalizations.of(context).translate('yes') ??
                                  'Yes')
                        ..show();
                    }
                  } else {
                    logger().e("edit: custmer");
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
                            labelText: AppLocalizations.of(context)
                                    .translate('full_khmer_name') ??
                                'Full Khmer Name(*)'),
                        onChanged: (v) {
                          if (mounted) {
                            setState(() {
                              valueKhmerName = v;
                            });
                          }
                        },
                        valueTransformer: (text) {
                          return text == null ? null : text;
                        },
                        validators: [
                          FormBuilderValidators.required(
                              errorText: AppLocalizations.of(context)
                                      .translate('khmer_name_required') ??
                                  "Khmer Name required"),
                        ],
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          BlacklistingTextInputFormatter(
                              RegExp("[0-9/\\\\|!.]")),
                        ],
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
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context)
                                    .translate('full_english_name') ??
                                'Full English Name'),
                        onChanged: (v) {
                          if (mounted) {
                            setState(() {
                              valueEnglishName = v;
                            });
                          }
                        },
                        valueTransformer: (text) {
                          return text == null ? null : text;
                        },
                        validators: [
                          FormBuilderValidators.required(
                              errorText: AppLocalizations.of(context)
                                      .translate('english_name_required') ??
                                  "English Name required"),
                        ],
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          new WhitelistingTextInputFormatter(
                              RegExp("[a-z A-Z]")),
                        ],
                      ),
                    ),
                    // GroupFromBuilder(
                    //   icons: Icons.wc,
                    //   keys: _gender,
                    //   childs: FormBuilderRadioGroup(
                    //     decoration: new InputDecoration(
                    //       border: InputBorder.none,
                    //       labelText: 'Gender',
                    //     ),
                    //     attribute: "radio_group",
                    //     validators: [
                    //       FormBuilderValidators.required(
                    //           errorText: AppLocalizations.of(context)
                    //                   .translate('gender_required') ??
                    //               "Gender required(*)"),
                    //     ],
                    //     onChanged: (v) {
                    //       if (v == 'Female') {
                    //         FocusScope.of(context)
                    //             .unfocus(disposition: disposition);
                    //         getGenderValueF(v);
                    //       } else {
                    //         FocusScope.of(context)
                    //             .unfocus(disposition: disposition);
                    //         setState(() {
                    //           gender = 'M';
                    //         });
                    //       }
                    //     },
                    //     options: [
                    //       AppLocalizations.of(context).translate("female"),
                    //       AppLocalizations.of(context).translate("male"),
                    //     ]
                    //         .map((lang) => FormBuilderFieldOption(value: lang))
                    //         .toList(growable: false),
                    //   ),
                    // ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(left: 55, top: 5),
                                    child: Text(
                                      'Gender',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 0,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 3),
                                            child: Icon(
                                              Icons.wc,
                                              color: Colors.grey,
                                            ),
                                          )),
                                      Expanded(
                                        flex: 1,
                                        child: RadioListTile(
                                          value: 1,
                                          groupValue: _groupValue,
                                          title: Text(
                                              AppLocalizations.of(context)
                                                  .translate("female")),
                                          onChanged: (newValue) => {
                                            setState(() {
                                              gender = 'F';
                                              _groupValue = newValue;
                                            })
                                          },
                                          activeColor: Colors.blue,
                                          selected: false,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RadioListTile(
                                          value: 0,
                                          groupValue: _groupValue,
                                          title: Text(
                                              AppLocalizations.of(context)
                                                  .translate("male")),
                                          onChanged: (newValue) => {
                                            setState(() {
                                              gender = 'M';
                                              _groupValue = newValue;
                                            })
                                          },
                                          activeColor: Colors.blue,
                                          selected: false,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 70,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context)
                                    .translate('phone_number_1') ??
                                'Phone Number 1'),
                        maxLength: 10,
                        onChanged: (v) {
                          if (mounted) {
                            valuePhone1 = v;
                          }
                        },
                        validators: [
                          FormBuilderValidators.numeric(
                              errorText: "Number only"),
                          FormBuilderValidators.required(
                              errorText: AppLocalizations.of(context)
                                      .translate('phone_number_1_required') ??
                                  "Phone Number 1 Required(*)")
                        ],
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
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context)
                                    .translate('phone_number_2') ??
                                'Phone Number 2'),
                        maxLength: 10,
                        onChanged: (v) {
                          if (mounted) {
                            valuePhone2 = v;
                          }
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
                      childs: FormBuilderDropdown(
                        attribute: "Name",
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('occupation_of_customer') ??
                              "Occupation of customer",
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          list.occupation ??
                              AppLocalizations.of(context)
                                  .translate('occupation_of_customer') ??
                              'Occupation of customer',
                          style: TextStyle(
                              color: list.occupation != null &&
                                      list.occupation != ""
                                  ? Colors.black
                                  : null),
                        ),
                        onChanged: (value) {
                          if (mounted) {
                            FocusScope.of(context)
                                .unfocus(disposition: disposition);
                            setState(() {
                              valueOccupationOfCustomer = value;
                            });
                          }
                        },
                        validators: [
                          FormBuilderValidators.required(
                              errorText: AppLocalizations.of(context).translate(
                                      'occupation_of_customer_required') ??
                                  "Occupation of customer Required(*)")
                        ],
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
                          if (mounted) {
                            FocusScope.of(context)
                                .unfocus(disposition: disposition);
                            valueNextVisitDate = v;
                            checkMoreThenCurrentDay(v);
                          }
                        },
                        // initialValue: DateTime.now(),
                        // firstDate: DateTime.now(),
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(
                          labelText: list.ndate != null && list.ndate != ""
                              ? getDateTimeYMD(list.ndate)
                              : AppLocalizations.of(context)
                                      .translate('next_visit_date') ??
                                  "Next visit date",
                          labelStyle: list.ndate != null && list.ndate != ''
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
                          labelText: AppLocalizations.of(context)
                                  .translate('prospective') ??
                              "Prospective",
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          valueProspective ??
                              AppLocalizations.of(context)
                                  .translate('prospective') ??
                              'Prospective Y=Yes, N=No',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              valueProspective = value;
                            });
                            FocusScope.of(context)
                                .unfocus(disposition: disposition);
                          }
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
                    Padding(padding: EdgeInsets.only(top: 10)),
                    DropDownCustomerRegister(
                      icons: Icons.location_on,
                      validate: validateVillage
                          ? RoundedRectangleBorder(
                              side: BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      onInSidePress: () async {
                        FocusScope.of(context)
                            .unfocus(disposition: disposition);
                        final storage = new FlutterSecureStorage();
                        var token = await storage.read(key: 'user_token');
                        var list;
                        try {
                          final response = await api().get(
                            baseURLInternal + 'addresses/provinces',
                            headers: {
                              "Content-Type": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          list = jsonDecode(response.body);
                          setState(() {
                            stateProvince = list ?? '';
                          });
                        } catch (error) {}
                        SelectDialog.showModal<String>(
                          context,
                          label: AppLocalizations.of(context)
                                  .translate('search') ??
                              'Search',
                          items: List.generate(list.length,
                              (index) => "${list[index]['prodes']}"),
                          onChange: (value) {
                            if (mounted) {
                              FocusScope.of(context)
                                  .unfocus(disposition: disposition);
                              setState(() {
                                selectedValueProvince = value ?? '';
                                selectedValueDistrict =
                                    AppLocalizations.of(context)
                                            .translate('district_code') ??
                                        'District code';
                                selectedValueCommune =
                                    AppLocalizations.of(context)
                                            .translate('commune_code') ??
                                        'Commune code';
                                selectedValueVillage =
                                    AppLocalizations.of(context)
                                            .translate('village_code') ??
                                        'Village code';
                                districtreadOnlys = true;
                              });
                            }
                          },
                        );
                      },
                      selectedValue: selectedValueProvince,
                      texts: selectedValueProvince != null
                          ? selectedValueProvince
                          : AppLocalizations.of(context)
                                  .translate('province_code') ??
                              'Province code',
                      title: selectedValueProvince != null
                          ? selectedValueProvince
                          : AppLocalizations.of(context)
                                  .translate('province_code') ??
                              'Province code',
                      clear: true,
                      readOnlys: true,
                      iconsClose: Icon(Icons.close),
                      onPressed: () {
                        if (mounted) {
                          FocusScope.of(context)
                              .unfocus(disposition: disposition);
                          setState(() {
                            selectedValueProvince = AppLocalizations.of(context)
                                    .translate('province_code') ??
                                'Province code';
                            selectedValueDistrict = AppLocalizations.of(context)
                                    .translate('district_code') ??
                                'District code';
                            selectedValueCommune = AppLocalizations.of(context)
                                    .translate('commune_code') ??
                                'Commune code';
                            selectedValueVillage = AppLocalizations.of(context)
                                    .translate('village_code') ??
                                'Village code';
                            districtreadOnlys = false;
                            communereadOnlys = false;
                            villagereadOnlys = false;
                          });
                        }
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
                      texts: selectedValueDistrict != null
                          ? selectedValueDistrict
                          : AppLocalizations.of(context)
                                  .translate('district_code') ??
                              'District code',
                      title: selectedValueDistrict != null
                          ? selectedValueDistrict
                          : AppLocalizations.of(context)
                                  .translate('district_code') ??
                              'District code',
                      clear: true,
                      iconsClose: Icon(Icons.close),
                      onInSidePress: () async {
                        if (mounted) {
                          FocusScope.of(context)
                              .unfocus(disposition: disposition);
                          if (districtreadOnlys == true) {
                            await getDistrict(stateProvince);
                            await SelectDialog.showModal<String>(
                              context,
                              label: AppLocalizations.of(context)
                                      .translate('search') ??
                                  'Search',
                              items: List.generate(
                                  listDistricts.length,
                                  (index) =>
                                      "${listDistricts[index]['disdes']}"),
                              onChange: (value) {
                                setState(() {
                                  selectedValueDistrict = value ?? '';
                                  communereadOnlys = true;
                                });
                              },
                            );
                          }
                        }
                      },
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            selectedValueDistrict = AppLocalizations.of(context)
                                    .translate('district_code') ??
                                'District code';
                            selectedValueCommune = AppLocalizations.of(context)
                                    .translate('commune_code') ??
                                'Commune code';
                            selectedValueVillage = AppLocalizations.of(context)
                                    .translate('village_code') ??
                                'Village code';
                            villagereadOnlys = false;
                            communereadOnlys = false;
                          });
                        }
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
                        if (mounted) {
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
                        }
                      },
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            selectedValueCommune = AppLocalizations.of(context)
                                    .translate('commune_code') ??
                                'Commune code';
                            selectedValueVillage = AppLocalizations.of(context)
                                    .translate('village_code') ??
                                'Village code';
                            villagereadOnlys = false;
                          });
                        }
                      },
                      texts: selectedValueCommune != null
                          ? selectedValueCommune
                          : AppLocalizations.of(context)
                                  .translate('commune_code') ??
                              'District code',
                      title: selectedValueCommune != null
                          ? selectedValueCommune
                          : AppLocalizations.of(context)
                                  .translate('commune_code') ??
                              'Commune code',
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
                        if (mounted) {
                          FocusScope.of(context)
                              .unfocus(disposition: disposition);
                          if (villagereadOnlys == true) {
                            await getVillage();
                            SelectDialog.showModal<String>(
                              context,
                              label: AppLocalizations.of(context)
                                      .translate('search') ??
                                  'Search',
                              items: List.generate(
                                  listVillages.length,
                                  (index) =>
                                      "${listVillages[index]['vildes']}"),
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
                          } else {
                            logger().e('false');
                          }
                        }
                      },
                      iconsClose: Icon(Icons.close),
                      clear: true,
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            selectedValueVillage = AppLocalizations.of(context)
                                    .translate('village_code') ??
                                'Village code';
                            villagereadOnlys = true;
                          });
                        }
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
                      texts: selectedValueVillage != null
                          ? selectedValueVillage
                          : AppLocalizations.of(context)
                                  .translate('village_code') ??
                              'Village code',
                      title: selectedValueVillage != null
                          ? selectedValueVillage
                          : AppLocalizations.of(context)
                                  .translate('village_code') ??
                              'Village code',
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
                                      if (mounted) {
                                        _getCurrentLocation();
                                      }
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
                      pressEvent: () async {
                        if (khmerName.currentState.saveAndValidate() &&
                            englishName.currentState.saveAndValidate() &&
                            phoneKey.currentState.saveAndValidate()) {
                          // await onSubmit(context);
                          if (selectedValueVillage == null ||
                              selectedValueVillage ==
                                  AppLocalizations.of(context)
                                      .translate('village_code')) {
                            setState(() {
                              validateVillage = true;
                            });
                          } else {
                            AwesomeDialog(
                                context: context,
                                // animType: AnimType.LEFTSLIDE,
                                headerAnimationLoop: false,
                                dialogType: DialogType.INFO,
                                title: AppLocalizations.of(context)
                                        .translate('information') ??
                                    'Information',
                                desc: AppLocalizations.of(context)
                                        .translate('are_you_sure_you') ??
                                    'Are you sure you want to register the customer?',
                                btnOkOnPress: () async {
                                  if (selectedValueVillage == null ||
                                      selectedValueVillage ==
                                          AppLocalizations.of(context)
                                              .translate('village_code')) {
                                    // await onSubmit(context);
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
                                        .translate('no') ??
                                    "No",
                                btnCancelOnPress: () {},
                                btnCancelIcon: Icons.close,
                                btnOkIcon: Icons.check_circle,
                                btnOkColor: logolightGreen,
                                btnOkText: AppLocalizations.of(context)
                                        .translate('yes') ??
                                    'Yes')
                              ..show();
                          }
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
