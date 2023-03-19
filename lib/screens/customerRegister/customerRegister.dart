import 'dart:convert';
import 'package:chokchey_finance/components/dropdownCustomersRegister.dart';
import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/components/maxWidthWrapper.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/customerRegistration.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/listCustomerRegistration/index.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CustomerRegister extends StatefulWidget {
  final dynamic list;
  CustomerRegister({this.list});
  @override
  _CustomerRegister createState() => _CustomerRegister();
}

class _CustomerRegister extends State {
  // final dynamic list;
  // _CustomerRegister({this.list});

  // new state;
  var stateProvince;
  //
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
  var selectedValueProvince;
  var selectedValueDistrict;
  var selectedValueCommune;
  var selectedValueVillage;
  bool validateVillage = false;
  var idProvince;
  var idDistrict;
  var idCommune;
  var idVillage;

  Position? _currentPosition;
  String? _currentAddress;

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

  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });

    _getAddressFromLatLng();
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];
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
      if (khmerName.currentState!.saveAndValidate() &&
          englishName.currentState!.saveAndValidate() &&
          phoneKey.currentState!.saveAndValidate() &&
          occupationOfCustomer.currentState!.saveAndValidate() &&
          _gender.currentState!.saveAndValidate()) {
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
                _currentAddress);
        var nextNavigator =
            Provider.of<CustomerRegistrationProvider>(context, listen: false)
                .isFetchingOkay;
        if (nextNavigator == true) {
          showInSnackBar(
              AppLocalizations.of(context)!.translate(
                      'customer_registration_has_been_successfully') ??
                  'Customer registration has been successfully completed!',
              logolightGreen);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListCustomerRegistrations()),
          );
        } else {
          showInSnackBar(
              AppLocalizations.of(context)!
                      .translate('customer_registration_has_been_failed') ??
                  'Customer registration has been failed!',
              Colors.redAccent);
        }
      }
    } catch (error) {}
  }

  final GlobalKey<ScaffoldState> _scaffoldKeyCreateCustomer =
      new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value, colorsBackground) {
    SnackBar snackBar = SnackBar(
      content: Text(value),
      backgroundColor: colorsBackground,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      final Response response = await api().get(
        Uri.parse(baseURLInternal + 'valuelists/idtypes'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
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
      final Response response = await api().get(
        Uri.parse(baseURLInternal + 'addresses/provinces'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      final parsed = jsonDecode(response.body);
      // listProvince.addAll(parsed);
      listProvince.add(parsed);
    } catch (error) {}
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
      final Response response = await api().get(
        Uri.parse(baseURLInternal + 'addresses/districts/' + idProvince),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      final parsed = jsonDecode(response.body);
      setState(() {
        listDistricts = parsed;
      });
      // await response.close();
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
      final Response response = await api().get(
        Uri.parse(baseURLInternal + 'addresses/communes/' + idDistrict),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      final parsed = jsonDecode(response.body);
      setState(() {
        listComunes = parsed;
      });
      // await response.close();
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
      final Response response = await api().get(
        Uri.parse(baseURLInternal + 'addresses/Villages/' + idCommune),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      final parsed = jsonDecode(response.body);
      setState(() {
        listVillages = parsed;
      });
      // await response.close();
    } catch (error) {}
  }

  getIDVillage() async {
    listVillages.forEach((item) async {
      if (selectedValueVillage == item['vildes']) {
        setState(() {
          idVillage = item['vilcode'];
        });
      }
    });
  }

  bool isAdult(String birthDateString) {
    String datePattern = "dd-MM-yyyy";

    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;
    return yearDiff > 18 || yearDiff == 18 && monthDiff >= 0 && dayDiff >= 0;
  }

  bool isAdult2(String birthDateString) {
    String datePattern = "dd-MM-yyyy";

    // Current time - at this moment
    DateTime today = DateTime.now();

    // Parsed date to check
    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);

    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      birthDate.year + 18,
      birthDate.month,
      birthDate.day,
    );
    return adultDate.isBefore(today);
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();

    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  checkMoreThenCurrentDay(dateToCheck) {
    var fullDatePicker = "0";
    var now = DateTime.now();
    var day = DateTime(now.year, now.month, now.day).day;
    var month = DateTime(now.year, now.month, now.day).month;
    var year = DateTime(now.year, now.month, now.day).year;
    var nday = day.toString().padLeft(2, "0");
    var nmonth = month.toString().padLeft(2, "0");
    var fullDate = "$year$nmonth$nday";

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
      fullDatePicker = "$aYear$nmonthPicker$ndayPicker";
    }

    var val1 = int.parse(fullDate);
    var val2 = int.parse(fullDatePicker);
    int checkNext = val2 - val1;
  }

  UnfocusDisposition disposition = UnfocusDisposition.scope;

  @override
  void initState() {
    super.initState();
    khmerNameFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    debugPrint("Focus: " + khmerNameFocus.hasFocus.toString());
  }

  void _handleRadioValueChange1(v) {
    setState(() {
      _radioValueState = true;
    });
  }

  var _radioValue;
  bool _radioValueState = false;

  getValueKhmerName(v) {
    setState(() {
      valueKhmerName = v;
    });
  }

  getValueEnglishName(v) {
    setState(() {
      valueEnglishName = v;
    });
  }

  getGenderValueF(v) {
    setState(() {
      gender = 'F';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 20.0 : 5.0;
    return Header(
      keys: _scaffoldKeyCreateCustomer,
      headerTexts: 'customer_registration',
      bodys: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: MaxWidthWrapper(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: new Column(
                    children: <Widget>[
                      GroupFromBuilder(
                        icons: Icons.person,
                        keys: khmerName,
                        childs: FormBuilderTextField(
                          name: 'name',
                          focusNode: khmerNameFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(englishNameFocus);
                          },
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context)!
                                    .translate('full_khmer_name') ??
                                'Full Khmer Name(*)',
                          ),
                          onChanged: (v) {
                            if (mounted) {
                              getValueKhmerName(v);
                            }
                          },
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: AppLocalizations.of(context)!
                                        .translate('khmer_name_required') ??
                                    "Khmer Name required"),
                          ]),
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9/\\\\|!.]"))
                            // ignore: deprecated_member_use
                            // BlacklistingTextInputFormatter(
                            //     RegExp("[0-9/\\\\|!.]")),
                          ],
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.person,
                        keys: englishName,
                        childs: FormBuilderTextField(
                          name: 'name',
                          focusNode: englishNameFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (v) {
                            FocusScope.of(context)
                                .unfocus(disposition: disposition);
                            FocusScope.of(context)
                                .requestFocus(datehofBrithFocus);
                          },
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              labelText: AppLocalizations.of(context)!
                                      .translate('full_english_name') ??
                                  'Full English Name'),
                          onChanged: (v) {
                            if (mounted) {
                              getValueEnglishName(v);
                            }
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: AppLocalizations.of(context)!
                                        .translate('english_name_required') ??
                                    "English Name required"),
                          ]),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z]"))
                            // ignore: deprecated_member_use
                            // new WhitelistingTextInputFormatter(
                            //     RegExp("[a-z A-Z]")),
                          ],
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.wc,
                        keys: _gender,
                        childs: FormBuilderRadioGroup(
                          options: [
                            AppLocalizations.of(context)!.translate("female"),
                            AppLocalizations.of(context)!.translate("male"),
                          ]
                              .map(
                                  (lang) => FormBuilderFieldOption(value: lang))
                              .toList(growable: false),
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Gender',
                          ),
                          name: "gender",
                          onChanged: (dynamic v) {
                            if (v == 'Female') {
                              FocusScope.of(context)
                                  .unfocus(disposition: disposition);
                              getGenderValueF(v);
                            } else {
                              FocusScope.of(context)
                                  .unfocus(disposition: disposition);
                              setState(() {
                                gender = 'M';
                              });
                            }
                          },
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(context,
                                  errorText: AppLocalizations.of(context)!
                                          .translate('gender_required') ??
                                      "Gender required(*)"),
                            ],
                          ),
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.phone,
                        keys: phoneKey,
                        childs: FormBuilderTextField(
                          name: 'phone',
                          focusNode: phoneKeyFocus,
                          controller: controllerPhone1,
                          textInputAction: TextInputAction.next,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context)!
                                    .translate('phone_number_1') ??
                                'Phone Number 1',
                          ),
                          onSubmitted: (v) {
                            FocusScope.of(context)
                                .unfocus(disposition: disposition);
                          },
                          maxLength: 10,
                          onChanged: (v) {
                            if (mounted) {
                              valuePhone1 = v;
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                            // WhitelistingTextInputFormatter.digitsOnly
                          ],
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: AppLocalizations.of(context)!
                                        .translate('phone_number_1_required') ??
                                    "Gender required(*)"),
                            FormBuilderValidators.numeric(context,
                                errorText: "Number only"),
                          ]),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.phone,
                        keys: phoneKey2,
                        childs: FormBuilderTextField(
                          name: 'name',
                          focusNode: phoneKey2Focus,
                          controller: controllerPhone2,
                          textInputAction: TextInputAction.next,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              labelText: AppLocalizations.of(context)!
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
                            FilteringTextInputFormatter.digitsOnly
                            // WhitelistingTextInputFormatter.digitsOnly
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
                          name: "Name",
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                    .translate('occupation_of_customer') ??
                                "Occupation of customer",
                            border: InputBorder.none,
                          ),
                          hint: Text(
                            AppLocalizations.of(context)!
                                    .translate('occupation_of_customer') ??
                                'Occupation of customer',
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
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: AppLocalizations.of(context)!
                                        .translate(
                                            'occupation_of_customer_required') ??
                                    "Occupation of customer Required(*)")
                          ]),
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
                          name: "",
                          inputType: InputType.date,
                          focusNode: nextVisitDateFocus,
                          textInputAction: TextInputAction.next,
                          onChanged: (v) {
                            FocusScope.of(context)
                                .unfocus(disposition: disposition);
                            valueNextVisitDate = v;
                            checkMoreThenCurrentDay(v);
                          },
                          initialValue: DateTime.now(),
                          firstDate: DateTime.now(),
                          format: DateFormat("yyyy-MM-dd"),
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
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
                          name: 'name',
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                    .translate('prospective') ??
                                "Prospective",
                            border: InputBorder.none,
                          ),
                          hint: Text(
                            AppLocalizations.of(context)!
                                    .translate('prospective') ??
                                'Prospective Y=Yes, N=No',
                          ),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .unfocus(disposition: disposition);
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
                            final Response response = await api().get(
                              Uri.parse(
                                  baseURLInternal + 'addresses/provinces'),
                              headers: {
                                "Content-Type": "application/json",
                                "Authorization": "Bearer $token"
                              },
                            );
                            list = jsonDecode(response.body);
                            setState(() {
                              stateProvince = list ?? '';
                            });
                          } catch (error) {}
                          SelectDialog.showModal<String>(
                            context,
                            label: AppLocalizations.of(context)!
                                    .translate('search') ??
                                'Search',
                            items: List.generate(list.length,
                                (index) => "${list[index]['prodes']}"),
                            onChange: (value) async {
                              if (mounted) {
                                FocusScope.of(context)
                                    .unfocus(disposition: disposition);
                                setState(() {
                                  selectedValueProvince = value;
                                  selectedValueDistrict =
                                      AppLocalizations.of(context)!
                                          .translate('district_code');
                                  selectedValueCommune =
                                      AppLocalizations.of(context)!
                                          .translate('commune_code');
                                  selectedValueVillage =
                                      AppLocalizations.of(context)!
                                          .translate('village_code');
                                  districtreadOnlys = true;
                                });
                              }
                            },
                          );
                        },
                        selectedValue: selectedValueProvince,
                        texts: selectedValueProvince != null
                            ? selectedValueProvince
                            : AppLocalizations.of(context)!
                                    .translate('province_code') ??
                                'Province code',
                        title: selectedValueProvince != null
                            ? selectedValueProvince
                            : AppLocalizations.of(context)!
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
                              selectedValueProvince =
                                  AppLocalizations.of(context)!
                                          .translate('province_code') ??
                                      'Province code';
                              selectedValueDistrict =
                                  AppLocalizations.of(context)!
                                          .translate('district_code') ??
                                      'District code';
                              selectedValueCommune =
                                  AppLocalizations.of(context)!
                                          .translate('commune_code') ??
                                      'Commune code';
                              selectedValueVillage =
                                  AppLocalizations.of(context)!
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
                            : AppLocalizations.of(context)!
                                    .translate('district_code') ??
                                'District code',
                        title: selectedValueDistrict != null
                            ? selectedValueDistrict
                            : AppLocalizations.of(context)!
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
                                label: AppLocalizations.of(context)!
                                        .translate('search') ??
                                    'Search',
                                items: List.generate(
                                    listDistricts.length,
                                    (index) =>
                                        "${listDistricts[index]['disdes']}"),
                                onChange: (value) {
                                  setState(() {
                                    selectedValueDistrict = value;
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
                              selectedValueDistrict =
                                  AppLocalizations.of(context)!
                                          .translate('district_code') ??
                                      'District code';
                              selectedValueCommune =
                                  AppLocalizations.of(context)!
                                          .translate('commune_code') ??
                                      'Commune code';
                              selectedValueVillage =
                                  AppLocalizations.of(context)!
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
                            FocusScope.of(context)
                                .unfocus(disposition: disposition);
                            if (communereadOnlys == true) {
                              await getCommune();
                              SelectDialog.showModal<String>(
                                context,
                                label: AppLocalizations.of(context)!
                                        .translate('search') ??
                                    'Search',
                                items: List.generate(
                                    listComunes.length,
                                    (index) =>
                                        "${listComunes[index]['comdes']}"),
                                onChange: (value) {
                                  setState(() {
                                    selectedValueCommune = value;
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
                              selectedValueCommune =
                                  AppLocalizations.of(context)!
                                          .translate('commune_code') ??
                                      'Commune code';
                              selectedValueVillage =
                                  AppLocalizations.of(context)!
                                          .translate('village_code') ??
                                      'Village code';
                              villagereadOnlys = false;
                            });
                          }
                        },
                        texts: selectedValueCommune != null
                            ? selectedValueCommune
                            : AppLocalizations.of(context)!
                                    .translate('commune_code') ??
                                'District code',
                        title: selectedValueCommune != null
                            ? selectedValueCommune
                            : AppLocalizations.of(context)!
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
                        clear: true,
                        onInSidePress: () async {
                          FocusScope.of(context)
                              .unfocus(disposition: disposition);
                          if (villagereadOnlys == true) {
                            await getVillage();
                            SelectDialog.showModal<String>(
                              context,
                              label: AppLocalizations.of(context)!
                                      .translate('search') ??
                                  'Search',
                              items: List.generate(
                                  listVillages.length,
                                  (index) =>
                                      "${listVillages[index]['vildes']}"),
                              onChange: (value) async {
                                setState(() {
                                  selectedValueVillage = value;
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
                        },
                        iconsClose: Icon(Icons.close),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              selectedValueVillage =
                                  AppLocalizations.of(context)!
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
                            : AppLocalizations.of(context)!
                                    .translate('village_code') ??
                                'Village code',
                        title: selectedValueVillage != null
                            ? selectedValueVillage
                            : AppLocalizations.of(context)!
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
                                    ElevatedButton(
                                      child: Container(
                                        width: 240,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                  _currentAddress ??
                                                      AppLocalizations.of(
                                                              context)!
                                                          .translate(
                                                              'get_location') ??
                                                      "Get location",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: fontFamily,
                                                      fontSize: 17,
                                                      color: Colors.grey[500],
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
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
                        text:
                            AppLocalizations.of(context)!.translate('submit') ??
                                'Submit',
                        color: logolightGreen,
                        pressEvent: () async {
                          if (khmerName.currentState!.saveAndValidate() &&
                              englishName.currentState!.saveAndValidate() &&
                              _gender.currentState!.saveAndValidate() &&
                              phoneKey.currentState!.saveAndValidate() &&
                              occupationOfCustomer.currentState!
                                  .saveAndValidate()) {
                            // await onSubmit(context);
                            if (selectedValueVillage == null ||
                                selectedValueVillage ==
                                    AppLocalizations.of(context)!
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
                                  title: AppLocalizations.of(context)!
                                          .translate('information') ??
                                      'Information',
                                  desc: AppLocalizations.of(context)!
                                          .translate('are_you_sure_you') ??
                                      'Are you sure you want to register the customer?',
                                  btnOkOnPress: () async {
                                    if (selectedValueVillage == null ||
                                        selectedValueVillage ==
                                            AppLocalizations.of(context)!
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
                                  btnCancelText: AppLocalizations.of(context)!
                                          .translate('no') ??
                                      "No",
                                  btnCancelOnPress: () {},
                                  btnCancelIcon: Icons.close,
                                  btnOkIcon: Icons.check_circle,
                                  btnOkColor: logolightGreen,
                                  btnOkText: AppLocalizations.of(context)!
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
            ),
    );
  }
}
