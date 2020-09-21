import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/loan/loanApproval.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as Io;

class CardDetailLoanRegitration extends StatefulWidget {
  final dynamic lists;
  // var isRefresh;

  CardDetailLoanRegitration(
    this.lists,
  );

  @override
  _CardDetailLoanRegitrationState createState() =>
      _CardDetailLoanRegitrationState(this.lists);
}

class _CardDetailLoanRegitrationState extends State<CardDetailLoanRegitration> {
  final dynamic lists;
  var list;
  var _isloading = false;
  PhotoViewController controller;
  _CardDetailLoanRegitrationState(
    this.lists,
  );
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

  List<Asset> images = List<Asset>();
  List<File> fileName;
  var onEditData;

  onEdit(value) {}

  var detiaLoan;

  @override
  void didChangeDependencies() {
    getImageDocument();
    var locode = lists;
    detiaLoan = Provider.of<LoanInternal>(
      context,
    ).getLoanByID(locode['lcode']);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    controller = PhotoViewController();
    super.initState();
  }

  void listener(PhotoViewControllerValue value) {
    setState(() {
      scaleCopy = value.scale;
    });
    logger().e('scaleCopy :: ${scaleCopy}');
  }

  @override
  void dispose() {
    controller.dispose();
    // setState(() {
    //   _imageDocument = null;
    // });
    logger().e('dispose');
    super.dispose();
  }

  var _imageDocument;

  var futureLoanApproval;
  Future getImageDocument() async {
    setState(() {
      _isloading = true;
    });
    var locode = lists;
    var url = baseURLInternal + 'loanDocuments/byloan/' + locode['lcode'];
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    try {
      final response = await api().get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      });
      final parsed = jsonDecode(response.body);
      setState(() {
        _imageDocument = parsed;
        _isloading = false;
      });
    } catch (error) {
      setState(() {
        _isloading = false;
      });
    }
  }

  onTapImageView(value) async {
    final directory = await getApplicationDocumentsDirectory();
    var file = Io.File('${directory.path}/list.png');
    file.writeAsBytesSync(List.from(value));
    return Container(
        child: PhotoView(
      imageProvider: AssetImage(file.path),
    ));
  }

  showImage(image) {
    var convert = convertImagePath(image);
  }

  File imageFile;
  convertImagePath(image) async {
    switch (image['type']) {
      case '101':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);

        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/101.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(
            context: context,
            builder: (_) => Dialog(
                  child: Container(
                    color: Colors.white,
                    width: 350,
                    height: 330,
                    child: PhotoView(
                      controller: controller,
                      backgroundDecoration: BoxDecoration(color: Colors.white),
                      imageProvider: _imageDocument != null
                          ? AssetImage(file.path)
                          : AssetImage(imageFile.path),
                    ),
                  ),
                ));
        file = Io.File('assets/images/101.png');
        logger().e("controller:: ${controller}");
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
      case '227':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/227.png');
        file.writeAsBytesSync(List.from(_bytes));
        await showDialog(context: context, builder: (_) => ImageDialog(file));
        break;
      case '226':
        var uri = image['filepath'];
        Uint8List _bytes = base64.decode(uri.split(',').last);
        final directory = await getApplicationDocumentsDirectory();
        var file = Io.File('${directory.path}/226.png');
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

  double scaleCopy;
  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Center(
            child: Container(
            child: CircularProgressIndicator(),
          ))
        : FutureBuilder<List<CreateLoan>>(
            future: detiaLoan,
            builder: (context, snapshot) {
              var f = new NumberFormat("#,###.00", "en_US");
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: logolightGreen, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                    splashColor: Colors.blue.withAlpha(30),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ListDetail(
                                                name: 'customer_khmer_name',
                                                value:
                                                    '${snapshot.data[index].customer}',
                                              ),

                                              // //
                                              ListDetail(
                                                name: 'customer_id',
                                                value:
                                                    '${snapshot.data[index].ccode}',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'loan_id',
                                                value:
                                                    '${snapshot.data[index].lcode}',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'loan_amount',
                                                value:
                                                    '\$ ${f.format(snapshot.data[index].lamt)}',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'currencies',
                                                value:
                                                    '${snapshot.data[index].currency}',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'loan_product',
                                                value:
                                                    '${snapshot.data[index].loanProduct}',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'number_of_term',
                                                value:
                                                    '${snapshot.data[index].ints.toInt()}',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'interest_rate',
                                                value:
                                                    '${snapshot.data[index].intrate}%',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'maintenance_fee',
                                                value:
                                                    '${snapshot.data[index].mfee}%',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'admin_fee',
                                                value:
                                                    '${snapshot.data[index].afee}%',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'irr',
                                                value:
                                                    '${numFormat.format(snapshot.data[index].irr).toString()}%',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'repayment_method',
                                                value:
                                                    '${snapshot.data[index].rmode}',
                                              ),
                                              // //
                                              ListDetail(
                                                name: 'open_date',
                                                value: getDateTimeYMD(snapshot
                                                        .data[index].odate ??
                                                    DateTime.now().toString()),
                                              ),

                                              ListDetail(
                                                name: 'maturity_date',
                                                value: getDateTimeYMD(snapshot
                                                        .data[index].mdate ??
                                                    DateTime.now().toString()),
                                              ),

                                              ListDetail(
                                                name: 'first_repayment_date',
                                                value: getDateTimeYMD(snapshot
                                                        .data[index].firdate ??
                                                    DateTime.now().toString()),
                                              ),

                                              ListDetail(
                                                name:
                                                    'generate_grace_period_number',
                                                value:
                                                    '${snapshot.data[index].graperiod}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'loan_purpose',
                                                value:
                                                    '${snapshot.data[index].lpourpose}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'LTV',
                                                value:
                                                    '${snapshot.data[index].ltv}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Dscr',
                                                value:
                                                    '${snapshot.data[index].dscr}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'refer_by_who',
                                                value:
                                                    '${snapshot.data[index].refby}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'status',
                                                value:
                                                    '${snapshot.data[index].lstatus}',
                                              ),
                                              if (_imageDocument != null)
                                                Container(
                                                  width: 300,
                                                  height: 600,
                                                  padding: EdgeInsets.only(
                                                      top: 10, left: 20),
                                                  child: GridView.count(
                                                    crossAxisCount: 1,
                                                    children: List.generate(
                                                        _imageDocument != null
                                                            ? _imageDocument
                                                                .length
                                                            : [], (index) {
                                                      // File asset =
                                                      //     _imageDocument[index];
                                                      var uri =
                                                          _imageDocument[index]
                                                              ['filepath'];
                                                      Uint8List _bytes =
                                                          base64.decode(uri
                                                              .split(',')
                                                              .last);

                                                      return Stack(children: <
                                                          Widget>[
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  _imageDocument[
                                                                          index]
                                                                      [
                                                                      'description'],
                                                                  style:
                                                                      mainTitleBlack,
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            10)),
                                                                InkWell(
                                                                  onTap: () {
                                                                    // showImage(
                                                                    //     _imageDocument[index]);
                                                                  },
                                                                  child: Image
                                                                      .memory(
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
                                                      bottom: 5)),
                                            ],
                                          ),
                                        ]))),
                          ),
                        );
                      })
                  : Center(child: CircularProgressIndicator());
            });
  }
}

class ImageDialog extends StatelessWidget {
  var value;
  ImageDialog(this.value);
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Colors.white,
        width: 350,
        height: 330,
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: Colors.white),
          imageProvider: AssetImage(value.path),
        ),
      ),
    );
  }
}
