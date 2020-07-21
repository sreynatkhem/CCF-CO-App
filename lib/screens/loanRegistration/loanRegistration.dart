import 'package:chokchey_finance/components/dropdownCustomersRegister.dart';
import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class LoanRegister extends StatefulWidget {
  @override
  _LoanRegister createState() => _LoanRegister();
}

class _LoanRegister extends State {
  var valueAmount;
  var valueNumberofTerm;
  var valueInterest;
  var valueMaintenanceFee;
  var valueAdminFee;
  var valueRepaymentMethod;
  var valueOpenDate;
  var valueMaturityDate;
  var valueFirstRepaymentDate;
  var valueGenerateGracePeriodNumber;
  var valueLoanPurpose;
  var valueORARD;
  var valueReferByWho;

  final GlobalKey<FormBuilderState> maintenanceFee =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> interestRate =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> numberOfTerm =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> loanAmount = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> adminFee = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> repaymentMethod =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> openData = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> datehMaturityDate =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> firstRepaymentDate =
      GlobalKey<FormBuilderState>();

  final GlobalKey<FormBuilderState> generateGracePeriodNumber =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> loanPurpose = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> oRARD = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> referByWho = GlobalKey<FormBuilderState>();

  onSubmit() {
    print({
      valueAmount,
      valueNumberofTerm,
      valueInterest,
      valueAdminFee,
      valueMaintenanceFee,
      valueRepaymentMethod,
      valueOpenDate,
      valueMaturityDate,
      valueFirstRepaymentDate,
      valueGenerateGracePeriodNumber,
      valueLoanPurpose,
      valueORARD,
      valueReferByWho
    });
  }

  final numberOfTermFocus = FocusNode();
  final interestRateFocus = FocusNode();
  final maintenanceFeeFocus = FocusNode();
  final adminFeeFocus = FocusNode();
  var generateGracePeriodNumberFocus = FocusNode();
  var loanPurposeFocus = FocusNode();
  var referByWhoFocus = FocusNode();
  var openDataFocus = FocusNode();
  var datehMaturityDateFocus = FocusNode();
  var firstRepaymentDateFocus = FocusNode();

  final ValueChanged _onChanged = (val) => print(val);
  @override
  Widget build(BuildContext context) {
    var percentage =
        'https://uxwing.com/wp-content/themes/uxwing/download/03-text-editing/percentage.png';
    return Header(
      headerTexts: 'Loans Register',
      bodys: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            GroupFromBuilder(
              icons: Icons.attach_money,
              keys: loanAmount,
              childs: FormBuilderTextField(
                autofocus: true,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Loan amount',
                ),
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(numberOfTermFocus);
                },
                onChanged: (v) {
                  setState(() {
                    valueAmount = v;
                  });
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(errorText: 'Number only')
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            GroupFromBuilder(
              icons: Icons.branding_watermark,
              keys: numberOfTerm,
              childs: FormBuilderTextField(
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(interestRateFocus);
                },
                focusNode: numberOfTermFocus,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Number of term',
                ),
                onChanged: (v) {
                  setState(() {
                    valueNumberofTerm = v;
                  });
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                validators: [
                  FormBuilderValidators.required(),
                ],
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              ),
            ),
            GroupFromBuilder(
              keys: interestRate,
              imageIcon: percentage,
              childs: FormBuilderTextField(
                focusNode: interestRateFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(maintenanceFeeFocus);
                },
                decoration: const InputDecoration(
                  labelText: 'Interest rate',
                ),
                onChanged: (v) {
                  setState(() {
                    valueInterest = v;
                  });
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                validators: [
                  FormBuilderValidators.required(),
                ],
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              ),
            ),
            GroupFromBuilder(
              icons: Icons.attach_money,
              keys: maintenanceFee,
              childs: FormBuilderTextField(
                focusNode: maintenanceFeeFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(adminFeeFocus);
                },
                decoration: const InputDecoration(
                  labelText: 'Maintenance fee',
                ),
                onChanged: (v) {
                  setState(() {
                    valueMaintenanceFee = v;
                  });
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                validators: [
                  FormBuilderValidators.required(),
                ],
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              ),
            ),
            GroupFromBuilder(
              icons: Icons.attach_money,
              keys: adminFee,
              childs: FormBuilderTextField(
                focusNode: adminFeeFocus,
                textInputAction: TextInputAction.next,
                // onFieldSubmitted: (v) {
                //   FocusScope.of(context).requestFocus(repaymentMethodFocus);
                // },
                decoration: const InputDecoration(
                  labelText: 'Admin fee',
                ),
                onChanged: (v) {
                  setState(() {
                    valueAdminFee = v;
                    valueRepaymentMethod = v;
                  });
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                validators: [
                  FormBuilderValidators.required(),
                ],
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              ),
            ),
            GroupFromBuilder(
              icons: Icons.check,
              keys: repaymentMethod,
              childs: FormBuilderDropdown(
                decoration: InputDecoration(
                  labelText: "Repayment method",
                ),
                validators: [
                  FormBuilderValidators.required(),
                ],
                hint: Text(
                  'Repayment method',
                ),
                // onChanged: (value) {
                //   setState(() {
                //     FocusScope.of(context).requestFocus(FocusNode());
                //     valueRepaymentMethod = value;
                //   });
                // },
                onChanged: (value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() => valueRepaymentMethod = value);
                },
                items: [
                  'Declining',
                  'Annuity',
                  'Semi-balloon',
                  'Balloon',
                  'Negotiate',
                ]
                    .map((valueGurantorCustomer) => DropdownMenuItem(
                        value: valueGurantorCustomer,
                        child: Text(
                          "$valueGurantorCustomer",
                        )))
                    .toList(),
              ),
            ),

            GroupFromBuilder(
              icons: Icons.date_range,
              keys: openData,
              childs: FormBuilderDateTimePicker(
                attribute: 'date',
                focusNode: openDataFocus,
                textInputAction: TextInputAction.next,
                inputType: InputType.date,
                onChanged: (v) {
                  valueOpenDate = v ?? DateTime.now();
                },
                validators: [FormBuilderValidators.required()],
                format: DateFormat("yyyy-MM-dd"),
                decoration: InputDecoration(labelText: "Open date"),
              ),
            ),
            GroupFromBuilder(
              icons: Icons.date_range,
              keys: datehMaturityDate,
              childs: FormBuilderDateTimePicker(
                attribute: 'date',
                focusNode: datehMaturityDateFocus,
                textInputAction: TextInputAction.next,
                inputType: InputType.date,
                onChanged: (v) {
                  valueMaturityDate = v ?? DateTime.now();
                },
                validators: [FormBuilderValidators.required()],
                format: DateFormat("yyyy-MM-dd"),
                decoration: InputDecoration(labelText: "Maturity date"),
              ),
            ),
            GroupFromBuilder(
              icons: Icons.date_range,
              keys: firstRepaymentDate,
              childs: FormBuilderDateTimePicker(
                attribute: 'date',
                focusNode: firstRepaymentDateFocus,
                textInputAction: TextInputAction.next,
                inputType: InputType.date,
                onChanged: (v) {
                  valueFirstRepaymentDate = v ?? DateTime.now();
                  FocusScope.of(context)
                      .requestFocus(generateGracePeriodNumberFocus);
                },
                validators: [FormBuilderValidators.required()],
                format: DateFormat("yyyy-MM-dd"),
                decoration: InputDecoration(labelText: "First repayment date"),
              ),
            ),

            GroupFromBuilder(
              icons: Icons.confirmation_number,
              keys: generateGracePeriodNumber,
              childs: FormBuilderTextField(
                focusNode: generateGracePeriodNumberFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(loanPurposeFocus);
                },
                decoration: const InputDecoration(
                  labelText: 'Generate grace period number',
                ),
                onChanged: (v) {
                  valueGenerateGracePeriodNumber = v;
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                keyboardType: TextInputType.number,
                validators: [
                  FormBuilderValidators.required(),
                ],
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              ),
            ),
            GroupFromBuilder(
              icons: Icons.attach_money,
              keys: loanPurpose,
              childs: FormBuilderTextField(
                focusNode: loanPurposeFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(referByWhoFocus);
                },
                decoration: const InputDecoration(
                  labelText: 'Loan purpose',
                ),
                onChanged: (v) {
                  valueLoanPurpose = v;
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
                keyboardType: TextInputType.text,
              ),
            ),
            GroupFromBuilder(
              icons: Icons.face,
              keys: referByWho,
              childs: FormBuilderTextField(
                focusNode: referByWhoFocus,
                textInputAction: TextInputAction.next,
                // onFieldSubmitted: (v) {
                //   FocusScope.of(context).requestFocus(repaymentMethodFocus);
                // },
                decoration: const InputDecoration(
                  labelText: 'Refer by who',
                ),
                onChanged: (v) {
                  valueReferByWho = v;
                },
                valueTransformer: (text) {
                  return text == null ? null : text;
                },
              ),
            ),
            GroupFromBuilder(
              icons: Icons.check,
              keys: oRARD,
              childs: FormBuilderDropdown(
                decoration: InputDecoration(
                  labelText:
                      "O=Open,R=Request, A=Approved,R=Return,D=Disapprove",
                ),
                validators: [
                  FormBuilderValidators.required(),
                ],
                hint: Text(
                  'O,R,A,R,D',
                ),
                onChanged: (value) {
                  setState(() {
                    valueORARD = value;
                  });
                },
                items: [
                  'Open',
                  'Request',
                  'Approved',
                  'Return',
                  'Disapprove',
                ]
                    .map((valueORARD) => DropdownMenuItem(
                        value: valueORARD,
                        child: Text(
                          "$valueORARD",
                        )))
                    .toList(),
              ),
            ),

            // TextInput(
            //   icons: const Icon(Icons.label_important),
            //   textInput: "U1",
            //   controllers: controllerU1,
            // ),
            // TextInput(
            //   icons: const Icon(Icons.label_important),
            //   textInput: "U2",
            //   controllers: controllerU2,
            // ),
            // TextInput(
            //   icons: const Icon(Icons.label_important),
            //   textInput: "U3",
            //   controllers: controllerU3,
            // ),
            // TextInput(
            //   icons: const Icon(Icons.label_important),
            //   textInput: "U4",
            //   controllers: controllerU4,
            // ),
            // TextInput(
            //   icons: const Icon(Icons.label_important),
            //   textInput: "U5",
            //   controllers: controllerU5,
            // ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                height: 90,
                padding: EdgeInsets.only(top: 40, left: 10, bottom: 10),
                child: new RaisedButton(
                  onPressed: () {
                    onSubmit();
                  },
                  color: logolightGreen,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: logolightGreen, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
