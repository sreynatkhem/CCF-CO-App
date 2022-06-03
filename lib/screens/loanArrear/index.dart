import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:chokchey_finance/components/searchCO.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/providers/loanArrearProvider/loanArrearProvider.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/screens/listLoanApproval/indexs.dart';
import 'package:chokchey_finance/screens/loanArrear/detail.dart';
import 'package:chokchey_finance/screens/loanArrear/widgetView.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:platform/platform.dart';
import 'package:provider/provider.dart';
import '../../providers/manageService.dart';
import 'package:http/http.dart' as http;

class LoanArrearScreen extends StatefulWidget {
  const LoanArrearScreen({Key? key}) : super(key: key);

  @override
  _LoanArrearScreenState createState() => _LoanArrearScreenState();
}

class _LoanArrearScreenState extends State<LoanArrearScreen> {
  @override
  void initState() {
    // TODO: implement initState

    if (mounted) {
      fetchLoanArrear()
          .then((value) => {
                setState(() {
                  _isLoading = false;
                })
              })
          .catchError((onError) {
        setState(() {
          _isLoading = false;
        });
      });
      getListBranches();
    }
    searchAllCO("");
    super.initState();
  }

  var listBranch = [];
  var selected = [];
  var listHistory;
  String? selectedStatus;
  String? selectedBranch;
  String? startDateTime = "";
  String? endDateTime = "";
  String coName = "";
  String bcode = "";
  dynamic listLoanArrear = [];
  bool _isLoading = false;
  dynamic overviewmonth = 0.0;
  dynamic currencyUSD = 0.0;
  dynamic currencyKhmer = 0.0;
  var format = NumberFormat.simpleCurrency(name: 'KHM');

  Future fetchLoanArrear() async {
    // branch
    String branch = await storage.read(key: 'branch');
    String level = await storage.read(key: 'level');
    String user_ucode = await storage.read(key: 'user_ucode');

    setState(() {
      _isLoading = true;
    });
    var datetime = DateTime.now();
    String getDateTimeNow = DateFormat("yyyyMMdd").format(datetime);

    String mgmtBranchCode = "";
    String referenEmployeeNo = "";

    if (branch != "0100") {
      mgmtBranchCode = branch;
    }

    if (level == '3') {
      mgmtBranchCode = branch;
    }
    if (level == '1') {
      mgmtBranchCode = branch;
      referenEmployeeNo = user_ucode;
    }

    if (bcode != "") {
      mgmtBranchCode = bcode;
    }

    if (selectedEmployeeID != "") {
      referenEmployeeNo = selectedEmployeeID;
    }

    logger().e("mgmtBranchCode: $mgmtBranchCode");
    logger().e("referenEmployeeNo: $referenEmployeeNo");

    await Provider.of<LoanArrearProvider>(context, listen: false)
        .fetchLoanArrearProvider(
      baseDate: getDateTimeNow,
      currencyCode: "",
      loanAccountNo: "",
      mgmtBranchCode: mgmtBranchCode,
      referenEmployeeNo: referenEmployeeNo,
    )
        .then((value) {
      var totalAcount = {"totalAcount": "${value.length}"};
      value.forEach((dynamic e) {
        if (e['currencyCode'] == "USD") {
          currencyUSD += e['totalAmount1'];
        } else {
          currencyKhmer += e['totalAmount1'];
        }
      });
      setState(() {
        value = [totalAcount, ...value];
        listLoanArrear = value;
        _isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  _onClickListBranch(v) {
    setState(() {
      bcode = v['bcode'];
    });
  }

  Future getListBranches() async {
    await ApprovalHistoryProvider()
        .getListBranch()
        .then((value) => {
              setState(() {
                listBranch = value;
              }),
            })
        .catchError((onError) {});
  }

  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        ModalRoute.withName("/Home"));
    return false;
  }

  List<ArbitrarySuggestionType> suggestions = [];
  TextEditingController searchByCOController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> keySearchController = GlobalKey();
  GlobalKey<FormState> keySearchCo = GlobalKey();

  onFilter() async {
    fetchLoanArrear();
    Navigator.pop(context);
  }

  dynamic listCO = [];
  Future<List<UserModel>?> searchAllCO(searchusername) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse(baseURLInternal + 'Users/search'));
      request.body = json.encode({
        "pageSize": 20,
        "pageNumber": 1,
        "searchusername": "$searchusername"
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var parsed = jsonDecode(await response.stream.bytesToString());
        setState(() {
          _isLoading = false;
          listCO = parsed;
        });
        return UserModel.fromJsonList(parsed);
      } else {
        setState(() {
          _isLoading = false;
        });
        print(response.reasonPhrase);
      }
    } catch (Error) {
      setState(() {
        _isLoading = false;
      });
      logger().e(Error);
    }
  }

  String selectedEmployeeID = "";

  TextEditingController searchControllerTextFormField = TextEditingController();
  GlobalKey<FormState> searchTextFormFieldKey = GlobalKey<FormState>();
  final _userEditTextController = TextEditingController();
  bool leaveTypeIdColor = false;

  Widget _customPopupItemBuilderExample(
      BuildContext context, UserModel? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(3),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item!.name),
        subtitle: Text(item.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Loan Arrear"),
          backgroundColor: logolightGreen,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: listLoanArrear.length,
                itemBuilder: (context, index) {
                  dynamic sumItem = listLoanArrear[index];
                  if (index == 0) {
                    return Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: searchController,
                            key: keySearchController,
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: logolightGreen),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: logolightGreen),
                              ),
                              labelText: "Search Loan Arrear",
                              hintText: "Search Loan Arrear",
                              labelStyle:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              hintStyle:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: logolightGreen,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                // margin: EdgeInsets.only(top: 20),
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  elevation: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Total Account",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.numbers,
                                                    size: 20,
                                                    color: Colors.red),
                                                Text(
                                                    "${sumItem['totalAcount']}",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.red)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          //total overview amount loan arrears by USD
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Overdue USD",
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.attach_money,
                                                        size: 25,
                                                        color: Colors.red),
                                                    Text(
                                                        "${currencyUSD.toStringAsFixed(2)}",
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.red)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          //total overview amount loan arrears by Khmer
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text("Overdue KHM",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                          "assets/images/khm.png",
                                                          width: 18,
                                                          color: Colors.red),
                                                      Text(
                                                          "${currencyKhmer.toStringAsFixed(1)}",
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.red)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.all(10),
                      child: Card(
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailLoanArrear(
                                        loanAccountNo: listLoanArrear[index]
                                                ['loanAccountNo']
                                            .toString(),
                                      )),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(padding: EdgeInsets.only(top: 10)),
                              WidgetViewTextLoanArrear(
                                  title: 'Loan Account No : ',
                                  // value: listLoanArrear[index]['loanAccountNo']
                                  //     .substring(3)),
                                  value: sumItem['totalAmount1'].toString()),
                              WidgetViewTextLoanArrear(
                                  title: 'Customer No : ',
                                  value: listLoanArrear[index]['customerNo']
                                      .substring(5)),
                              WidgetViewTextLoanArrear(
                                  title: "Customer Name : ",
                                  value: listLoanArrear[index]['customerName']),
                              WidgetViewTextLoanArrear(
                                  title: "Phone No : ",
                                  value: listLoanArrear[index]['cellPhoneNo']),
                              WidgetViewTextLoanArrear(
                                  title: "Over Due Days : ",
                                  value: listLoanArrear[index]['overdueDays']
                                      .toString()),
                              WidgetViewTextLoanArrear(
                                  title: "Total Repayment : ",
                                  value: listLoanArrear[index]['totalAmount1']
                                      .toString()),
                              WidgetViewTextLoanArrear(
                                  title: "CO Name : ",
                                  value: listLoanArrear[index]['employeeName']
                                      .toString()),
                              WidgetViewTextLoanArrear(
                                  title: "CO ID : ",
                                  value: listLoanArrear[index]
                                          ['refereneceEmployeeNo']
                                      .toString()),
                              Padding(padding: EdgeInsets.only(bottom: 10))
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
        endDrawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(top: 40)),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort,
                          color: logolightGreen,
                        ),
                        Padding(padding: EdgeInsets.only(right: 5, left: 5)),
                        Text(
                          "Filter",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: logolightGreen),
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: logolightGreen,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            "Search by CO",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: DropdownSearch<UserModel>(
                      searchFieldProps: TextFieldProps(
                        controller: _userEditTextController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: leaveTypeIdColor == true
                                  ? Colors.red
                                  : logolightGreen,
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: leaveTypeIdColor == true
                                    ? Colors.red
                                    : logolightGreen,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Search Employee Name *",
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 14),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                            borderSide: BorderSide(),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: logolightGreen,
                          ),
                        ),
                      ),
                      mode: Mode.BOTTOM_SHEET,
                      maxHeight: 700,
                      isFilteredOnline: true,
                      showClearButton: true,
                      showSelectedItems: true,
                      compareFn: (item, selectedItem) => listCO == listCO,
                      showSearchBox: true,
                      dropdownSearchDecoration: InputDecoration(
                        // filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: leaveTypeIdColor == true
                                ? Colors.red
                                : logolightGreen,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: leaveTypeIdColor == true
                                  ? Colors.red
                                  : logolightGreen,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        hintText: "Employee Name *",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(),
                        ),
                        // prefixIcon: Icon(
                        //   Icons.person,
                        //   color: logolightGreen,
                        // ),
                      ),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (u) =>
                          u == null ? "User field is required" : null,
                      // onFind: (String? filter) =>
                      //     searchByCO(filter) as Future<List<UserModel>>,
                      onFind: (String? searchusername) =>
                          searchAllCO(searchusername)
                              as Future<List<UserModel>>,
                      onChanged: (data) {
                        if (data == null) {
                        } else {
                          setState(() {
                            selectedEmployeeID = data.id;
                          });
                        }
                      },
                      onSaved: (e) {
                        if (e == null) {
                        } else {
                          setState(() {
                            selectedEmployeeID = listCO;
                          });
                        }
                      },
                      popupItemBuilder: _customPopupItemBuilderExample,
                      popupSafeArea:
                          PopupSafeAreaProps(top: true, bottom: true),
                      scrollbarProps: ScrollbarProps(
                        isAlwaysShown: true,
                        thickness: 7,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(color: logolightGreen),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(
                            color: Colors.black,
                            height: 50,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Search by filter
                  // Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu,
                          color: logolightGreen,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            "List Branch",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  listBranch != null
                      ? Container(
                          height: 480,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: listBranch != null
                                ? listBranch.length
                                : [].length,
                            padding: EdgeInsets.only(top: 15.0),
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: logolightGreen, width: 1)),
                                child: InkWell(
                                  onTap: () =>
                                      _onClickListBranch(listBranch[index]),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${listBranch[index]['bname']}',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: bcode ==
                                                    listBranch[index]['bcode']
                                                ? logolightGreen
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Padding(padding: EdgeInsets.only(bottom: 1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 120,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: logoDarkBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            bcode = "";
                            fetchLoanArrear();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      Container(
                        width: 120,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: logolightGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            onFilter();
                          },
                          child: Text(
                            "Apply",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
