import 'dart:convert';

import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_select/smart_select.dart';

import 'formCreateGroupName.dart';

class GroupLoan extends StatefulWidget {
  @override
  _GroupLoanState createState() => _GroupLoanState();
}

class _GroupLoanState extends State<GroupLoan> {
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> createGroupLoanDefaultKey =
      GlobalKey<FormBuilderState>();
  final TextEditingController createGroupLoanDefaultController =
      TextEditingController();
  //
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  //
  var _createNameValue;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (mounted) {
      getListLoan(20, 1, '', '', '', '', '');
    }
    super.didChangeDependencies();
  }

  List<S2Choice> newDataList = [];
  var _isLoading = false;
  var listGroupLoan = [];

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

  var _selectedMember = [];
  var _selectedLeader = [];

  int maxSelectedCards = 7;
  int currentSelectedCards = 0;

  //
  final GlobalKey<ScaffoldState> _scaffoldKeyGroupLoan =
      new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value, colorsBackground) {
    _scaffoldKeyGroupLoan.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: colorsBackground,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      keys: _scaffoldKeyGroupLoan,
      headerTexts: "create_group_loan",
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            ModalRoute.withName("/Home")),
      ),
      bodys: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: FormGroupFromBuilder(
                        elevations: 2.0,
                        icons: Icons.group_add,
                        keys: createGroupLoanDefaultKey,
                        childs: FormBuilderTextField(
                          attribute: "createGroupLoanDefault",
                          textInputAction: TextInputAction.next,
                          controller: createGroupLoanDefaultController,
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('create_group_name') ??
                                "Create a group name",
                            border: InputBorder.none,
                          ),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          keyboardType: TextInputType.text,
                          onChanged: (v) {
                            setState(() {
                              _createNameValue = v;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: SmartSelect.multiple(
                          title: AppLocalizations.of(context)
                              .translate('select_member'),
                          value: newDataList,
                          choiceItems: newDataList,
                          choiceType: S2ChoiceType.checkboxes,
                          modalFilter: true,
                          modalFilterAuto: true,
                          onChange: (stateMember) => setState(
                              () => _selectedMember = stateMember.valueTitle),
                          modalHeaderStyle: S2ModalHeaderStyle(
                              actionsIconTheme:
                                  IconThemeData(color: Colors.white),
                              iconTheme: IconThemeData(color: Colors.white),
                              backgroundColor: logolightGreen,
                              textStyle: TextStyle(color: Colors.white)),
                          choiceConfig: const S2ChoiceConfig(
                            useDivider: true,
                          ),
                          modalType: S2ModalType.fullPage,
                          modalDividerBuilder: (context, state) {
                            return const Divider(height: 1);
                          },
                          tileBuilder: (context, stateMember) {
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 15,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                                child: S2Tile.fromState(
                                  stateMember,
                                  isLoading: _isLoading,
                                  hideValue: true,
                                  leading: CircleAvatar(
                                    backgroundColor: logolightGreen,
                                    child: Text('5',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  body: S2TileChips(
                                    chipLength: stateMember.valueObject.length,
                                    chipLabelBuilder: (context, i) {
                                      logger().e(
                                          "stateMember: ${stateMember.value}");
                                      return Text(
                                          stateMember.valueObject[i].title);
                                    },
                                    chipColor: logolightGreen,
                                  ),
                                ),
                              ),
                            );
                          },
                          modalFooterBuilder: (context, stateMember) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 7.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  const Spacer(),
                                  FlatButton(
                                    color: Colors.red,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('cancel'),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () => stateMember.closeModal(
                                        confirmed: false),
                                  ),
                                  const SizedBox(width: 5),
                                  FlatButton(
                                    child: Text(AppLocalizations.of(context)
                                        .translate('okay')),
                                    color: logolightGreen,
                                    textColor: Colors.white,
                                    onPressed: stateMember.changes.valid
                                        ? () => stateMember.closeModal(
                                            confirmed: true)
                                        : null,
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    //select leader
                    Container(
                      child: SmartSelect.multiple(
                          title: AppLocalizations.of(context)
                              .translate('select_leader'),
                          value: newDataList,
                          choiceItems: newDataList,
                          // choiceType: S2ChoiceType.checkboxes,
                          modalFilter: true,
                          modalFilterAuto: true,
                          onChange: (stateLeader) => setState(
                              () => _selectedLeader = stateLeader.valueTitle),
                          modalHeaderStyle: S2ModalHeaderStyle(
                              actionsIconTheme:
                                  IconThemeData(color: Colors.white),
                              iconTheme: IconThemeData(color: Colors.white),
                              backgroundColor: logolightGreen,
                              textStyle: TextStyle(color: Colors.white)),
                          choiceConfig: const S2ChoiceConfig(
                            useDivider: true,
                          ),
                          modalType: S2ModalType.fullPage,
                          modalDividerBuilder: (context, state) {
                            return const Divider(height: 1);
                          },
                          tileBuilder: (context, stateLeader) {
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 15,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                                child: S2Tile.fromState(
                                  stateLeader,
                                  isLoading: _isLoading,
                                  hideValue: true,
                                  leading: CircleAvatar(
                                    backgroundColor: logolightGreen,
                                    child: Text('1',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  body: S2TileChips(
                                    chipLength: stateLeader.valueObject.length,
                                    chipLabelBuilder: (context, i) {
                                      return Text(
                                          stateLeader.valueObject[i].title);
                                    },
                                    chipColor: logolightGreen,
                                  ),
                                ),
                              ),
                            );
                          },
                          modalFooterBuilder: (context, stateLeader) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 7.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  const Spacer(),
                                  FlatButton(
                                      color: Colors.red,
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('cancel'),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        stateLeader.closeModal(
                                            confirmed: false);
                                        FocusScope.of(context)
                                            .unfocus(disposition: disposition);
                                      }),
                                  const SizedBox(width: 5),
                                  FlatButton(
                                    child: Text(AppLocalizations.of(context)
                                        .translate('okay')),
                                    color: logolightGreen,
                                    textColor: Colors.white,
                                    onPressed: stateLeader.changes.valid
                                        ? () {
                                            FocusScope.of(context).unfocus(
                                                disposition: disposition);
                                            stateLeader.closeModal(
                                                confirmed: true);
                                          }
                                        : null,
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    //bottom submit
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          RaisedButton(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: logolightGreen, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: logolightGreen,
                            onPressed: () {
                              if (createGroupLoanDefaultController.text == '') {
                                showInSnackBar(
                                    AppLocalizations.of(context).translate(
                                            'please_input_group_name') ??
                                        'Please input group name!',
                                    Colors.red);
                              }
                              if (_selectedMember.length != 0 &&
                                  _selectedMember.length > 5 &&
                                  _selectedMember.length <= 2) {
                                showInSnackBar(
                                    AppLocalizations.of(context).translate(
                                            'member_group_loan_limit_5') ??
                                        'Member group loan limit 5 only or more then 2',
                                    Colors.red);
                              }
                              if (_selectedMember.length == 0) {
                                showInSnackBar(
                                    AppLocalizations.of(context).translate(
                                            'please_select_team_member') ??
                                        'Please select team member',
                                    Colors.red);
                              }
                              if (_selectedLeader.length > 1) {
                                showInSnackBar(
                                    AppLocalizations.of(context).translate(
                                            'team_leader_limit_1_only') ??
                                        'Team leader limit 1 only',
                                    Colors.red);
                              }
                              if (_selectedLeader.length == 0) {
                                showInSnackBar(
                                    AppLocalizations.of(context).translate(
                                            'please_select_team_leader') ??
                                        'Please select team leader',
                                    Colors.red);
                              }
                              if (_selectedLeader.length == 1 &&
                                  _selectedMember.length >= 5 &&
                                  createGroupLoanDefaultController.text != "") {
                                showInSnackBar(
                                    AppLocalizations.of(context)
                                            .translate('successfully') ??
                                        'Successfully',
                                    Colors.red);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.width * 0.11,
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        AppLocalizations.of(context)
                                                .translate("submit") ??
                                            "Submit",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
