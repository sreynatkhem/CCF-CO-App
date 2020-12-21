import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';

class IRRScreen extends StatefulWidget {
  @override
  _IRRScreenState createState() => _IRRScreenState();
}

class _IRRScreenState extends State<IRRScreen> {
  var exchangeRate;
  var grossAmount;
  var loanAmountInUSA;
  var onSelectedCurrency;
  var loanTerm;
  var monthlyInterest;
  var monthlyFeeRate;
  var adminFeeRate;
  var irr;
  var income;
  var _isLoading = false;

  final GlobalKey<FormBuilderState> _fbKeyIRR = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _fbKeyShowDefault =
      GlobalKey<FormBuilderState>();

  final TextEditingController exchangeRateController = TextEditingController();
  final TextEditingController grossAmountController = TextEditingController();
  final TextEditingController loanAmountInUSAController =
      TextEditingController();
  final TextEditingController loanTermController = TextEditingController();
  final TextEditingController monthlyInterestController =
      TextEditingController();
  final TextEditingController monthlyFeeRateController =
      TextEditingController();
  final TextEditingController adminFeeRateController = TextEditingController();
  final TextEditingController iRRController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController irrFinalController = TextEditingController();

  //
  final TextEditingController grossAmountDefaultController =
      TextEditingController();
  final TextEditingController iRRDefaultController = TextEditingController();
  final TextEditingController incomeDefaultController = TextEditingController();

// grossDisbursementAmounttGlobalKey
  var numberofTermIRR;
  var monthlyInterestIRR;
  var monthlyFeeIRR;
  var adminFeeIRR;
  var valueIRR;
  var incomeIRR;
  //
  List<int> sumAmount = [];
  List<int> sumIncome = [];
  int parsedIncome;
  int paresAmountNumberDefault;
  // Store Default
  int storeAmount;
  int storeIncome;
  // Store Input
  int storeAmountInput;
  int storeIncomeInput;

  var loanAmountDefaultFocus = FocusNode();
  // var forParseIncome;
  var subSecoundString;
  var inComeInputText;
  var inputArreyIncomeNoFormat;
  iRRCalculation() {
    monthlyInterestIRR = monthlyInterest != null
        ? double.parse(monthlyInterest)
        : double.parse('0.0');

    monthlyFeeIRR = monthlyFeeRate != null
        ? double.parse(monthlyFeeRate)
        : double.parse('0.0');

    adminFeeIRR =
        adminFeeRate != null ? double.parse(adminFeeRate) : double.parse('0.0');

    numberofTermIRR =
        loanTerm != null ? double.parse(loanTerm) : double.parse('0.0');
    //
    var vauleIRRForParse = ((monthlyInterestIRR + monthlyFeeIRR) * 12) +
        ((adminFeeIRR / numberofTermIRR) * 12);
    var grossAmountParse;
    var incomeCalculate;
    if (onSelectedCurrency == null || onSelectedCurrency == "") {
      setState(() {
        onSelectedCurrency = "USD";
      });
    }
    if (onSelectedCurrency.toString() == "USD") {
      incomeCalculate = grossAmount * vauleIRRForParse;
    } else if (onSelectedCurrency.toString() == "KHR") {
      incomeCalculate = grossAmount * vauleIRRForParse;
    }
    inputArreyIncomeNoFormat = (incomeCalculate / 100).toInt();
    inComeInputText = numFormat.format(inputArreyIncomeNoFormat);
    setState(() {
      valueIRR = ((monthlyInterestIRR + monthlyFeeIRR) * 12) +
          ((adminFeeIRR / numberofTermIRR) * 12);
      income = inComeInputText;
      storeIncomeInput = inputArreyIncomeNoFormat;
      iRRController.text = ((monthlyInterestIRR + monthlyFeeIRR) * 12) +
          ((adminFeeIRR / numberofTermIRR) * 12).toString();
    });
  }

  int finalSumAmount;
  int finalSumIncome;
  var finalSumIRR;

  sumFinalIRR() {
    int sum = sumAmount.reduce((sumSoFar, currentInt) {
      return sumSoFar + currentInt;
    });
    setState(() {
      finalSumAmount = sum;
    });
    logger().e("sumAmount : ${sumAmount}");
    logger().e("sum : ${sum}");
  }

  sumFinalIncome() {
    int sum = sumIncome.reduce((sumSoFar, currentInt) {
      return sumSoFar + currentInt;
    });
    setState(() {
      finalSumIncome = sum;
    });
    logger().e("sumIncome : ${sumIncome}");
    logger().e("sum : ${sum}");
  }

  calculeFinalIRR() {
    setState(() {
      finalSumIRR =
          ((finalSumIncome / finalSumAmount) * 100).toStringAsPrecision(4);
    });
  }

  var _isShowDefault = true;
  var amountDefault;
  var iRRDefault;
  var incomeDefault;

  var data = [];

  var currencyAmountDouble;
  String showValueAmountDefault;
  convertCurrency(amountDocble) {
    if (amountDocble.length > 1) {
      var value = double.parse(amountDocble);
      MoneyFormatterOutput fo = FlutterMoneyFormatter(amount: value).output;
      var test = fo.nonSymbol.toString();
      setState(() {
        showValueAmountDefault = test;
        loanAmountInUSAController.text = test;
      });
    } else {
      setState(() {
        showValueAmountDefault = "";
        loanAmountInUSAController.text = "";
      });
    }
  }

  int calc_ranks(ranks) {}

  UnfocusDisposition disposition = UnfocusDisposition.scope;
  //
  final GlobalKey<ScaffoldState> _scaffoldKeyIRR =
      new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value, colorsBackground) {
    _scaffoldKeyIRR.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: colorsBackground,
    ));
  }

  final GlobalKey<FormBuilderState> monthlyInterestGlobalKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> monthlyAdminFeeGlobalKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> amountDefaultGlobalKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> irrDefaultGlobalKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> currenciesKey =
      GlobalKey<FormBuilderState>();

  final GlobalKey<FormBuilderState> grossDisbursementAmounttGlobalKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> loanaAmountInUSDGlobalKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> loanTermInUSDGlobalKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> monthlyFeeGlobalKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> iRRGlobalKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> inComeGlobalKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> incomeDefaultKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> irrFinalGlobalKey =
      GlobalKey<FormBuilderState>();

  //
  var percentages = const AssetImage('assets/images/percentage.png');

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyIRR,
      appBar: null,
      body: SingleChildScrollView(
        child: Center(
            child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              if (_isShowDefault == true)
                FormBuilder(
                    // context,
                    key: _fbKeyShowDefault,
                    child: Column(children: [
                      SizedBox(height: 5),
                      Container(
                        child: GroupFromBuilder(
                          colors: Colors.grey[300],
                          icons: Icons.check,
                          keys: currenciesKey,
                          childs: Container(
                            child: FormBuilderDropdown(
                                attribute: 'name',
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                          .translate('currencies') ??
                                      "Currencies",
                                  border: InputBorder.none,
                                ),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: AppLocalizations.of(context)
                                              .translate(
                                                  'currencies_required') ??
                                          "Currencies Required(*)"),
                                ],
                                hint: Text(
                                  "USD",
                                ),
                                items: ["USD"]
                                    .map((e) => DropdownMenuItem(
                                          value: e.toString(),
                                          child: Text("${e}"),
                                        ))
                                    .toList()),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        colors: Colors.grey[300],
                        icons: Icons.attach_money,
                        keys: incomeDefaultKey,
                        childs: FormBuilderTextField(
                          readOnly: true,
                          attribute: "incomeDefault",
                          textInputAction: TextInputAction.next,
                          controller: incomeDefaultController,
                          validators: [
                            FormBuilderValidators.numeric(
                                errorText: "requeiure."),
                          ],
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('income') ??
                                "Income",
                            border: InputBorder.none,
                          ),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        icons: Icons.attach_money,
                        keys: amountDefaultGlobalKey,
                        childs: FormBuilderTextField(
                          attribute: 'number',
                          inputFormatters: [
                            // ignore: deprecated_member_use
                            WhitelistingTextInputFormatter(
                                RegExp(r'^(\d+)?\.?\d{0,100}')),
                          ],
                          controller: grossAmountDefaultController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('gross_disbursement_amount') ??
                                "Gross Disbursement Amount",
                            border: InputBorder.none,
                          ),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(loanAmountDefaultFocus);
                          },
                          onChanged: (v) {
                            if (mounted) {
                              dynamic amountDocble = double.parse(v);

                              MoneyFormatterOutput fo =
                                  FlutterMoneyFormatter(amount: amountDocble)
                                      .output;
                              convertCurrency(v);
                              var amountInt = int.parse(v);
                              paresAmountNumberDefault = int.parse(v);
                              storeAmount = amountInt as int;
                              if (mounted)
                                setState(() {
                                  currencyAmountDouble = fo.symbolOnLeft;
                                  amountDefault = v;
                                });
                            }
                          },
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          validators: [
                            FormBuilderValidators.min(1),
                            FormBuilderValidators.required(
                                errorText: AppLocalizations.of(context)
                                        .translate('loan_amount_required') ??
                                    "Loan amount Required(*)"),
                            FormBuilderValidators.numeric(
                                errorText: AppLocalizations.of(context)
                                        .translate('number_only') ??
                                    'Number only')
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        imageIcon: percentages,
                        keys: irrDefaultGlobalKey,
                        childs: FormBuilderTextField(
                          controller: iRRDefaultController,
                          attribute: 'number',
                          focusNode: loanAmountDefaultFocus,
                          decoration: InputDecoration(
                            labelText: 'IRR',
                            border: InputBorder.none,
                          ),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          keyboardType: TextInputType.number,
                          validators: [
                            FormBuilderValidators.required(
                                errorText: AppLocalizations.of(context)
                                        .translate('irr_required') ??
                                    "IRR required(*)"),
                          ],
                          inputFormatters: [
                            // ignore: deprecated_member_use
                            WhitelistingTextInputFormatter(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                          onChanged: (v) {
                            var numberFormat =
                                new NumberFormat("#,###.00", "en_US");

                            if (mounted) {
                              var amount = int.parse(amountDefault);
                              var irrParse = double.parse(v);
                              var subFirstIncome = amount * irrParse;
                              var subSecoundString =
                                  subFirstIncome.toString().substring(0, 4);
                              parsedIncome = int.parse(subSecoundString);
                              var secondIncomeDefault = subFirstIncome / 100;
                              var finalIncome =
                                  numberFormat.format(secondIncomeDefault);
                              setState(() {
                                incomeIRR = finalIncome;
                                incomeDefaultController.text = finalIncome;
                                storeIncome = secondIncomeDefault.round();
                              });
                            }
                          },
                          onFieldSubmitted: (v) {
                            var numberFormat =
                                new NumberFormat("#,###.00", "en_US");

                            if (mounted) {
                              var amount = int.parse(amountDefault);
                              var irrParse = double.parse(v);
                              var subFirstIncome = amount * irrParse;
                              var subSecoundString =
                                  subFirstIncome.toString().substring(0, 4);
                              parsedIncome = int.parse(subSecoundString);
                              var secondIncomeDefault = subFirstIncome / 100;

                              var finalIncome =
                                  numberFormat.format(secondIncomeDefault);
                              setState(() {
                                incomeIRR = finalIncome;
                                incomeDefaultController.text = finalIncome;
                                storeIncome = secondIncomeDefault as int;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(''),
                          RaisedButton(
                            color: logolightGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            child: Container(
                              width: 110,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  Padding(padding: EdgeInsets.all(3)),
                                  Text(
                                    AppLocalizations.of(context)
                                            .translate('add') ??
                                        "Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              if (amountDefault != "" &&
                                  amountDefault != null &&
                                  iRRDefaultController.text != "" &&
                                  incomeDefaultController.text != "") {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (amountDefault != "" &&
                                    incomeIRR != "" &&
                                    incomeDefaultController.text != "") {
                                  var index;
                                  if (data.length > 0) {
                                    for (var item in data) {
                                      setState(() {
                                        index = item['Id'] + 1;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      index = 1;
                                    });
                                  }
                                  var irrDobule =
                                      double.parse(iRRDefaultController.text)
                                          .toStringAsFixed(2);
                                  var listArray = {
                                    "Id": index,
                                    "Currency": "USD",
                                    "Amount": "$showValueAmountDefault",
                                    "IRR": "${irrDobule.toString()}",
                                    "Income": "${incomeDefaultController.text}",
                                  };
                                  data.addAll([listArray]);
                                  sumAmount.addAll([storeAmount]);
                                  sumIncome.addAll([storeIncome]);
                                  logger().e("sumIncome: ${sumIncome}");
                                  setState(() {
                                    _isLoading = false;
                                    _isShowDefault = false;
                                    loanAmountInUSAController.text = "";
                                    amountDefault = "";
                                    incomeIRR = "";
                                    incomeDefault = "";
                                    grossAmountDefaultController.text = "";
                                    iRRDefaultController.text = "";
                                    incomeDefaultController.text = "";
                                    FocusScope.of(context)
                                        .unfocus(disposition: disposition);
                                  });
                                  showInSnackBar(
                                      AppLocalizations.of(context)
                                              .translate('') ??
                                          'Successfully',
                                      logolightGreen);
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                amountDefault = "";
                                incomeIRR = "";
                                incomeDefault = "";
                                //
                                grossAmountDefaultController.text = "";
                                iRRDefaultController.text = "";
                                incomeDefaultController.text = "";
                                FocusScope.of(context)
                                    .unfocus(disposition: disposition);
                              });
                              showInSnackBar(
                                  AppLocalizations.of(context).translate('') ??
                                      'Clear Form Successfully',
                                  logolightGreen);
                            },
                            child: Container(
                              width: 110,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                  Padding(padding: EdgeInsets.all(3)),
                                  Text(
                                      AppLocalizations.of(context)
                                              .translate('clear_form') ??
                                          "Clear Form",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          Text(''),
                        ],
                      ),
                    ])),
              if (_isShowDefault == false)
                Padding(padding: EdgeInsets.only(top: 5)),
              if (_isShowDefault == false)
                GroupFromBuilder(
                  icons: Icons.money_off,
                  keys: irrDefaultGlobalKey,
                  childs: FormBuilderTextField(
                    controller: exchangeRateController,
                    attribute: 'exchange',
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)
                              .translate('exchange_rate') ??
                          'Exchange Rate:',
                      border: InputBorder.none,
                    ),
                    valueTransformer: (text) {
                      return text == null ? null : text;
                    },
                    keyboardType: TextInputType.number,
                    validators: [
                      FormBuilderValidators.required(
                          errorText: AppLocalizations.of(context)
                                  .translate('exchange_rate') ??
                              "Exchange Rate:"),
                    ],
                    inputFormatters: [
                      // ignore: deprecated_member_use
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (mounted)
                        setState(() {
                          exchangeRate = value;
                        });
                    },
                    onFieldSubmitted: (v) {
                      if (mounted)
                        setState(() {
                          exchangeRate = v;
                        });
                    },
                  ),
                ),
              if (_isShowDefault == false) SizedBox(height: 10),
              if (_isShowDefault == false)
                FormBuilder(
                  // context,
                  key: _fbKeyIRR,
                  child: Column(
                    children: [
                      Container(
                        child: GroupFromBuilder(
                          icons: Icons.check,
                          childs: Container(
                            child: FormBuilderDropdown(
                              attribute: 'name',
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                        .translate('currencies') ??
                                    "Currencies",
                                border: InputBorder.none,
                              ),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: AppLocalizations.of(context)
                                            .translate('currencies_required') ??
                                        "Currencies Required(*)"),
                              ],
                              onChanged: (v) {
                                if (mounted) {
                                  setState(() {
                                    onSelectedCurrency = v;
                                    loanAmountInUSAController.text = "";
                                    grossAmountController.text = "";
                                  });
                                }
                                logger().e("currency: ${onSelectedCurrency}");
                              },
                              hint: Text(
                                "USD",
                              ),
                              items: ['USD', 'KHR']
                                  .map((gender) => DropdownMenuItem(
                                      value: gender, child: Text("$gender")))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        icons: Icons.monetization_on_sharp,
                        keys: grossDisbursementAmounttGlobalKey,
                        childs: FormBuilderTextField(
                          controller: grossAmountController,
                          attribute: 'gross_disbursement_amount',
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('gross_disbursement_amount') ??
                                "Gross Disbursement Amount",
                            border: InputBorder.none,
                          ),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          validators: [
                            FormBuilderValidators.required(
                                errorText: AppLocalizations.of(context)
                                        .translate(
                                            'gross_disbursement_amount') ??
                                    "Gross Disbursement Amount"),
                          ],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            // ignore: deprecated_member_use
                            WhitelistingTextInputFormatter(
                                RegExp(r'^(\d+)?\.?\d{0,100}')),
                            // CurrencyInputFormatter(12),
                          ],
                          onChanged: (v) {
                            logger().e("v1: ${v}");

                            logger().e("v: ${onSelectedCurrency}");
                            var ranksDouble = double.parse(v);
                            var ranksRoundUp = ranksDouble.round();
                            var rankInt = int.parse(ranksRoundUp.toString());
                            if (onSelectedCurrency == "KHR") {
                              logger().e("KHR: ${onSelectedCurrency}");
                              var exChangeRateDouble = int.parse(exchangeRate);
                              var ranksKHR = rankInt / exChangeRateDouble;
                              var ranksKHRRound = ranksKHR.round();
                              var rankIntKHR =
                                  int.parse(ranksKHRRound.toString());
                              convertCurrency(v);
                              setState(() {
                                grossAmount = rankInt / exChangeRateDouble;
                                loanAmountInUSAController.text = numFormat
                                    .format(rankInt / exChangeRateDouble)
                                    .toString();
                                storeAmountInput = rankIntKHR;
                              });
                              iRRCalculation();
                            } else {
                              logger().e("USD: ${onSelectedCurrency}");
                              convertCurrency(v);
                              setState(() {
                                loanAmountInUSAController.text =
                                    showValueAmountDefault;
                                grossAmount = rankInt;
                                storeAmountInput = rankInt;
                              });
                              iRRCalculation();
                            }
                          },
                          onFieldSubmitted: (v) {
                            var ranksDouble = double.parse(v);
                            var ranksRoundUp = ranksDouble.round();
                            var rankInt = int.parse(ranksRoundUp.toString());
                            if (onSelectedCurrency == "USD") {
                              logger().e("USD: ${onSelectedCurrency}");

                              convertCurrency(v);
                              setState(() {
                                loanAmountInUSAController.text =
                                    showValueAmountDefault;
                                grossAmount = rankInt;
                                storeAmountInput = rankInt;
                              });
                              iRRCalculation();
                            } else {
                              logger().e("KHR: ${onSelectedCurrency}");

                              var exChangeRateDouble = int.parse(exchangeRate);
                              var ranksKHR = rankInt / exChangeRateDouble;
                              var ranksKHRRound = ranksKHR.round();
                              var rankIntKHR =
                                  int.parse(ranksKHRRound.toString());
                              setState(() {
                                grossAmount = rankInt / exChangeRateDouble;
                                loanAmountInUSAController.text = numFormat
                                    .format(rankInt / exChangeRateDouble)
                                    .toString();
                                storeAmountInput = rankIntKHR;
                              });
                            }
                            iRRCalculation();
                          },
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        colors: Colors.grey[300],
                        icons: Icons.monetization_on_sharp,
                        keys: loanaAmountInUSDGlobalKey,
                        childs: FormBuilderTextField(
                          readOnly: true,
                          controller: loanAmountInUSAController,
                          attribute: 'loana_amount_in_USD',
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('loana_amount_in_USD') ??
                                "Loan Amount in USD",
                            border: InputBorder.none,
                          ),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          validators: [
                            FormBuilderValidators.required(
                                errorText: AppLocalizations.of(context)
                                        .translate('loana_amount_in_USD') ??
                                    "Loan Amount in USD"),
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        icons: Icons.branding_watermark,
                        keys: loanTermInUSDGlobalKey,
                        childs: FormBuilderTextField(
                          controller: loanTermController,
                          attribute: "loan_term",
                          onChanged: (v) {
                            setState(() {
                              loanTerm = v;
                            });
                            iRRCalculation();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('loan_term') ??
                                "Loan Term",
                            border: InputBorder.none,
                          ),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          inputFormatters: [
                            // ignore: deprecated_member_use
                            WhitelistingTextInputFormatter(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                          validators: [
                            FormBuilderValidators.required(
                                errorText: AppLocalizations.of(context)
                                        .translate('loan_term') ??
                                    "Loan Term"),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        imageIcon: percentages,
                        keys: monthlyInterestGlobalKey,
                        childs: FormBuilderTextField(
                          attribute: "monthly_interest",
                          keyboardType: TextInputType.number,
                          controller: monthlyInterestController,
                          inputFormatters: [
                            // ignore: deprecated_member_use
                            WhitelistingTextInputFormatter(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                          onChanged: (v) {
                            if (mounted) {
                              setState(() {
                                monthlyInterest = v;
                              });
                              iRRCalculation();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('monthly_interest') ??
                                "Monthly Interest",
                            border: InputBorder.none,
                          ),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          validators: [
                            FormBuilderValidators.min(0.1),
                            FormBuilderValidators.max(1.5),
                            FormBuilderValidators.required(
                                errorText: AppLocalizations.of(context)
                                        .translate(
                                            'monthly_interest_rate_required') ??
                                    "Monthly interest rate required(*)"),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        imageIcon: percentages,
                        keys: monthlyFeeGlobalKey,
                        childs: FormBuilderTextField(
                          attribute: "monthly_fee_rate",
                          keyboardType: TextInputType.number,
                          controller: monthlyFeeRateController,
                          inputFormatters: [
                            // ignore: deprecated_member_use
                            WhitelistingTextInputFormatter(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                          onChanged: (v) {
                            if (mounted) {
                              setState(() {
                                monthlyFeeRate = v;
                              });
                              iRRCalculation();
                            }
                          },
                          onFieldSubmitted: (v) {
                            if (mounted)
                              setState(() {
                                monthlyFeeRate = v;
                              });
                          },
                          validators: [
                            FormBuilderValidators.max(2),
                            FormBuilderValidators.required(
                                errorText: AppLocalizations.of(context)
                                        .translate('admin_fee_required') ??
                                    "Admin fee required(*)"),
                          ],
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('monthly_fee_rate') ??
                                "Monthly Fee Rate",
                            border: InputBorder.none,
                          ),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        imageIcon: percentages,
                        keys: monthlyAdminFeeGlobalKey,
                        childs: FormBuilderTextField(
                          attribute: "admin_fee_rate",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            // ignore: deprecated_member_use
                            WhitelistingTextInputFormatter(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                          validators: [
                            FormBuilderValidators.max(2),
                            FormBuilderValidators.required(
                                errorText: AppLocalizations.of(context)
                                        .translate('admin_fee_required') ??
                                    "Admin fee required(*)"),
                          ],
                          controller: adminFeeRateController,
                          onChanged: (v) {
                            if (mounted) {
                              setState(() {
                                adminFeeRate = v;
                              });
                              iRRCalculation();
                            }
                          },
                          onFieldSubmitted: (v) {
                            if (mounted)
                              setState(() {
                                adminFeeRate = v;
                              });
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('admin_fee_rate') ??
                                "Admin Fee Rate",
                            border: InputBorder.none,
                          ),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        colors: Colors.grey[300],
                        imageIcon: percentages,
                        keys: iRRGlobalKey,
                        childs: FormBuilderTextField(
                          readOnly: true,
                          controller: iRRController,
                          attribute: 'irr',
                          decoration: InputDecoration(
                              labelText: valueIRR != null && valueIRR != ""
                                  ? valueIRR.toString()
                                  : "IRR",
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                  color: valueIRR != null && valueIRR != ""
                                      ? Colors.black
                                      : Colors.grey)),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          validators: [
                            FormBuilderValidators.required(errorText: "IRR"),
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 5),
                      GroupFromBuilder(
                        colors: Colors.grey[300],
                        imageIcon: percentages,
                        keys: inComeGlobalKey,
                        childs: FormBuilderTextField(
                          readOnly: true,
                          controller: incomeController,
                          attribute: 'income',
                          decoration: InputDecoration(
                              labelText: income != null && income != ""
                                  ? income.toString()
                                  : AppLocalizations.of(context)
                                          .translate('income') ??
                                      " Income",
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                  color: valueIRR != null && valueIRR != ""
                                      ? Colors.black
                                      : Colors.grey)),
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          validators: [
                            FormBuilderValidators.required(
                                errorText: AppLocalizations.of(context)
                                        .translate('income') ??
                                    " Income"),
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            color: logolightGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            child: Container(
                              width: 80,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  Padding(padding: EdgeInsets.all(3)),
                                  Text(
                                    AppLocalizations.of(context)
                                            .translate('add') ??
                                        "Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_fbKeyIRR.currentState.saveAndValidate() &&
                                  monthlyInterestGlobalKey.currentState
                                      .saveAndValidate() &&
                                  monthlyFeeGlobalKey.currentState
                                      .saveAndValidate() &&
                                  monthlyAdminFeeGlobalKey.currentState
                                      .saveAndValidate() &&
                                  onSelectedCurrency != null) {
                                setState(() {
                                  _isLoading = false;
                                });
                                FocusScope.of(context)
                                    .unfocus(disposition: disposition);
                                if (grossAmountController.text == "") {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showInSnackBar(
                                      AppLocalizations.of(context)
                                              .translate('') ??
                                          'Gross Amount Required',
                                      Colors.red);
                                }
                                if (loanTermController.text == "") {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showInSnackBar(
                                      AppLocalizations.of(context)
                                              .translate('') ??
                                          'Loan Term Required',
                                      Colors.red);
                                }
                                if (monthlyInterestController.text == "") {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showInSnackBar(
                                      AppLocalizations.of(context)
                                              .translate('') ??
                                          'Monthly Interest Required',
                                      Colors.red);
                                }
                                if (monthlyFeeRateController.text == "") {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showInSnackBar(
                                      AppLocalizations.of(context)
                                              .translate('') ??
                                          'Monthly Fee Required',
                                      Colors.red);
                                }
                                if (adminFeeRateController.text == "") {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showInSnackBar(
                                      AppLocalizations.of(context)
                                              .translate('') ??
                                          'Admin Fee Required',
                                      Colors.red);
                                }
                                if (grossAmountController.text != "" &&
                                    loanTermController.text != "" &&
                                    monthlyInterestController.text != "" &&
                                    monthlyFeeRateController.text != "" &&
                                    adminFeeRateController.text != "") {
                                  if (income == "" && income == null) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    showInSnackBar(
                                        AppLocalizations.of(context)
                                                .translate('') ??
                                            'Income Required',
                                        Colors.red);
                                  }

                                  if (valueIRR != null && income != null) {
                                    var index;
                                    if (data.length > 0) {
                                      for (var item in data) {
                                        setState(() {
                                          index = item['Id'] + 1;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        index = 1;
                                      });
                                    }
                                    sumAmount.addAll([storeAmountInput]);
                                    sumIncome
                                        .addAll([inputArreyIncomeNoFormat]);
                                    var listArray = {
                                      "Id": index,
                                      "Currency": "$onSelectedCurrency",
                                      "Amount":
                                          "${loanAmountInUSAController.text}",
                                      "IRR":
                                          "${valueIRR.toStringAsPrecision(4)}",
                                      "Income": "${inComeInputText.toString()}",
                                      "total": "$finalSumIRR"
                                    };
                                    data.addAll([listArray]);

                                    sumFinalIRR();
                                    sumFinalIncome();
                                    calculeFinalIRR();
                                    FocusScope.of(context)
                                        .unfocus(disposition: disposition);
                                    showInSnackBar(
                                        AppLocalizations.of(context)
                                                .translate('successfully') ??
                                            'Successfully',
                                        logolightGreen);
                                    setState(() {
                                      _isLoading = false;
                                      _isShowDefault = false;
                                      incomeController.text = "";
                                      iRRController.text = "";
                                      income = null;
                                      valueIRR = null;
                                      adminFeeRateController.text = "";
                                      monthlyFeeRateController.text = "";
                                      monthlyInterestController.text = "";
                                      loanTermController.text = "";
                                      loanAmountInUSAController.text = "";
                                      grossAmountController.text = "";
                                      loanAmountInUSAController.text = "";
                                      FocusScope.of(context)
                                          .unfocus(disposition: disposition);
                                    });
                                  }
                                }
                              } else {
                                logger().e("hello world else: else");
                                showInSnackBar(
                                    'Please select currency!', Colors.red);
                                setState(() {
                                  _isLoading = false;
                                });
                                FocusScope.of(context)
                                    .unfocus(disposition: disposition);
                              }
                            },
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            child: Container(
                              width: 80,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.restore,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  Padding(padding: EdgeInsets.all(3)),
                                  Text(AppLocalizations.of(context)
                                          .translate('reset_irr') ??
                                      "Reset"),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                incomeController.text = "";
                                iRRController.text = "";
                                income = null;
                                valueIRR = null;
                                adminFeeRateController.text = "";
                                monthlyFeeRateController.text = "";
                                monthlyInterestController.text = "";
                                loanTermController.text = "";
                                loanAmountInUSAController.text = "";
                                grossAmountController.text = "";
                                loanAmountInUSAController.text = "";
                                FocusScope.of(context)
                                    .unfocus(disposition: disposition);
                                showInSnackBar(
                                    AppLocalizations.of(context)
                                            .translate('') ??
                                        'Reset Successfully',
                                    logolightGreen);
                              });
                            },
                          ),
                          RaisedButton(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              setState(() {
                                data = [];
                                sumAmount = [];
                                sumIncome = [];
                                _isShowDefault = true;
                                finalSumIRR = null;

                                incomeController.text = "";
                                iRRController.text = "";
                                income = null;
                                valueIRR = null;
                                adminFeeRateController.text = "";
                                monthlyFeeRateController.text = "";
                                monthlyInterestController.text = "";
                                loanTermController.text = "";
                                grossAmountController.text = "";

                                //
                                loanAmountInUSAController.text = "";
                                amountDefault = "";
                                incomeIRR = "";
                                incomeDefault = "";
                                grossAmountDefaultController.text = "";
                                iRRDefaultController.text = "";
                                incomeDefaultController.text = "";
                                exchangeRateController.text = "";
                                //
                                FocusScope.of(context)
                                    .unfocus(disposition: disposition);
                                FocusScope.of(context)
                                    .unfocus(disposition: disposition);
                                showInSnackBar(
                                    AppLocalizations.of(context)
                                            .translate('clear_successfully') ??
                                        'Clear Successfully',
                                    logolightGreen);
                              });
                            },
                            child: Container(
                              width: 110,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  Padding(padding: EdgeInsets.all(3)),
                                  Text(
                                    AppLocalizations.of(context)
                                            .translate('clear_list') ??
                                        "Clear List",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (_isShowDefault == false) SizedBox(height: 15),
              if (_isShowDefault == false)
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 65,
                  child: Card(
                    color: logolightGreen,
                    child: Container(
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "IRR: ${finalSumIRR != null && finalSumIRR != "" ? finalSumIRR + ' %' : ""}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: fontWeight800,
                              fontSize: 19),
                        )),
                  ),
                ),
              _isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      height: MediaQuery.of(context).size.width * 1,
                      // width: 700,
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            // you could add any widget
                            child: ListTile(
                              contentPadding: EdgeInsets.all(4),
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Text(
                                          AppLocalizations.of(context)
                                                  .translate('no_irr') ??
                                              "No",
                                          style:
                                              TextStyle(fontSize: fontSizeXxs),
                                        )),
                                    flex: 0,
                                  ),
                                  Expanded(
                                      flex: 0,
                                      child: Text(
                                        AppLocalizations.of(context)
                                                .translate('currency') ??
                                            "Currency",
                                        style: TextStyle(fontSize: fontSizeXxs),
                                      )),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                      // flex: 2,
                                      child: Container(
                                          child: Center(
                                              child: Text(
                                    AppLocalizations.of(context)
                                            .translate('amount_USD') ??
                                        "Amount USD",
                                    style: TextStyle(fontSize: fontSizeXxs),
                                  )))),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Expanded(
                                      // flex: 1,
                                      child: Text(
                                    "IRR",
                                    style: TextStyle(fontSize: fontSizeXxs),
                                  )),
                                  Expanded(
                                      // flex: 1,
                                      child: Text(
                                    AppLocalizations.of(context)
                                            .translate('income') ??
                                        "Income",
                                    style: TextStyle(fontSize: fontSizeXxs),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(4),
                                    title: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 0,
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 21),
                                                child: Text(
                                                  data[index]["Id"].toString(),
                                                  style: TextStyle(
                                                      fontSize: fontSizeXxs),
                                                ))),
                                        Expanded(
                                            flex: 0,
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Center(
                                                  child: Text(
                                                    data[index]["Currency"],
                                                    style: TextStyle(
                                                        fontSize: fontSizeXxs),
                                                  ),
                                                ))),
                                        SizedBox(
                                          width: 38,
                                        ),
                                        Expanded(
                                            // flex: 1,
                                            child: Container(
                                          // margin: EdgeInsets.only(left: 58),
                                          child: Center(
                                            child: Text(
                                              data[index]["Amount"],
                                              style: TextStyle(
                                                  fontSize: fontSizeXxs),
                                            ),
                                          ),
                                        )),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Expanded(
                                            // flex: 1,
                                            child: Container(
                                          // margin: EdgeInsets.only(left: 10),
                                          child: Center(
                                            child: Text(
                                              data[index]["IRR"],
                                              style: TextStyle(
                                                  fontSize: fontSizeXxs),
                                            ),
                                          ),
                                        )),
                                        Expanded(
                                            // flex: 1,
                                            child: Container(
                                          // width: 200,
                                          // margin: EdgeInsets.only(left: 2),
                                          child: Center(
                                            child: Text(
                                              data[index]["Income"],
                                              style: TextStyle(
                                                  fontSize: fontSizeXxs),
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount:
                                  data != null ? data.length : [0].length,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        )),
      ),
    );
  }

  List<Widget> _buildCells(int count) {
    return List.generate(
      count,
      (index) => Container(
        alignment: Alignment.center,
        width: 120.0,
        height: 60.0,
        color: Colors.white,
        margin: EdgeInsets.all(4.0),
        child: Text("${index + 1}", style: Theme.of(context).textTheme.title),
      ),
    );
  }

  List<Widget> _buildRows(int count) {
    return List.generate(
      count,
      (index) => Row(
        children: _buildCells(10),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final int maxDigits;

  CurrencyInputFormatter(this.maxDigits);

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (maxDigits != null && newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }

    double value = double.parse(newValue.text);
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String newText = "" + formatter.format(value / 100);
    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
