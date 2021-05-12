import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/models/customerRegistration.dart';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
import 'package:chokchey_finance/screens/listCustomerRegistration/index.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'editCustomerRegistration.dart';

class CardDetailCustomer extends StatefulWidget {
  dynamic? list;
  CardDetailCustomer({
    this.list,
  });

  @override
  _CardDetailCustomerState createState() => _CardDetailCustomerState();
}

class _CardDetailCustomerState extends State<CardDetailCustomer> {
  // final dynamic list;
  dynamic? detialCusotmer;
  var onEditData;

  // _CardDetailCustomerState({
  //   this.list,
  // });
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

  onEdit() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditCustomerRegister(
                  list: detialCusotmer,
                )));
  }

  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetch();
  }

  fetch() async {
    setState(() {
      _isLoading = true;
    });
    var ccode = widget.list;
    await Provider.of<ListCustomerRegistrationProvider>(
      context,
    ).getCustomerByID(ccode).then((value) {
      setState(() {
        detialCusotmer = value;
        _isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void onLoading() async {
    await new Future.delayed(new Duration(seconds: 1), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Header(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
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
                    onEdit();
                  }),
            ],
          ),
        ],
        bodys: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(top: 10, bottom: 15),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: logolightGreen, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          child: Row(mainAxisSize: MainAxisSize.max, children: <
                              Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListDetail(
                                  name: 'full_khmer_name',
                                  value: '${detialCusotmer['namekhr']}',
                                ),
                                //
                                ListDetail(
                                  name: 'full_english_name',
                                  value: '${detialCusotmer['nameeng']}',
                                ),
                                //
                                ListDetail(
                                  name: 'id',
                                  value: '${detialCusotmer['ucode']}',
                                ),
                                //
                                ListDetail(
                                  name: 'gender',
                                  value: '${detialCusotmer['gender']}',
                                ),
                                //
                                ListDetail(
                                  name: 'phone_number_1',
                                  value: '${detialCusotmer['phone1']}',
                                ),
                                //
                                if (detialCusotmer['phone2'] != null &&
                                    detialCusotmer['phone2'] != '')
                                  ListDetail(
                                    name: 'phone_number_2',
                                    value: '${detialCusotmer['phone2']}',
                                  ),
                                //
                                ListDetail(
                                  name: 'occupation_of_customer',
                                  value: '${detialCusotmer['occupation']}',
                                ),
                                //
                                if (detialCusotmer['ndate'] != null)
                                  ListDetail(
                                    name: 'next_visit_date',
                                    value: getDateTimeYMD(
                                        detialCusotmer['ndate'] ??
                                            DateTime.now().toString()),
                                  ),
                                //

                                ListDetail(
                                  name: 'prospective',
                                  value: '${detialCusotmer['pro']}',
                                ),
                                //
                                ListDetail(
                                  name: 'province_code',
                                  value: '${detialCusotmer['provinceName']}',
                                ),
                                //
                                ListDetail(
                                  name: 'district_code',
                                  value: '${detialCusotmer['districtName']}',
                                ),
                                //
                                ListDetail(
                                  name: 'commune_code',
                                  value: '${detialCusotmer['communeName']}',
                                ),
                                ListDetail(
                                  name: 'village_code',
                                  value: '${detialCusotmer['villageName']}',
                                ),
                                ListDetail(
                                  name: 'current_location',
                                  value: '${detialCusotmer['goglocation']}',
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 5)),
                              ],
                            ),
                          ]))),
                ),
              )

        ///
        );
  }
}
