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

  //
  final TextEditingController grossAmountDefaultController =
      TextEditingController();
  final TextEditingController iRRDefaultController = TextEditingController();
  final TextEditingController incomeDefaultController = TextEditingController();

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
  var forParseIncome;
  var subSecoundString;
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
    var grossAmountParse = int.parse(grossAmount);

    // var valueIRRParse = int.parse(vauleIRRForParse);
    var numberFormatIncome = new NumberFormat("###", "en_US");
    var test = grossAmountParse * vauleIRRForParse;
    subSecoundString = test.toString().substring(0, 3);
    var parsedIncome = int.parse(subSecoundString);
    forParseIncome = numberFormatIncome.format(parsedIncome);
    setState(() {
      valueIRR = ((monthlyInterestIRR + monthlyFeeIRR) * 12) +
          ((adminFeeIRR / numberofTermIRR) * 12);
      income = grossAmountParse * vauleIRRForParse;
      storeIncomeInput = income as int;
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
  }

  sumFinalIncome() {
    int sum = sumIncome.reduce((sumSoFar, currentInt) {
      return sumSoFar + currentInt;
    });
    setState(() {
      finalSumIncome = sum;
    });
  }

  calculeFinalIRR() {
    setState(() {
      finalSumIRR = (finalSumIncome / finalSumAmount);
    });

    logger().e("finalSumIRR: ${finalSumIRR}");
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

  UnfocusDisposition disposition = UnfocusDisposition.scope;

  @override
  Widget build(BuildContext context) {
    var numberFormatIncomes = new NumberFormat("###", "en_US");
    return SingleChildScrollView(
      child: Center(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            if (_isShowDefault == true)
              FormBuilder(
                  // context,
                  key: _fbKeyShowDefault,
                  child: Column(children: [
                    SizedBox(height: 15),
                    FormBuilderDropdown(
                      attribute: "Currency",
                      decoration: InputDecoration(labelText: "USD"),
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      attribute: "gross_disbursement_amount_default",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // ignore: deprecated_member_use
                        WhitelistingTextInputFormatter(
                            RegExp(r'^(\d+)?\.?\d{0,100}')),
                        // WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      controller: grossAmountDefaultController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('gross_disbursement_amount') ??
                              "Gross Disbursement Amount"),
                      onChanged: (v) {
                        dynamic amountDocble = double.parse(v);

                        MoneyFormatterOutput fo =
                            FlutterMoneyFormatter(amount: amountDocble).output;
                        convertCurrency(v);
                        var amountInt = int.parse(v);
                        paresAmountNumberDefault = int.parse(v);
                        storeAmount = amountInt as int;
                        if (mounted)
                          setState(() {
                            currencyAmountDouble = fo.symbolOnLeft;
                            amountDefault = v;
                          });
                      },
                      onFieldSubmitted: (v) {
                        paresAmountNumberDefault = int.parse(v);
                        if (mounted) {
                          if (grossAmountDefaultController.text.length > 1) {
                            dynamic amountDocble = double.parse(v);
                            MoneyFormatterOutput fo =
                                FlutterMoneyFormatter(amount: amountDocble)
                                    .output;
                            FocusScope.of(context)
                                .requestFocus(loanAmountDefaultFocus);
                            storeAmount = v as int;
                            setState(() {
                              currencyAmountDouble = fo.symbolOnLeft;
                              grossAmountDefaultController.text =
                                  fo.symbolOnLeft.toString();
                              amountDefault = v;
                            });
                          }
                        }
                      },
                      validators: [
                        FormBuilderValidators.numeric(errorText: "requeiure."),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text("$showValueAmountDefault"),
                    FormBuilderTextField(
                      attribute: "irrDefault",
                      keyboardType: TextInputType.number,
                      focusNode: loanAmountDefaultFocus,
                      inputFormatters: [
                        // ignore: deprecated_member_use
                        WhitelistingTextInputFormatter(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                      ],
                      controller: iRRDefaultController,
                      decoration: InputDecoration(labelText: "IRR"),
                      onChanged: (v) {
                        var numberFormat = new NumberFormat("#,###", "en_US");
                        if (mounted) {
                          var irrParse = double.parse(v);
                          var subFirstIncome =
                              paresAmountNumberDefault * irrParse;
                          var subSecoundString =
                              subFirstIncome.toString().substring(0, 4);
                          parsedIncome = int.parse(subSecoundString);
                          var finalIncome = numberFormat.format(parsedIncome);
                          setState(() {
                            incomeIRR = finalIncome;
                            storeIncome = parsedIncome as int;
                            incomeDefaultController.text = finalIncome;
                          });
                        }
                      },
                      onFieldSubmitted: (v) {
                        var numberFormat = new NumberFormat("#,###", "en_US");

                        if (mounted) {
                          var amount = int.parse(amountDefault);
                          var irrParse = double.parse(v);
                          var subFirstIncome = amount * irrParse;
                          var subSecoundString =
                              subFirstIncome.toString().substring(0, 4);
                          parsedIncome = int.parse(subSecoundString);
                          var finalIncome = numberFormat.format(parsedIncome);
                          setState(() {
                            incomeIRR = finalIncome;
                            incomeDefaultController.text = finalIncome;
                            storeIncome = parsedIncome as int;
                          });
                        }
                      },
                      validators: [
                        FormBuilderValidators.numeric(errorText: "requeiure."),
                      ],
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      readOnly: true,
                      attribute: "incomeDefault",
                      controller: incomeDefaultController,
                      validators: [
                        FormBuilderValidators.numeric(errorText: "requeiure."),
                      ],
                      decoration: InputDecoration(
                          labelText:
                              incomeDefault != null && incomeDefault != ""
                                  ? irr.toString()
                                  : AppLocalizations.of(context)
                                          .translate('income') ??
                                      "Income"),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(''),
                        RaisedButton(
                          color: logolightGreen,
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
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
                              var listArray = {
                                "Id": index,
                                "Currency": "USD",
                                "Amount": "$showValueAmountDefault",
                                "IRR": "${incomeDefaultController.text}",
                                "Income": "${incomeDefaultController.text}",
                              };
                              data.addAll([listArray]);
                              sumAmount.addAll([storeAmount]);
                              sumIncome.addAll([storeIncome]);
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
                              });
                              logger().e("sumAmount2: ${sumAmount}");
                              logger().e("sumIncome2: ${sumIncome}");
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              logger().e("sumAmount3: ${sumAmount}");
                            }
                          },
                        ),
                        RaisedButton(
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
                            });
                          },
                          child: Text("Clear Form",
                              style: TextStyle(color: Colors.white)),
                        ),
                        Text(''),
                      ],
                    ),
                  ])),
            if (_isShowDefault == false)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)
                              .translate('exchange_rate') ??
                          'Exchange Rate:'),
                      Padding(padding: EdgeInsets.only(right: 20)),
                      Container(
                        width: 150,
                        height: 30,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: exchangeRateController,
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
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              border: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: logolightGreen)),
                              hintStyle: TextStyle(fontSize: 15),
                              hintText: AppLocalizations.of(context)
                                      .translate('exchange_rate') ??
                                  'Exchange Rate:'),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            if (_isShowDefault == false) SizedBox(height: 15),
            if (_isShowDefault == false)
              Container(
                child: Text('Your expected IRR is: '),
                alignment: Alignment.centerLeft,
              ),
            if (_isShowDefault == false)
              FormBuilder(
                // context,
                key: _fbKeyIRR,
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    FormBuilderDropdown(
                      attribute: "Currency",
                      decoration: InputDecoration(
                          labelText: (AppLocalizations.of(context)
                                  .translate('select_currency') ??
                              'Select Currency')),
                      onChanged: (v) {
                        if (mounted)
                          setState(() {
                            onSelectedCurrency = v;
                            grossAmount = null;
                            loanAmountInUSA = null;
                            grossAmountController.text = null;
                          });
                      },
                      hint: Text(AppLocalizations.of(context)
                              .translate('select_currency') ??
                          'Select Currency'),
                      validators: [FormBuilderValidators.required()],
                      items: ['USD', 'KHR']
                          .map((gender) => DropdownMenuItem(
                              value: gender, child: Text("$gender")))
                          .toList(),
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      attribute: "gross_disbursement_amount",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // ignore: deprecated_member_use
                        WhitelistingTextInputFormatter(
                            RegExp(r'^(\d+)?\.?\d{0,100}')),
                        // CurrencyInputFormatter(12),
                      ],
                      controller: grossAmountController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('gross_disbursement_amount') ??
                              "Gross Disbursement Amount"),
                      onChanged: (v) {
                        if (onSelectedCurrency.toString() == "USD") {
                          convertCurrency(v);
                          var parsed = int.parse(v);
                          logger().e("showValueAmountDefault: ${v}");
                          setState(() {
                            loanAmountInUSAController.text =
                                showValueAmountDefault;
                            grossAmount = v;
                            storeAmountInput = parsed as int;
                          });
                        } else if (onSelectedCurrency.toString() == "KHR") {
                          var grossDouble = int.parse(v);
                          var exChangeRateDouble = int.parse(exchangeRate);
                          setState(() {
                            grossAmount = grossDouble / exChangeRateDouble;
                            loanAmountInUSAController.text = numFormat
                                .format(grossDouble / exChangeRateDouble)
                                .toString();
                            storeAmountInput = grossDouble as int;
                          });
                        }
                        iRRCalculation();
                      },
                      onFieldSubmitted: (v) {
                        if (onSelectedCurrency.toString() == "USD") {
                          var parsed = int.parse(v);
                          convertCurrency(v);
                          setState(() {
                            storeAmount = v as int;
                            grossAmount = v;
                            storeAmountInput = parsed as int;
                            loanAmountInUSAController.text =
                                showValueAmountDefault;
                          });
                        } else if (onSelectedCurrency.toString() == "KHR") {
                          var grossDouble = int.parse(v);
                          var exChangeRateDouble = int.parse(exchangeRate);
                          setState(() {
                            grossAmount = grossDouble / exChangeRateDouble;
                            loanAmountInUSAController.text = numFormat
                                .format(grossDouble / exChangeRateDouble)
                                .toString();
                            storeAmount = v as int;
                            storeAmountInput = grossAmount as int;
                          });
                        }
                        iRRCalculation();
                      },
                      validators: [
                        FormBuilderValidators.numeric(errorText: "requeiure."),
                      ],
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      readOnly: true,
                      attribute: "loana_amount_in_USD",
                      controller: loanAmountInUSAController,
                      inputFormatters: [
                        // ignore: deprecated_member_use
                        // WhitelistingTextInputFormatter.digitsOnly
                      ],
                      validators: [
                        // FormBuilderValidators.min(1),
                        // FormBuilderValidators.required(
                        //     errorText: AppLocalizations.of(context)
                        //             .translate('loan_amount_required') ??
                        //         "Loan amount Required(*)"),
                        // FormBuilderValidators.numeric(
                        //     errorText: AppLocalizations.of(context)
                        //             .translate('number_only') ??
                        //         'Number only')
                      ],
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('loana_amount_in_USD') ??
                              "Loan Amount in USD"),
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      attribute: "loan_term",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // ignore: deprecated_member_use
                        WhitelistingTextInputFormatter(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                      ],
                      controller: loanTermController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('loan_term') ??
                              "Loan Term"),
                      onChanged: (v) {
                        setState(() {
                          loanTerm = v;
                        });
                        iRRCalculation();
                      },
                      onFieldSubmitted: (v) {},
                      validators: [
                        FormBuilderValidators.required(
                            errorText: AppLocalizations.of(context)
                                    .translate('number_of_term_required') ??
                                "Number of term Required(*)"),
                      ],
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      attribute: "monthly_interest",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // ignore: deprecated_member_use
                        WhitelistingTextInputFormatter(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                      ],
                      controller: monthlyInterestController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('monthly_interest') ??
                              "Monthly Interest"),
                      onChanged: (v) {
                        if (mounted) {
                          setState(() {
                            monthlyInterest = v;
                          });
                          iRRCalculation();
                        }
                      },
                      onFieldSubmitted: (v) {},
                      validators: [
                        FormBuilderValidators.min(0.1),
                        FormBuilderValidators.max(1.5),
                        FormBuilderValidators.required(
                            errorText: AppLocalizations.of(context).translate(
                                    'monthly_interest_rate_required') ??
                                "Monthly interest rate required(*)"),
                      ],
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      attribute: "monthly_fee_rate",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // ignore: deprecated_member_use
                        WhitelistingTextInputFormatter(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                      ],
                      controller: monthlyFeeRateController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('monthly_fee_rate') ??
                              "Monthly Fee Rate"),
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
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
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
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                                  .translate('admin_fee_rate') ??
                              "Admin Fee Rate"),
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
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      readOnly: true,
                      attribute: "irr",
                      controller: iRRController,
                      decoration: InputDecoration(
                          hintText: "IRR",
                          labelStyle: TextStyle(
                              color: valueIRR != null ? Colors.black : null),
                          labelText:
                              valueIRR != null ? valueIRR.toString() : "IRR"),
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      readOnly: true,
                      attribute: "income",
                      controller: incomeController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: income != null ? Colors.black : null),
                          labelText: income != null
                              ? subSecoundString.toString()
                              : AppLocalizations.of(context)
                                      .translate('income') ??
                                  "Income"),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(''),
                        RaisedButton(
                          color: logolightGreen,
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            var totalSumAmount;
                            setState(() {
                              _isLoading = true;
                            });
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

                              var numberFormatIncome =
                                  new NumberFormat("###", "en_US");
                              // var test = grossAmountParse * vauleIRRForParse;
                              var subSecoundString =
                                  income.toString().substring(0, 3);
                              var parsedIncome = int.parse(subSecoundString);
                              forParseIncome =
                                  numberFormatIncome.format(parsedIncome);
                              //
                              sumAmount.addAll([storeAmountInput]);
                              sumIncome.addAll([parsedIncome]);

                              logger().e(
                                  "loanAmountInUSAController.text: ${loanAmountInUSAController.text}");

                              var listArray = {
                                "Id": index,
                                "Currency": "$onSelectedCurrency",
                                "Amount": "${loanAmountInUSAController.text}",
                                "IRR": "${valueIRR}",
                                "Income": "${forParseIncome}",
                                "total": "$grossAmount"
                              };
                              data.addAll([listArray]);
                              setState(() {
                                _isLoading = false;
                                _isShowDefault = false;
                                amountDefault = "";
                                incomeIRR = "";
                                incomeDefault = "";
                                //
                                grossAmountDefaultController.text = "";
                                iRRDefaultController.text = "";
                                incomeDefaultController.text = "";
                              });
                              sumFinalIRR();
                              sumFinalIncome();
                              calculeFinalIRR();
                            }
                          },
                        ),
                        RaisedButton(
                          child: Text("Reset"),
                          onPressed: () {
                            // _fbKeyIRR.currentState.reset();
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
                              FocusScope.of(context)
                                  .unfocus(disposition: disposition);
                            });
                          },
                        ),
                        Text('')
                      ],
                    ),
                  ],
                ),
              ),
            _isLoading
                ? CircularProgressIndicator()
                : Container(
                    height: 500,
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
                                        "No",
                                        style: TextStyle(fontSize: fontSizeXxs),
                                      )),
                                  flex: 0,
                                ),
                                Expanded(
                                    flex: 0,
                                    child: Text(
                                      "Currency",
                                      style: TextStyle(fontSize: fontSizeXxs),
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                        child: Center(
                                            child: Text(
                                      "Amount USD",
                                      style: TextStyle(fontSize: fontSizeXxs),
                                    )))),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      "IRR",
                                      style: TextStyle(fontSize: fontSizeXxs),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Income",
                                      style: TextStyle(fontSize: fontSizeXxs),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: RaisedButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          data = [];
                                          sumAmount = [];
                                          sumIncome = [];
                                          _isShowDefault = true;
                                          FocusScope.of(context).unfocus(
                                              disposition: disposition);
                                        });
                                      },
                                      child: Container(
                                        height: 10,
                                        child: Text(
                                          "Clear List",
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
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
                                      Expanded(
                                          flex: 0,
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 25),
                                              child: Text(
                                                data[index]["Id"].toString(),
                                                style: TextStyle(
                                                    fontSize: fontSizeXxs),
                                              ))),
                                      Expanded(
                                          flex: 0,
                                          child: Container(
                                              child: Text(
                                            data[index]["Currency"],
                                            style: TextStyle(
                                                fontSize: fontSizeXxs),
                                          ))),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 50),
                                            child: Text(
                                              data[index]["Amount"],
                                              style: TextStyle(
                                                  fontSize: fontSizeXxs),
                                            ),
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              data[index]["IRR"],
                                              style: TextStyle(
                                                  fontSize: fontSizeXxs),
                                            ),
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: 200,
                                            margin: EdgeInsets.only(left: 13),
                                            child: Text(
                                              data[index]["Income"],
                                              style: TextStyle(
                                                  fontSize: fontSizeXxs),
                                            ),
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            "",
                                            style: TextStyle(
                                                fontSize: fontSizeXxs),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: data != null ? data.length : [0].length,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      )),
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
