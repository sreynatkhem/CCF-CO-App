import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/models/customerRegistration.dart';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'editCustomerRegistration.dart';
import 'listCustomerRegistration.dart';

class CardDetailCustomer extends StatefulWidget {
  final dynamic list;
  var isRefresh;
  CardDetailCustomer({
    this.list,
    this.isRefresh,
  });

  @override
  _CardDetailCustomerState createState() =>
      _CardDetailCustomerState(list: list, isRefresh: isRefresh);
}

class _CardDetailCustomerState extends State<CardDetailCustomer> {
  final dynamic list;
  var detialCusotmer;
  var isRefresh = false;
  var onEditData;

  _CardDetailCustomerState({this.list, this.isRefresh});
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

  onEdit(value) async {
    var ccode = list;
    detialCusotmer = await Provider.of<ListCustomerRegistrationProvider>(
            context,
            listen: false)
        .getCustomerByID(ccode)
        .then((value) => {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new EditCustomerRegister(
                      list: value[0],
                    );
                  },
                  fullscreenDialog: true)),
              setState(() {
                onEditData = value[0];
              }),
            });
  }

  @override
  void didChangeDependencies() {
    var ccode = list;
    detialCusotmer = Provider.of<ListCustomerRegistrationProvider>(
      context,
    ).getCustomerByID(ccode);
    super.didChangeDependencies();
  }

  void onLoading() async {
    await new Future.delayed(new Duration(seconds: 1), () {
      setState(() {
        isRefresh = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var ccode = list;
    detialCusotmer =
        Provider.of<ListCustomerRegistrationProvider>(context, listen: false)
            .getCustomerByID(ccode);
    if (isRefresh == true) {
      // onLoading();
    }
    return Header(
        leading: BackButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ListCustomerRegistration(),
              ),
              ModalRoute.withName('/')),
        ),
        headerTexts: 'detail_customer_registration',
        actionsNotification: <Widget>[
          // Using Stack to show edit registration
          new Stack(
            children: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 25,
                  ),
                  onPressed: () {
                    onEdit(list);
                  }),
            ],
          ),
        ],
        bodys: FutureBuilder<List<CustomerRegistration>>(
          future: detialCusotmer,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          // padding: EdgeInsets.only(top: 10, bottom: 15),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: logolightGreen, width: 1),
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
                                              name: 'full_khmer_name',
                                              value:
                                                  '${snapshot.data[index].namekhr}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'full_english_name',
                                              value:
                                                  '${snapshot.data[index].nameeng}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'id',
                                              value:
                                                  '${snapshot.data[index].ucode}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'date_of_brith',
                                              value: getDateTimeYMD(snapshot
                                                      .data[index].dob ??
                                                  DateTime.now().toString()),
                                            ),
                                            //
                                            ListDetail(
                                              name: 'gender',
                                              value:
                                                  '${snapshot.data[index].gender}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'phone_number_1',
                                              value:
                                                  '${snapshot.data[index].phone1}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'phone_number_2',
                                              value:
                                                  '${snapshot.data[index].phone2}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'occupation_of_customer',
                                              value:
                                                  '${snapshot.data[index].occupation}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'nation_id_family_book',
                                              value:
                                                  '${snapshot.data[index].ntype}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'nation_id_family_book',
                                              value:
                                                  '${snapshot.data[index].nid}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'next_visit_date',
                                              value: getDateTimeYMD(snapshot
                                                      .data[index].ndate ??
                                                  DateTime.now().toString()),
                                            ),
                                            //

                                            ListDetail(
                                              name: 'prospective',
                                              value:
                                                  '${snapshot.data[index].pro}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'guarantor_customer',
                                              value:
                                                  '${snapshot.data[index].cstatus}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'province_code',
                                              value:
                                                  '${snapshot.data[index].provinceName}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'district_code',
                                              value:
                                                  '${snapshot.data[index].districtName}',
                                            ),
                                            //
                                            ListDetail(
                                              name: 'commune_code',
                                              value:
                                                  '${snapshot.data[index].communeName}',
                                            ),
                                            ListDetail(
                                              name: 'village_code',
                                              value:
                                                  '${snapshot.data[index].villageName}',
                                            ),
                                            ListDetail(
                                              name: 'current_location',
                                              value:
                                                  '${snapshot.data[index].goglocation}',
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 5)),
                                          ],
                                        ),
                                      ]))),
                        ),
                      );
                    })
                : Center(child: CircularProgressIndicator());
          },
        )

        ///
        );
  }
}
