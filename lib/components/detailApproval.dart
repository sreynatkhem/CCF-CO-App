import 'dart:convert';

import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/screens/detail/Detail.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class DetailApprovalListCard extends StatelessWidget {
  final List<DetailApproval> approvalListDetail;
  final images = const AssetImage('assets/images/request.png');
  DetailApprovalListCard({Key key, this.approvalListDetail}) : super(key: key);

  onClickCard(value, context) {
    print('value: ${value.title}');
    Navigator.push(context, MaterialPageRoute(builder: (context) => Detail()));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: approvalListDetail.length,
        padding: const EdgeInsets.only(top: 20.0),
        itemBuilder: (context, index) {
          return Container(
            height: 110,
            margin: EdgeInsets.only(bottom: 5.0),
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      onClickCard(approvalListDetail[index], context);
                    },
                    child:
                        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Image(
                        image: images,
                        width: 80,
                        height: 70,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: Text(
                            'helo',
                            style: mainTitleBlack,
                          )),
                          Padding(padding: EdgeInsets.only(bottom: 2)),
                          Text('Application No: 0120202020502040'),
                          Padding(padding: EdgeInsets.only(bottom: 2)),
                          Text('102240-Sykeang Sren[Stung Meanchey]'),
                          Padding(padding: EdgeInsets.only(bottom: 2)),
                          Text('18-05-2020 09:35 AM')
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(Icons.keyboard_arrow_right)),
                    ]))),
          );
        });
  }
}
