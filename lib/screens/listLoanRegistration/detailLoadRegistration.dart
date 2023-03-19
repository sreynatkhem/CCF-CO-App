import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/listLoanApproval/detailLoanApproval.dart';
import 'package:chokchey_finance/screens/listLoanRegistration/index.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'editLoanRegistration.dart';
import 'dart:io' as Io;

class CardDetailLoanRegitration extends StatefulWidget {
  final dynamic? list;
  final dynamic? statusLoan;

  CardDetailLoanRegitration({this.list, this.statusLoan});

  @override
  _CardDetailLoanRegitrationState createState() =>
      _CardDetailLoanRegitrationState();
}

class _CardDetailLoanRegitrationState extends State<CardDetailLoanRegitration> {
  getDateTimeApprove(time) {
    DateTime dateTimeApproved = DateTime.parse(time);
    String dateTime = DateFormat("yyyy-MM-dd").format(dateTimeApproved);
    return dateTime;
  }

  getDate(time) {
    DateTime dateTimeApproved = DateTime.parse(time);
    String dateTime = DateFormat("yyyy-MM-dd").format(dateTimeApproved);
    return dateTime;
  }

  List<Asset> images = <Asset>[];
  List<File>? fileName;
  var onEditData;

  onEdit(value) {
    var locode = widget.list;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditLoanRegister(list: detiaLoan)));
    // detiaLoan = Provider.of<LoanInternal>(context, listen: false)
    //     .getLoanByID(locode)
    //     .then((value) => {
    //           Navigator.of(context).push(new MaterialPageRoute<Null>(
    //               builder: (BuildContext context) {
    //                 return new EditLoanRegister(
    //                   list: value[0],
    //                 );
    //               },
    //               fullscreenDialog: true)),
    //           setState(() {
    //             onEditData = value[0];
    //           }),
    //         });
  }

  var detiaLoan;
  var _imageDocument = [];

  @override
  void didChangeDependencies() {
    // var locode = widget.list;
    fetchLoanById();
    // detiaLoan = Provider.of<LoanInternal>(
    //   context,
    // ).getLoanByID(locode);
    getImageDocument();

    super.didChangeDependencies();
  }

  bool _isLoading = false;

  Future fetchLoanById() async {
    var locode = widget.list;
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<LoanInternal>(
        context,
      ).getLoanByID(locode).then((value) {
        setState(() {
          _isLoading = false;
          detiaLoan = value;
        });
      }).onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    setState(() {
      _imageDocument = [];
    });
    convertImagePath(dosp);
    super.dispose();
  }

  //fetch image referent document loan
  Future getImageDocument() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    try {
      final Response response = await api().get(
          Uri.parse(baseURLInternal + 'loanDocuments/byloan/' + widget.list),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });
      final parsed = jsonDecode(response.body);
      setState(() {
        _imageDocument = parsed;
      });
    } catch (error) {
      logger().e(error);
    }
  }

  var dosp = {
    'dcode': '',
    'type': 0,
    'lcode': 0,
    'description': '',
    'filepath': ''
  };
  convertImagePath(image) async {
    var file;
    switch (image['type']) {
      case '101':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);

        final directory = await getApplicationDocumentsDirectory();
        file = Io.File('${directory.path}/101.png');
        file.writeAsBytesSync(List.from(_bytes).cast<int>());
        await showDialog(context: context, builder: (_) => ImageDialog(file));

        break;
      case '102':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);

        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/102.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));

        break;
      //
      case '103':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/103.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      case '104':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/104.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));

        break;
      //
      case '211':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/211.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));

        break;
      case '212':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/212.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));

        break;
      //
      case '213':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/213.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      case '215':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/215.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      //
      case '214':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);

        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/214.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      case '216':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);

        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/216.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;

      //Business
      case '221':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/221.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      case '222':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);

        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/222.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      //
      case '223':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/223.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      //
      case '224':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/224.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      case '225':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/225.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      //
      case '226':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/226.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      //
      case '227':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/227.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      //
      case '228':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/228.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      //
      case '301':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/301.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      case '302':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/302.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    var locode = widget.list;
    // detiaLoan = Provider.of<LoanInternal>(
    //   context,
    // ).getLoanByID(locode);
    return Header(
      leading: BackButton(
        onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ListLoanRegistrations(),
            ),
            ModalRoute.withName('/')),
      ),
      headerTexts: 'detail_loan_registration',
      actionsNotification: <Widget>[
        // Using Stack to show edit registration
        new Stack(
          children: <Widget>[
            if (widget.statusLoan != 'R' &&
                widget.statusLoan != 'D' &&
                widget.statusLoan != 'A')
              new IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 25,
                  ),
                  onPressed: () {
                    onEdit(widget.list);
                  }),
            Text('')
          ],
        ),
      ],
      // bodys: FutureBuilder<List<CreateLoan>>(
      //     future: detiaLoan,
      //     builder: (context, snapshot) {
      //       return snapshot.hasData
      //           ?;
      //     })
      bodys: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : detiaLoan != null
              ? SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 10,
                        top: 10,
                        right: 10,
                        bottom: isIphoneX(context) ? 20 : 15),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: logolightGreen, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            child:
                                Row(mainAxisSize: MainAxisSize.max, children: <
                                    Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListDetail(
                                    name: 'customer_khmer_name',
                                    value: '${detiaLoan['customer']}',
                                  ),
                                  //
                                  //
                                  ListDetail(
                                    name: 'customer_id',
                                    value: '${detiaLoan['ccode']}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'loan_amount',
                                    value: detiaLoan['lamt'].toString(),
                                    // value: '\$ ${f.format(detiaLoan['lamt'])}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'currencies',
                                    value: '${detiaLoan['currency']}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'loan_product',
                                    value: '${detiaLoan['loanProduct']}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'number_of_term',
                                    value: '${detiaLoan['ints']!.toInt()}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'interest_rate',
                                    value: '${detiaLoan['intrate']}%',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'maintenance_fee',
                                    value: '${detiaLoan['mfee']}%',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'admin_fee',
                                    value: '${detiaLoan['afee']}%',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'irr',
                                    value:
                                        '${numFormat.format(detiaLoan['irr'])}%',
                                  ),
                                  ListDetail(
                                    name: 'repayment_method',
                                    value: '${detiaLoan['rmode']}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'generate_grace_period_number',
                                    value: '${detiaLoan['graperiod']}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'loan_purpose',
                                    value: '${detiaLoan['lpourpose']}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'LTV',
                                    value: '${detiaLoan['ltv']}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'Dscr',
                                    value: '${detiaLoan['dscr']}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'refer_by_who',
                                    value: '${detiaLoan['refby']}',
                                  ),
                                  //
                                  ListDetail(
                                    name: 'status',
                                    value: '${detiaLoan['lstatus']}',
                                  ),
                                  //
                                  if (_imageDocument.length > 0)
                                    Container(
                                      width: 300,
                                      height: 600,
                                      padding:
                                          EdgeInsets.only(top: 10, left: 20),
                                      child: GridView.count(
                                        crossAxisCount: 1,
                                        children: List.generate(
                                            _imageDocument.length, (index) {
                                          // File asset =
                                          //     _imageDocument;
                                          var uri =
                                              _imageDocument[index]['filepath'];
                                          Uint8List _bytes = base64
                                              .decode(uri.split(',').last);
                                          return Stack(children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    if (_imageDocument != null)
                                                      Text(
                                                        _imageDocument[index]
                                                            ["description"],
                                                        style: mainTitleBlack,
                                                      ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10)),
                                                    if (_imageDocument != null)
                                                      InkWell(
                                                        onTap: () => {
                                                          // convertImagePath(
                                                          //     _imageDocument),
                                                          // logger()
                                                          //     .e('inkWell: ${_imageDocument}')
                                                        },
                                                        child: Image.memory(
                                                          _bytes,
                                                          height: 230,
                                                          width: 300,
                                                        ),
                                                      ),
                                                  ],
                                                ))
                                          ]);
                                        }),
                                      ),
                                    ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom: isIphoneX(context) ? 10 : 5)),
                                ],
                              ),
                            ]))),
                  ),
                )
              : Center(
                  child: Container(
                      child: Text(
                          AppLocalizations.of(context)!.translate('no_data') ??
                              ""))),
    );
  }
}
