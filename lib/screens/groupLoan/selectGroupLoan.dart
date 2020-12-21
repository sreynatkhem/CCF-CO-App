import 'dart:convert';

import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_select/smart_select.dart';

class GroupLoanSelect extends StatefulWidget {
  var groupName;
  GroupLoanSelect({this.groupName});
  @override
  _GroupLoanSelectState createState() =>
      _GroupLoanSelectState(groupNameParam: this.groupName);
}

class _GroupLoanSelectState extends State<GroupLoanSelect> {
  var groupNameParam;
  _GroupLoanSelectState({this.groupNameParam});

  // snack bar
  void showInSnackBar(String value, colorsBackground) {
    _scaffoldKeySelectedGroupLoan.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: colorsBackground,
    ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKeySelectedGroupLoan =
      new GlobalKey<ScaffoldState>();

  //
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (mounted) {
      getListLoan(20, 1, '', '', '', '', '');
    }
    super.didChangeDependencies();
  }

  var _isLoading = false;
  var listGroupLoan = [];
  List<S2Choice> newDataList = [];
  var items = List<String>();
  //
  getListLoan(_pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    final storage = new FlutterSecureStorage();
    setState(() {
      _isLoading = true;
    });
    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var level = await storage.read(key: "level");
      var bodyRow;
      var sdates = sdate != null ? sdate : '';
      var edates = edate != null ? edate : '';
      var codes = code != null ? code : '';
      var statuses = status != null ? status : '';
      var btlcode = status != null ? status : '';
      var bcodes;
      var ucode;
      if (level == '3') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        btlcode = '';
        ucode = codes != null && codes != "" ? codes : "";
      }

      if (level == '2') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        btlcode = user_ucode;
        ucode = code != null && code != "" ? code : '';
      }

      if (level == '1') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        ucode = user_ucode;
        btlcode = '';
      }

      if (level == '4' || level == '5' || level == '6') {
        bcodes = bcode != null && bcode != "" ? bcode : '';
        btlcode = '';
        ucode = code != null && code != "" ? code : '';
      }
      bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"btlcode\": \"$btlcode\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api().post(baseURLInternal + 'loanRequests/all',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        setState(() {
          _isLoading = false;
          listGroupLoan = listLoan[0]['listLoanRequests'];
          List<S2Choice> frameworks = [
            S2Choice<int>(value: 1, title: 'Ionic'),
            S2Choice<int>(value: 2, title: 'Flutter'),
            S2Choice<int>(value: 3, title: 'React Native'),
          ];
          for (var values in listGroupLoan) {
            setState(() {
              newDataList.add(S2Choice<int>(
                value: int.parse(values['rcode']),
                title:
                    "${values['rcode']} - ${values['loan']['customer']} - ${values['loan']['currency']} ${numFormat.format(values['loan']['lamt'])} ",
              ));
            });
          }
        });
      } else {
        setState(() {
          listGroupLoan = [];
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final TextEditingController controllerSearch = TextEditingController();

  //

  onItemChanged(String value) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(items);

    if (controllerSearch.text == '') {
      setState(() {
        items = [];
        // items = List.from(items);
      });
    }
    if (controllerSearch.text != "") {
      List<String> dummyListData = List<String>();
      items.forEach((item) {
        if (item.toLowerCase().contains(value.toLowerCase())) {
          items = [];
          items.add(item);
        }
      });
      setState(() {
        items = [];
        items.addAll(dummyListData);
      });
      return;
    }
    // else {
    //   setState(() {
    //     items = [];
    //     items.addAll(dummySearchList);
    //   });
    // }
  }

  int selectedRadio;

  @override
  void initState() {
    super.initState();
  }

  List<int> value = [2];

  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Header(
      keys: _scaffoldKeySelectedGroupLoan,
      headerTexts: groupNameParam,
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      bodys: Container(
        child: SmartSelect.multiple(
          title: 'Create Group Loan',
          value: newDataList,
          choiceItems: newDataList,
          choiceType: S2ChoiceType.checkboxes,
          choiceGroupBuilder: (context, header, choices) {},
          modalFilter: true,
          onChange: (v) => logger().e("v: ${v}"),
          modalHeader: true,
          modalHeaderStyle: S2ModalHeaderStyle(
              actionsIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: logolightGreen,
              textStyle: TextStyle(color: Colors.white)),
          modalFilterAuto: true,
          choiceConfig: const S2ChoiceConfig(
            useDivider: true,
          ),
          modalType: S2ModalType.fullPage,
          tileBuilder: (context, state) {
            return S2Tile.fromState(
              state,
              // isLoading: _usersIsLoading,
              hideValue: true,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(state.value?.length?.toString() ?? '0',
                    style: TextStyle(color: Colors.white)),
              ),
              body: S2TileChips(
                chipLength: state.valueObject.length,
                chipLabelBuilder: (context, i) {
                  return Text(state.valueObject[i].title);
                },
                // chipAvatarBuilder: (context, i) => CircleAvatar(
                //     backgroundImage: NetworkImage(
                //         state.valueObject[i].meta['picture']['thumbnail'])),
                // chipOnDelete: (i) {
                //   setState(
                //       () => newDataList.remove(state.valueObject[i].value));
                // },
                chipColor: logolightGreen,
                placeholder: Container(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Animal {
  final int id;
  final String name;

  Animal({
    this.id,
    this.name,
  });
}
