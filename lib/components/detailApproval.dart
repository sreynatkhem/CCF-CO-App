import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class DetailApprovalListCard extends StatelessWidget {
  final List<DetailApproval> approvalListDetail;
  final images = const AssetImage('assets/images/request.png');
  DetailApprovalListCard({Key key, this.approvalListDetail}) : super(key: key);

  onClickCard(value, context) {
    print('value: $value');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(value.)));
  }

  statusApproval(value) {
    print("value: $value");
    switch (value) {
      case '10':
        {
          return Text('Request');
        }
        break;

      case '20':
        {
          return Text('Approve');
        }
        break;

      case '30':
        {
          return Text('Final Approve');
        }
        break;

      case '80':
        {
          return Text('Return');
        }
        break;

      case '90':
        {
          return Text('Reject');
        }
        break;
      case '':
        {
          return Text('');
        }
        break;

      default:
        {
          return Text('');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: approvalListDetail.length,
        padding: const EdgeInsets.only(top: 20.0),
        itemBuilder: (context, index) {
          var dateTime = approvalListDetail[index].applicationDate;
          var status =
              statusApproval(approvalListDetail[index].evaluateStatusCode);
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
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
                                    approvalListDetail[index].authorizerEmpName,
                                    style: mainTitleBlack,
                                  )),
                                  Padding(padding: EdgeInsets.only(bottom: 2)),
                                  Text(
                                      '${approvalListDetail[index].authorizerEmployeeNo} / ${approvalListDetail[index].authorizationBranchCode}'),
                                  Padding(padding: EdgeInsets.only(bottom: 2)),
                                  Text('${dateTime}')
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              status,
                              Padding(padding: EdgeInsets.only(bottom: 2)),
                              Text(
                                  approvalListDetail[index].authorizationDate ==
                                          ''
                                      ? ''
                                      : approvalListDetail[index]
                                          .authorizationDate),
                              Text(''),
                              Padding(padding: EdgeInsets.only(right: 100))
                            ],
                          ),
                        ]))),
          );
        });
  }
}
