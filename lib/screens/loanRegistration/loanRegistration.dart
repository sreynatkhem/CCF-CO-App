import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chokchey_finance/components/dropdownCustomersRegister.dart';
import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/components/imagePicker.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/listLoanApproval/index.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:logger/logger.dart';
import 'addReferentDocument.dart';

class LoanRegister extends StatefulWidget {
  @override
  _LoanRegister createState() => _LoanRegister();
}

class _LoanRegister extends State {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  //IMAGE PICKER
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    Map<Permission, PermissionStatus> statuses = await [
      // Permission.location,
      Permission.storage,
      Permission.camera,
    ].request();

    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    if (await Permission.camera.request().isDenied ||
        await Permission.camera.request().isPermanentlyDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        // Permission.location,
        Permission.storage,
        Permission.camera,
      ].request();
    }
    if (await Permission.camera.request().isGranted) {
      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 300,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Add Image",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#FFFFFF",
          ),
        );
      } on Exception catch (e) {
        error = e.toString();
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;
      setState(() {
        images = resultList;
        _error = error;
      });
    }
  }

  List<File> fileName;
  loadAssetsFile() async {
    if (await Permission.storage.request().isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
    if (await Permission.storage.request().isGranted) {
      try {
        List<File> files = await FilePicker.getMultiFile(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'pdf', 'doc'],
        );
        setState(() {
          fileName = files;
        });
      } catch (error) {}
    }
  }

  //TEXT INPUT
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
  var valueLTV;
  var valueDscr;
  var valueORARD;
  var valueReferByWho;
  var selectedValueCustmerName;
  var idCcode;
  var selectedValueCurrencies;
  var curcode;
  var pcode;

  bool selectedValueCustomer = false;
  bool validateCustomer = false;
  bool validateCurrencies = false;

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
  final GlobalKey<FormBuilderState> customerID = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> customerName =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> currenciesKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> loanProductsKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> ltvKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> dscrKey = GlobalKey<FormBuilderState>();

  final TextEditingController selectedCustomerID =
      TextEditingController(text: '');

  var listLoan;
  var loanCode;
  var statusEdit;

  onSubmit(context) async {
    // setState(() {
    //   _loading = true;
    // });
    // try {
    //   await Provider.of<LoanInternal>(context, listen: false)
    //       .postLoanRegistration(
    //           idCcode,
    //           valueAmount,
    //           curcode,
    //           pcode,
    //           valueNumberofTerm,
    //           valueInterest,
    //           valueAdminFee,
    //           valueMaintenanceFee,
    //           valueRepaymentMethod,
    //           valueMaturityDate,
    //           valueFirstRepaymentDate,
    //           valueGenerateGracePeriodNumber,
    //           valueLoanPurpose,
    //           valueLTV,
    //           valueDscr,
    //           valueORARD,
    //           valueReferByWho)
    //       .then((value) => {
    //             setState(() {
    //               _loading = false;
    //             }),
    //           });
    // } catch (error) {
    //   setState(() {
    //     _loading = false;
    //   });
    //   print('error $error');
    // }
    final storage = new FlutterSecureStorage();

    var user_ucode = await storage.read(key: 'user_ucode');
    var branch = await storage.read(key: 'branch');
    var token = await storage.read(key: 'user_token');
    try {
      final boyrow =
          "{\n\t\"ucode\": \"$user_ucode\",\n\t\"bcode\": \"$branch\",\n\t\"ccode\": \"$idCcode\",\n\t\"curcode\": \"$curcode\",\n\t\"pcode\": \"$pcode\",\n\t\"lamt\": $valueAmount,\n\t\"ints\": $valueNumberofTerm,\n\t\"intrate\": $valueInterest,\n\t\"mfee\": $valueMaintenanceFee,\n\t\"afee\": $valueAdminFee,\n\t\"rmode\": \"$valueRepaymentMethod\",\n\t\"odate\": \"\",\n\t\"mdate\": \"$valueMaturityDate\",\n\t\"firdate\": \"$valueFirstRepaymentDate\",\n\t\"graperiod\": $valueGenerateGracePeriodNumber,\n\t\"lpourpose\": \"$valueLoanPurpose\",\n\t\"ltv\": $valueLTV,\n\t\"dscr\": $valueDscr,\n\t\"refby\": \"$valueReferByWho\"}";
      final response = await api().post(baseURLInternal + 'loans',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: boyrow);
      final parsed = jsonDecode(response.body);
      print('parsed: $parsed');

      setState(() {
        loanCode = parsed;
      });
      if (statusEdit == 'save') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListLoanApproval()),
        );
      }
      // print('post loan:::: ${parsed}');
      // dataRegistration.addAll(parsed);
    } catch (error) {
      print('error: $error');
      // _isFetching = false;
    }
  }

  Future onAddFile(context) async {
    await onSubmit(context);
    // loanCode
    logger.e('loanCode: ${loanCode}');
    if (loanCode != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddReferentDocument(loanCode, null)),
      );
    }
  }

  final numberOfTermFocus = FocusNode();
  final interestRateFocus = FocusNode();
  final maintenanceFeeFocus = FocusNode();
  final adminFeeFocus = FocusNode();
  var generateGracePeriodNumberFocus = FocusNode();
  var loanPurposeFocus = FocusNode();
  var lTVFocus = FocusNode();
  var dscrFocus = FocusNode();
  var referByWhoFocus = FocusNode();
  var openDataFocus = FocusNode();
  var datehMaturityDateFocus = FocusNode();
  var firstRepaymentDateFocus = FocusNode();
  var loanAmountFocus = FocusNode();

  final TextEditingController customerNameControllers = TextEditingController();

  final ValueChanged _onChanged = (val) => print(val);

  var data = [
    {'name': "Mr.Sea", 'id': '001'},
    {'name': "Mr.SOk", 'id': '002'},
    {'name': "Mr.JOK", 'id': '003'}
  ];
  var futureListCustomer;
  getList() {
    var mappedCustomerName = data.map((fruit) => '${fruit['name']}').toList();
    return mappedCustomerName;
  }

  var _isIint = false;
  var _loading = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      _isIint = true;
      _loading = true;
    });
    if (_isIint == true) {
      getCustomer();
      getCurrencies();
      getLoanProducts();
      setState(() {
        _isIint = false;
        _loading = false;
      });
    }
    super.didChangeDependencies();
  }

  var listCustomers = [];
  getCustomer() async {
    final storage = new FlutterSecureStorage();
    var user_ucode = await storage.read(key: 'user_ucode');
    var token = await storage.read(key: 'user_token');

    try {
      final response = await api().get(
        baseURLInternal + 'valuelists/customers/' + user_ucode,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final list = jsonDecode(response.body);
      setState(() {
        listCustomers = list;
      });
    } catch (error) {}
  }

  var listCurrencies = [];
  getCurrencies() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');

    try {
      final response = await api().get(
        baseURLInternal + 'valuelists/currencies',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final list = jsonDecode(response.body);
      setState(() {
        listCurrencies = list;
      });
    } catch (error) {}
  }

  var listLoanProducts = [];
  getLoanProducts() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');

    try {
      final response = await api().get(
        baseURLInternal + 'valuelists/loanproducts',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final list = jsonDecode(response.body);
      setState(() {
        listLoanProducts = list;
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    var percentage =
        'https://uxwing.com/wp-content/themes/uxwing/download/03-text-editing/percentage.png';
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 16.0 : 0.0;
    return Header(
        headerTexts: 'loan_registration',
        bodys: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      DropDownCustomerRegister(
                        icons: Icons.face,
                        selectedValue: selectedValueCustmerName,
                        validate: validateCustomer
                            ? RoundedRectangleBorder(
                                side: BorderSide(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                        clear: true,
                        onInSidePress: () async {
                          await getCustomer();
                          SelectDialog.showModal<String>(
                            context,
                            label: AppLocalizations.of(context)
                                    .translate('Search') ??
                                'Search',
                            items: List.generate(
                                listCustomers.length,
                                (index) =>
                                    "${listCustomers[index]['ccode']} - ${listCustomers[index]['namekhr']}"),
                            onChange: (value) async {
                              setState(() {
                                selectedValueCustmerName = value ?? '';
                                selectedValueCustomer = true;
                              });
                              setState(() {
                                idCcode = value.substring(0, 6);
                                selectedCustomerID.text = value.substring(0, 6);
                              });
                            },
                          );
                        },
                        iconsClose: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            selectedValueCustmerName = 'Customer';
                          });
                        },
                        styleTexts: selectedValueCustmerName != ''
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
                        texts: selectedValueCustmerName != ''
                            ? selectedValueCustmerName
                            : "customer",
                        title: 'customer',
                      ),
                      GroupFromBuilder(
                        icons: Icons.face,
                        keys: customerID,
                        childs: FormBuilderTextField(
                          attribute: 'number',
                          controller: selectedCustomerID,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('customer_id') ??
                                "Customer ID",
                            border: InputBorder.none,
                          ),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(loanAmountFocus);
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
                            FormBuilderValidators.numeric(
                                errorText: AppLocalizations.of(context)
                                        .translate('number_only') ??
                                    'Number only')
                          ],
                          readOnly: true,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.attach_money,
                        keys: loanAmount,
                        childs: FormBuilderTextField(
                          attribute: 'number',
                          autofocus: true,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('loan_amount') ??
                                "Loan amount",
                            border: InputBorder.none,
                          ),
                          focusNode: loanAmountFocus,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(numberOfTermFocus);
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
                            FormBuilderValidators.numeric(
                                errorText: AppLocalizations.of(context)
                                        .translate('number_only') ??
                                    'Number only')
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.check,
                        keys: currenciesKey,
                        childs: FormBuilderDropdown(
                            attribute: 'name',
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                      .translate('currencies') ??
                                  "Currencies",
                              border: InputBorder.none,
                            ),
                            validators: [
                              FormBuilderValidators.required(),
                            ],
                            hint: Text(
                              AppLocalizations.of(context)
                                      .translate('currencies') ??
                                  'Currencies',
                            ),
                            items: listCurrencies
                                .map((e) => DropdownMenuItem(
                                      value: e['curname'].toString(),
                                      onTap: () => {
                                        setState(() {
                                          selectedValueCurrencies = '';
                                          curcode = e['curcode'];
                                        }),
                                      },
                                      child: Text("${e['curname']}"),
                                    ))
                                .toList()),
                      ),
                      GroupFromBuilder(
                        icons: Icons.check,
                        keys: loanProductsKey,
                        childs: FormBuilderDropdown(
                            attribute: 'name',
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                      .translate('loan_products') ??
                                  "Loan Products",
                              border: InputBorder.none,
                            ),
                            validators: [
                              FormBuilderValidators.required(),
                            ],
                            hint: Text(
                              AppLocalizations.of(context)
                                      .translate('loan_products') ??
                                  'Loan Products',
                            ),
                            items: listLoanProducts
                                .map((e) => DropdownMenuItem(
                                      value: e['pname'].toString(),
                                      onTap: () => {
                                        setState(() {
                                          pcode = e['pcode'];
                                        }),
                                      },
                                      child: Text("${e['pname']}"),
                                    ))
                                .toList()),
                      ),
                      GroupFromBuilder(
                        icons: Icons.branding_watermark,
                        keys: numberOfTerm,
                        childs: FormBuilderTextField(
                          attribute: 'number',
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(interestRateFocus);
                          },
                          focusNode: numberOfTermFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('number_of_term') ??
                                'Number of term',
                            border: InputBorder.none,
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
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      GroupFromBuilder(
                        keys: interestRate,
                        imageIcon: percentage,
                        childs: FormBuilderTextField(
                          attribute: 'number',
                          focusNode: interestRateFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(maintenanceFeeFocus);
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('interest_rate') ??
                                'Interest rate',
                            border: InputBorder.none,
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
                          inputFormatters: [
                            WhitelistingTextInputFormatter(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.attach_money,
                        keys: maintenanceFee,
                        childs: FormBuilderTextField(
                          attribute: 'number',
                          focusNode: maintenanceFeeFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(adminFeeFocus);
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('maintenance_fee') ??
                                'Maintenance fee',
                            border: InputBorder.none,
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
                          inputFormatters: [
                            WhitelistingTextInputFormatter(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.attach_money,
                        keys: adminFee,
                        childs: FormBuilderTextField(
                          attribute: 'number',
                          focusNode: adminFeeFocus,
                          textInputAction: TextInputAction.next,
                          // onFieldSubmitted: (v) {
                          //   FocusScope.of(context).requestFocus(repaymentMethodFocus);
                          // },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('admin_fee') ??
                                'Admin fee',
                            border: InputBorder.none,
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
                          inputFormatters: [
                            WhitelistingTextInputFormatter(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.check,
                        keys: repaymentMethod,
                        childs: FormBuilderDropdown(
                          attribute: 'name',
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('repayment_method') ??
                                "Repayment method",
                            border: InputBorder.none,
                          ),
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                          hint: Text(
                            AppLocalizations.of(context)
                                    .translate('repayment_method') ??
                                'Repayment method',
                          ),
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
                        keys: datehMaturityDate,
                        childs: FormBuilderDateTimePicker(
                          focusNode: datehMaturityDateFocus,
                          textInputAction: TextInputAction.next,
                          inputType: InputType.date,
                          onChanged: (v) {
                            setState(() {
                              valueMaturityDate = v ?? DateTime.now();
                            });
                          },
                          validators: [FormBuilderValidators.required()],
                          format: DateFormat("yyyy-MM-dd"),
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('maturity_date') ??
                                "Maturity date",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.date_range,
                        keys: firstRepaymentDate,
                        childs: FormBuilderDateTimePicker(
                          focusNode: firstRepaymentDateFocus,
                          textInputAction: TextInputAction.next,
                          inputType: InputType.date,
                          onChanged: (v) {
                            setState(() {
                              valueFirstRepaymentDate = v ?? DateTime.now();
                            });
                            FocusScope.of(context)
                                .requestFocus(generateGracePeriodNumberFocus);
                          },
                          validators: [FormBuilderValidators.required()],
                          format: DateFormat("yyyy-MM-dd"),
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('first_repayment_date') ??
                                "First repayment date",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.confirmation_number,
                        keys: generateGracePeriodNumber,
                        childs: FormBuilderTextField(
                          attribute: 'number',
                          focusNode: generateGracePeriodNumberFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(loanPurposeFocus);
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).translate(
                                    'generate_grace_period_number') ??
                                'Generate grace period number',
                            border: InputBorder.none,
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
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.attach_money,
                        keys: loanPurpose,
                        childs: FormBuilderTextField(
                          attribute: 'name',
                          focusNode: loanPurposeFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(lTVFocus);
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('loan_purpose') ??
                                'Loan purpose',
                            border: InputBorder.none,
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
                        icons: Icons.confirmation_number,
                        keys: ltvKey,
                        childs: FormBuilderTextField(
                          attribute: 'number',
                          focusNode: lTVFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(dscrFocus);
                          },
                          decoration: const InputDecoration(
                            labelText: 'LTV',
                            border: InputBorder.none,
                          ),
                          onChanged: (v) {
                            setState(() {
                              valueLTV = v;
                            });
                          },
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          keyboardType: TextInputType.number,
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.confirmation_number,
                        keys: dscrKey,
                        childs: FormBuilderTextField(
                          attribute: 'number',
                          focusNode: dscrFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(referByWhoFocus);
                          },
                          decoration: InputDecoration(
                            labelText: 'Dscr',
                            border: InputBorder.none,
                          ),
                          onChanged: (v) {
                            setState(() {
                              valueDscr = v;
                            });
                          },
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                          keyboardType: TextInputType.number,
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      GroupFromBuilder(
                        icons: Icons.face,
                        keys: referByWho,
                        childs: FormBuilderTextField(
                          attribute: 'name',
                          focusNode: referByWhoFocus,
                          textInputAction: TextInputAction.next,
                          // onFieldSubmitted: (v) {
                          //   FocusScope.of(context).requestFocus(repaymentMethodFocus);
                          // },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                    .translate('refer_by_who') ??
                                'Refer by who',
                            border: InputBorder.none,
                          ),
                          onChanged: (v) {
                            valueReferByWho = v;
                          },
                          valueTransformer: (text) {
                            return text == null ? null : text;
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                      AnimatedButton(
                        text: AppLocalizations.of(context).translate('save') ??
                            'Save',
                        color: logolightGreen,
                        pressEvent: () {
                          if (loanAmount.currentState.saveAndValidate() &&
                              currenciesKey.currentState.saveAndValidate() &&
                              loanProductsKey.currentState.saveAndValidate() &&
                              numberOfTerm.currentState.saveAndValidate() &&
                              interestRate.currentState.saveAndValidate() &&
                              maintenanceFee.currentState.saveAndValidate() &&
                              adminFee.currentState.saveAndValidate() &&
                              repaymentMethod.currentState.saveAndValidate() &&
                              datehMaturityDate.currentState
                                  .saveAndValidate() &&
                              firstRepaymentDate.currentState
                                  .saveAndValidate() &&
                              generateGracePeriodNumber.currentState
                                  .saveAndValidate() &&
                              ltvKey.currentState.saveAndValidate() &&
                              dscrKey.currentState.saveAndValidate()) {
                            if (selectedValueCustomer == false) {
                              setState(() {
                                validateCustomer = true;
                              });
                            } else {
                              AwesomeDialog(
                                  context: context,
                                  // animType: AnimType.LEFTSLIDE,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.SUCCES,
                                  title: AppLocalizations.of(context)
                                          .translate('succes') ??
                                      'Success',
                                  desc: AppLocalizations.of(context)
                                          .translate('thank_you') ??
                                      'Would you like to add document referent?',
                                  btnOkOnPress: () async {
                                    if (selectedValueCustomer == false) {
                                      setState(() {
                                        validateCustomer = true;
                                      });
                                    } else {
                                      setState(() {
                                        statusEdit = 'add';
                                      });
                                      await onAddFile(context);
                                      setState(() {
                                        validateCustomer = false;
                                      });
                                    }
                                  },
                                  btnCancelText: AppLocalizations.of(context)
                                          .translate('cancel') ??
                                      "Cancel",
                                  btnCancelOnPress: () async {
                                    if (selectedValueCustomer == false) {
                                      setState(() {
                                        validateCustomer = true;
                                      });
                                    } else {
                                      setState(() {
                                        statusEdit = 'save';
                                      });
                                      await onSubmit(context);
                                      setState(() {
                                        validateCustomer = false;
                                      });
                                    }
                                  },
                                  btnCancelIcon: Icons.close,
                                  btnOkIcon: Icons.check_circle,
                                  btnOkColor: logolightGreen,
                                  btnOkText: AppLocalizations.of(context)
                                          .translate('okay') ??
                                      'Okay')
                                ..show();
                            }
                          }
                        },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: bottomPadding))
                    ],
                  ),
                ),
              ));
  }
}
