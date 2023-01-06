import 'dart:convert';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/lmapProvider/index.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:select_dialog/select_dialog.dart';

import 'dropDownLmap.dart';

class LMapScreen extends StatefulWidget {
  const LMapScreen({Key? key}) : super(key: key);

  @override
  State<LMapScreen> createState() => _LMapScreenState();
}

class _LMapScreenState extends State<LMapScreen> {
  var currentDate;
  @override
  void didChangeDependencies() {
    fetchLamp("0", "", "", "", "");
    DateTime now = new DateTime.now();
    var date = DateFormat('dd MMMM, yyyy')
        .format(DateTime(now.year, now.month, now.day));
    currentDate = date;
  }

  var pageSizes = "10";
  bool isLoading = false;
  Future fetchLamp(
    pageSize,
    province,
    district,
    commune,
    village,
  ) async {
    setState(() {
      isLoading = true;
    });
    context
        .read<LmapProvider>()
        .getLmap(
          pageSize: "$pageSize",
          province: "$province",
          district: "$district",
          commune: "$commune",
          village: "$village",
        )
        .then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  getDistrict(stateProvince) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('GET',
          Uri.parse(baseURLInternal + 'addresses/district/' + stateProvince));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final parsed = jsonDecode(await response.stream.bytesToString());
        setState(() {
          listDistricts = parsed;
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('error $error');
    }
  }

  getCommune(listDistrict) async {
    try {
      var request = await http.Request('GET',
          Uri.parse(baseURLInternal + 'addresses/commune/$listDistrict'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final parsed = jsonDecode(await response.stream.bytesToString());
        setState(() {
          listComunes = parsed;
        });
      } else {
        setState(() {
          listComunes = [];
        });
      }
    } catch (error) {
      setState(() {
        listComunes = [];
      });
    }
  }

  getVillage(selectedValueCommune) async {
    try {
      final Response response = await api().get(
        Uri.parse(
            baseURLInternal + 'addresses/village/' + selectedValueCommune),
        headers: {
          "Content-Type": "application/json",
        },
      );
      final parsed = jsonDecode(response.body);
      setState(() {
        listVillages = parsed;
      });
      UserModels.fromJsonList(parsed);
    } catch (error) {}
  }

  var idProvince;
  var idDistrict;
  var idCommune;
  var idVillage;
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  var stateProvince;
  var selectedValueProvince;
  bool validateVillage = false;
  var selectedValueDistrict;
  var selectedValueCommune;
  String? selectedValueVillage;

  var districtreadOnlys = false;
  var communereadOnlys = false;
  var villagereadOnlys = false;
  var listDistricts = [];
  var listComunes = [];
  var listVillages = [];
  double heightWidthContant = 25;

  var _onSelectVillageDisplay;
  @override
  Widget build(BuildContext context) {
    final testData = [
      "ពុំទាន់មានទិន្នន័យ",
      "បានកំណត់តំបន់សំរាប់ធ្វើការវាស់វែង",
      "បានវាស់វែង និង ចែកបង្កាន់ដៃវាស់វែង​",
      "បានចែកវិញ្ញាបនបត្រសម្គាល់អចលនវត្ថុ"
    ];
    return Consumer<LmapProvider>(builder: (context, myModel, child) {
      return WillPopScope(
          onWillPop: null,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.translate('lmap_data') ??
                    'LMAP Data',
              ),
              backgroundColor: logolightGreen,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        children: [
                          DropDownLmapRegister(
                            elevation: 0,
                            icons: null,
                            validate: validateVillage
                                ? RoundedRectangleBorder(
                                    side:
                                        BorderSide(color: Colors.red, width: 1),
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
                                      baseURLInternal + 'addresses/province'),
                                  headers: {
                                    "Content-Type": "application/json",
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
                                items: List.generate(
                                    list.length, (index) => "${list[index]}"),
                                onChange: (value) async {
                                  if (mounted) {
                                    FocusScope.of(context)
                                        .unfocus(disposition: disposition);
                                    setState(() {
                                      selectedValueProvince = value;
                                      selectedValueDistrict = "ស្រុក/ខណ្ឌ";
                                      selectedValueCommune = "ឃុំ/សងា្កត់";
                                      _onSelectVillageDisplay = "ភូមិ";
                                      selectedValueVillage = null;
                                      districtreadOnlys = true;
                                    });
                                    myModel.clearLmap();
                                  }
                                },
                              );
                            },
                            selectedValue: selectedValueProvince,
                            texts: selectedValueProvince != null
                                ? selectedValueProvince
                                : "ខេត្ត/ក្រុង",
                            title: selectedValueProvince != null
                                ? selectedValueProvince
                                : "ខេត្ត/ក្រុង",
                            clear: true,
                            readOnlys: true,
                            iconsClose: Icon(Icons.close),
                            onPressed: () {
                              if (mounted) {
                                FocusScope.of(context)
                                    .unfocus(disposition: disposition);
                                setState(() {
                                  selectedValueProvince = "ខេត្ត/ក្រុង";
                                  selectedValueDistrict = "ស្រុក/ខណ្ឌ";
                                  selectedValueCommune = "ឃុំ/សងា្កត់";
                                  _onSelectVillageDisplay = "ភូមិ";
                                  selectedValueVillage = null;
                                  districtreadOnlys = false;
                                  communereadOnlys = false;
                                  villagereadOnlys = false;
                                  myModel.clearLmap();
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
                          DropDownLmapRegister(
                            icons: Icons.location_on,
                            selectedValue: selectedValueDistrict,
                            validate: validateVillage
                                ? RoundedRectangleBorder(
                                    side:
                                        BorderSide(color: Colors.red, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )
                                : null,
                            texts: selectedValueDistrict != null
                                ? selectedValueDistrict
                                : "ស្រុក/ខណ្ឌ",
                            title: selectedValueDistrict != null
                                ? selectedValueDistrict
                                : "ស្រុក/ខណ្ឌ",
                            clear: true,
                            iconsClose: Icon(Icons.close),
                            onInSidePress: () async {
                              if (mounted) {
                                FocusScope.of(context)
                                    .unfocus(disposition: disposition);
                                if (districtreadOnlys == true) {
                                  await getDistrict(selectedValueProvince);
                                  await SelectDialog.showModal<String>(
                                    context,
                                    label: AppLocalizations.of(context)!
                                            .translate('search') ??
                                        'Search',
                                    items: List.generate(listDistricts.length,
                                        (index) => "${listDistricts[index]}"),
                                    onChange: (value) {
                                      setState(() {
                                        selectedValueDistrict = value;
                                        selectedValueCommune = "ឃុំ/សងា្កត់";
                                        _onSelectVillageDisplay = "ភូមិ";
                                        communereadOnlys = true;
                                      });
                                      myModel.clearLmap();
                                    },
                                  );
                                }
                              }
                            },
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  selectedValueDistrict = "ស្រុក/ខណ្ឌ";
                                  selectedValueCommune = "ឃុំ/សងា្កត់";
                                  _onSelectVillageDisplay = "ភូមិ";
                                  selectedValueVillage = null;
                                  villagereadOnlys = false;
                                  communereadOnlys = false;
                                  myModel.clearLmap();
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
                        ],
                      ),
                      Row(
                        children: [
                          DropDownLmapRegister(
                            icons: Icons.location_on,
                            selectedValue: selectedValueCommune,
                            validate: validateVillage
                                ? RoundedRectangleBorder(
                                    side:
                                        BorderSide(color: Colors.red, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )
                                : null,
                            iconsClose: Icon(Icons.close),
                            onInSidePress: () async {
                              if (mounted) {
                                FocusScope.of(context)
                                    .unfocus(disposition: disposition);
                                if (communereadOnlys == true) {
                                  await getCommune(selectedValueDistrict);
                                  await SelectDialog.showModal<String>(
                                    context,
                                    label: AppLocalizations.of(context)!
                                            .translate('search') ??
                                        'Search',
                                    items: List.generate(listComunes.length,
                                        (index) => "${listComunes[index]}"),
                                    onChange: (value) async {
                                      setState(() {
                                        selectedValueCommune = value;
                                        _onSelectVillageDisplay = "ភូមិ";
                                        villagereadOnlys = true;
                                      });
                                      myModel.clearLmap();
                                      await getVillage(value);
                                    },
                                  );
                                }
                              }
                            },
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  selectedValueCommune = "ឃុំ/សងា្កត់";
                                  _onSelectVillageDisplay = "ភូមិ";
                                  selectedValueVillage = null;
                                  villagereadOnlys = false;
                                  myModel.clearLmap();
                                });
                              }
                            },
                            texts: selectedValueCommune != null
                                ? selectedValueCommune
                                : "ឃុំ/សងា្កត់",
                            title: selectedValueCommune != null
                                ? selectedValueCommune
                                : "ឃុំ/សងា្កត់",
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
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              width: isIphoneX(context)
                                  ? widthView(context, 0.46)
                                  : widthView(context, 0.47),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  onPressed: () {
                                    if (selectedValueCommune != null &&
                                        selectedValueCommune != "ឃុំ/សងា្កត់")
                                      SelectDialog.showModal<UserModels>(
                                          context,
                                          label: 'Search',
                                          items: List.generate(
                                            listVillages.length as dynamic,
                                            (index) => UserModels(
                                              name:
                                                  "${listVillages[index]['village']}",
                                              id: listVillages[index]
                                                  ['zone_code'],
                                            ),
                                          ), itemBuilder: (BuildContext context,
                                              UserModels item,
                                              bool isSelected) {
                                        return Container(
                                          decoration: !isSelected
                                              ? null
                                              : BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                          child: ListTile(
                                            selected: isSelected,
                                            title: Text(
                                              item.name,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        );
                                      }, onChange: ((selectedItem) {
                                        setState(() {
                                          selectedValueVillage =
                                              selectedItem.id as dynamic;
                                          _onSelectVillageDisplay =
                                              selectedItem.name as dynamic;
                                        });
                                        myModel.clearLmap();
                                      }), autofocus: false);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(),
                                      Container(
                                        width: isIphoneX(context) ? 130 : 110,
                                        child: Center(
                                          child: Text(
                                            "${_onSelectVillageDisplay != null ? _onSelectVillageDisplay : "ភូមិ"}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: fontWeight500),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          color: Colors.blue,
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            setState(() {
                                              selectedValueVillage = null;
                                              _onSelectVillageDisplay = null;
                                              myModel.clearLmap();
                                            });
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.grey,
                                          )),
                                    ],
                                  ))),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: logolightGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.white)),
                          textStyle: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          if (_onSelectVillageDisplay == "ភូមិ") {
                            setState(() {
                              selectedValueVillage = "";
                            });
                          }
                          fetchLamp(
                              "$pageSizes",
                              "$selectedValueProvince",
                              "$selectedValueDistrict",
                              "$selectedValueCommune",
                              "$selectedValueVillage");
                        },
                        child: Container(
                            width: widthView(context, 0.2),
                            height: widthView(context, 0.1),
                            color: logolightGreen,
                            child: Center(
                              child: Text("ស្វែងរក",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            )),
                      ),
                      SizedBox(
                        height: widthView(context, 0.05),
                      ),
                      Container(
                        width: widthView(context, 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text("ដំណាក់កាលស្ថានភាព",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        decoration: TextDecoration.underline,
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              width: widthView(context, 0.6),
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Container(
                                            height: heightWidthContant,
                                            width: heightWidthContant,
                                            child: Center(
                                              child: Text(
                                                "",
                                                style: TextStyle(
                                                  fontSize: fontSizeLg,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                          "ពុំទាន់មានទិន្នន័យ",
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Card(
                                          color: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Container(
                                            height: heightWidthContant,
                                            width: heightWidthContant,
                                            child: Center(
                                              child: Text(
                                                "",
                                                style: TextStyle(
                                                  fontSize: fontSizeLg,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Container(
                                          child: Text(
                                            "បានកំណត់តំបន់សំរាប់ធ្វើការវាស់វែង",
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Card(
                                        color: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Container(
                                          height: heightWidthContant,
                                          width: heightWidthContant,
                                          child: Center(
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                fontSize: fontSizeLg,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 1,
                                      ),
                                      Container(
                                        child: Text(
                                          "បានវាស់វែង និង ចែកបង្កាន់ដៃវាស់វែង",
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Card(
                                          color: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Container(
                                            height: heightWidthContant,
                                            width: heightWidthContant,
                                            child: Center(
                                              child: Text(
                                                "",
                                                style: TextStyle(
                                                  fontSize: fontSizeLg,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Container(
                                          child: Text(
                                            "បានចែកវិញ្ញាបនបត្រសម្គាល់អចលនវត្ថុ",
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      if (myModel.parsed.length == 0) Center(),
                      Expanded(
                        child: ListView.builder(
                            itemCount: myModel.parsed.length,
                            itemBuilder: (context, index) {
                              Color myColor = Colors.red;
                              if (myModel.parsed[index]['status'] ==
                                  'ពុំទាន់មានទិន្នន័យ') {
                                myColor = Colors.white;
                              }
                              if (myModel.parsed[index]['status'] ==
                                  'បានកំណត់តំបន់សំរាប់ធ្វើការវាស់វែង') {
                                myColor = Colors.green;
                              }
                              if (myModel.parsed[index]['status'] ==
                                  'បានវាស់វែង និង ចែកបង្កាន់ដៃវាស់វែង') {
                                myColor = Colors.yellow;
                              }
                              if (myModel.parsed[index]['status'] ==
                                  'បានចែកវិញ្ញាបនបត្រសម្គាល់អចលនវត្ថុ') {
                                myColor = Colors.red;
                              }
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                      ),
                                      color: logolightGreen,
                                      elevation: 0,
                                      margin: EdgeInsets.all(0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            // color: logolightGreen,
                                            // width: widthView(context, 0.60),
                                            child: Center(
                                                child: Text(
                                              "ស្ថានភាព",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: fontWeight700),
                                            )),
                                          ),
                                          Container(
                                            // color: logolightGreen,
                                            // width: widthView(context, 0.352),
                                            child: Center(
                                              child: Text(
                                                "ការបរិច្ឆេទចែកប្លង់",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: fontWeight700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            // height: 50,
                                            // width: widthView(context, 0.60),
                                            child: Container(
                                          child: Row(
                                            children: [
                                              Card(
                                                color: myColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Container(
                                                  height: heightWidthContant,
                                                  width: heightWidthContant,
                                                  child: Center(
                                                    child: Text(
                                                      " ",
                                                      style: TextStyle(
                                                        fontSize: fontSizeLg,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                  child: Text(
                                                "    ${myModel.parsed[index]['status']}",
                                              )),
                                            ],
                                          ),
                                        )),
                                        Container(
                                            height: 50,
                                            width: widthView(context, 0.2),
                                            child: Center(
                                                child: Text(
                                              myModel.parsed[index]['dates'] !=
                                                      ""
                                                  ? myModel.parsed[index]
                                                      ['dates']
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ))),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            bottom: isIphoneX(context) ? 20 : 0),
                        child: Text(
                          "កាលបរិច្ឆេទទិន្នន័យ៖ $currentDate​",
                        ),
                      )
                    ],
                  ),
          ));
    });
  }
}

class UserModels {
  final String id;
  final String name;
  final String? avatar;
  final DateTime? createdAt;

  UserModels(
      {required this.id, required this.name, this.avatar, this.createdAt});

  factory UserModels.fromJson(Map<String, dynamic> json) {
    return UserModels(
      id: json["zone_code"],
      name: json["village"],
    );
  }

  static List<UserModels>? fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => UserModels.fromJson(item)).toList();
  }
}
