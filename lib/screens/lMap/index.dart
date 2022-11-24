import 'dart:convert';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/lmapProvider/index.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
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
    var date = new DateTime(now.year, now.month, now.day).toString();
    currentDate = getDDMMYY(date);
  }

  var pageSizes = "10";
  bool isLoading = false;
  fetchLamp(
    pageSize,
    province,
    district,
    commune,
    village,
  ) {
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

  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        ModalRoute.withName("/Home"));
    return false;
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
          "Authorization": "Bearer " + token
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

  getCommune(listDistrict) async {
    listDistrict.forEach((item) async {
      if (selectedValueDistrict == item['disdes']) {
        setState(() {
          idDistrict = item['discode'];
        });
      }
    });

    try {
      var request = await http.Request(
          'GET', Uri.parse(baseURLInternal + 'addresses/communes/$idDistrict'));

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
          "Authorization": "Bearer " + token
        },
      );
      final parsed = jsonDecode(response.body);
      setState(() {
        listVillages = parsed;
      });
      // await response.close();
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
  var selectedValueVillage;

  var districtreadOnlys = false;
  var communereadOnlys = false;
  var villagereadOnlys = false;
  var listDistricts = [];
  var listComunes = [];
  var listVillages = [];

  @override
  Widget build(BuildContext context) {
    final testData = [
      "ពុំទាន់មានទិន្នន័យ",
      "បានកំណត់តំបន់សំរាប់ធ្វើការវាស់វែង",
      "បានវាស់វែង និង ចែកបង្កាន់ដៃវាស់វែង​",
      "បានចែកវិញ្ញាបនបត្រសម្គាល់អចលនវត្ថុ"
    ];
    return Consumer<LmapProvider>(
        //                    <--- Consumer
        builder: (context, myModel, child) {
      return WillPopScope(
          onWillPop: null,
          child: Scaffold(
            appBar: AppBar(
              title: Text("LMAP Data"),
              backgroundColor: logolightGreen,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              // actions: [
              //   Builder(
              //     builder: (context) => IconButton(
              //       icon: Icon(Icons.filter_list),
              //       onPressed: () => Scaffold.of(context).openEndDrawer(),
              //       tooltip:
              //           MaterialLocalizations.of(context).openAppDrawerTooltip,
              //     ),
              //   ),
              // ],
            ),
            body: isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      baseURLInternal + 'addresses/provinces'),
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
                                      selectedValueDistrict = "ស្រុក/ខណ្ឌ";
                                      selectedValueCommune = "ឃុំ/សងា្កត់";
                                      selectedValueVillage = "ភូមិ";
                                      districtreadOnlys = true;
                                    });
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
                                  selectedValueVillage = "ភូមិ";
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
                                  selectedValueDistrict = "ស្រុក/ខណ្ឌ";
                                  selectedValueCommune = "ឃុំ/សងា្កត់";
                                  selectedValueVillage = "ភូមិ";
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
                                  await getCommune(listDistricts);
                                  await SelectDialog.showModal<String>(
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
                                  selectedValueCommune = "ឃុំ/សងា្កត់";
                                  selectedValueVillage = "ភូមិ";
                                  villagereadOnlys = false;
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
                          DropDownLmapRegister(
                            icons: null,
                            selectedValue: selectedValueVillage,
                            validate: validateVillage
                                ? RoundedRectangleBorder(
                                    side:
                                        BorderSide(color: Colors.red, width: 1),
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
                                      if (selectedValueVillage ==
                                          item['vildes']) {
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
                                  selectedValueVillage = "ភូមិ";
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
                                : "ភូមិ",
                            title: selectedValueVillage != null
                                ? selectedValueVillage
                                : "ភូមិ",
                            readOnlys: villagereadOnlys,
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 0.2),
                          ),
                          textStyle: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
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
                            child: Center(
                              child: Text("ស្វែងរក",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                            )),
                      ),
                      SizedBox(
                        height: widthView(context, 0.05),
                      ),
                      Container(
                        width: widthView(context, 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: widthView(context, 1),
                              margin: EdgeInsets.only(right: 38),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
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
                              margin: EdgeInsets.only(right: 97),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("• ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      )),
                                  Text(
                                    "ពុំទាន់មានទិន្នន័យ",
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("• ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      )),
                                  Container(
                                    color: Colors.green,
                                    child: Text(
                                      "បានកំណត់តំបន់សំរាប់ធ្វើការវាស់វែង",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("• ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    )),
                                Container(
                                  color: Colors.yellow,
                                  child: Text(
                                    "បានវាស់វែង និង ចែកបង្កាន់ដៃវាស់វែង",
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 7.5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("• ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      )),
                                  Container(
                                    color: Colors.red,
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
                      SizedBox(
                        height: 30,
                      ),
                      if (myModel.parsed.length == 0)
                        Center(
                          child: Text("No Data"),
                        ),
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
                              // DateFormat inputFormat = DateFormat('dd-MM-yyyy');
                              // var convert = myModel.parsed[index]['dates'];
                              // DateTime input = inputFormat.parse(convert);
                              // String datee =
                              //     DateFormat('dd-MM-yyyy').format(input);

                              return Container(
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: logolightGreen,
                                              border: Border(
                                                left: BorderSide(
                                                  //                   <--- left side
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                                top: BorderSide(
                                                  //                   <--- left side
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  //                   <--- left side
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  //                   <--- left side
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                              )),
                                          width: widthView(context, 0.65),
                                          child: Center(
                                              child: Text(
                                            "ស្ថានភាព",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        ),
                                        Container(
                                          width: widthView(context, 0.3),
                                          decoration: BoxDecoration(
                                              color: logolightGreen,
                                              border: Border(
                                                bottom: BorderSide(
                                                  //                   <--- left side
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  //                   <--- left side
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                                top: BorderSide(
                                                  //                   <--- left side
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                              )),
                                          child: Center(
                                            child: Text(
                                              "ការបរិច្ឆេទចែកប្លង់",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: Border(
                                              left: BorderSide(
                                                //                   <--- left side
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                              bottom: BorderSide(
                                                //                    <--- top side
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                              right: BorderSide(
                                                //                    <--- top side
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                            )),
                                            width: widthView(context, 0.65),
                                            child: Container(
                                              color: myColor,
                                              child: Center(
                                                  child: Text(
                                                "${myModel.parsed[index]['status']}",
                                              )),
                                            )),
                                        Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: Border(
                                              bottom: BorderSide(
                                                //                    <--- top side
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                              right: BorderSide(
                                                //                    <--- top side
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                            )),
                                            width: widthView(context, 0.3),
                                            child: Center(
                                                child: Text(
                                                    myModel.parsed[index]
                                                                ['dates'] !=
                                                            ""
                                                        ? myModel.parsed[index]
                                                            ['dates']
                                                        : ""))),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Container(
                        child: Text(
                          "កាលបរិច្ឆេទទិន្នន័យ៖ $currentDate​",
                        ),
                      )
                    ],
                  ),
            // floatingActionButton: SizedBox(
            //   height: 40,
            //   child: FloatingActionButton.extended(
            //     label: Text('Refresh'),
            //     icon: Icon(Icons.refresh, size: 25),
            //     backgroundColor: logolightGreen,
            //     onPressed: () {
            //       setState(() {
            //         selectedValueProvince = "ខេត្ត/ក្រុង";
            //         selectedValueDistrict = "ស្រុក/ខណ្ឌ";
            //         selectedValueCommune = "ឃុំ/សងា្កត់";
            //         selectedValueVillage = "ភូមិ";
            //         districtreadOnlys = false;
            //         communereadOnlys = false;
            //         villagereadOnlys = false;
            //       });
            //       fetchLamp(
            //         "$pageSizes",
            //         "",
            //         "",
            //         "",
            //         "",
            //       );
            //     },
            //   ),
            // ),
          ));
    });
  }
}
