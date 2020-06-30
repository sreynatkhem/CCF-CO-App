import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class DetailApprovalListCard extends StatelessWidget {
  final List<DetailApproval> approvalListDetail;

  final images = const AssetImage('assets/images/request.png');
  final _imagesList = const AssetImage('assets/images/list.png');
  final _imagesFindApproval =
      const AssetImage('assets/images/findApproval.png');
  final _imageReturn = const AssetImage('assets/images/return.png');
  final _imageReject = const AssetImage('assets/images/reject.png');

  DetailApprovalListCard({Key key, this.approvalListDetail}) : super(key: key);

  onClickCard(value, context) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(value.)));
  }

  statusApproval(value) {
    switch (value) {
      case '10':
        {
          return Text('Request');
        }
        break;

      case '20':
        {
          return Text('Approved');
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

  statusApprovalImage(value) {
    switch (value) {
      case '10':
        {
          return _imagesFindApproval;
        }
        break;

      case '20':
        {
          return _imagesList;
        }
        break;

      case '30':
        {
          return _imagesFindApproval;
        }
        break;

      case '80':
        {
          return _imageReturn;
        }
        break;

      case '90':
        {
          _imageReject;
        }
        break;
      case '':
        {
          _imagesFindApproval;
        }
        break;

      default:
        {
          _imagesFindApproval;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: approvalListDetail.length,
        itemBuilder: (context, index) {
          var dateTime = approvalListDetail[index].applicationDate;
          var status =
              statusApproval(approvalListDetail[index].evaluateStatusCode);
          var imageStatus = approvalListDetail[index].evaluateStatusCode != null
              ? statusApprovalImage(
                  approvalListDetail[index].evaluateStatusCode)
              : _imagesList;

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
                    onTap: () {},
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 5)),
                              Image(
                                image: imageStatus != null
                                    ? imageStatus
                                    : _imagesFindApproval,
                                width: 75,
                                height: 70,
                              ),
                              Padding(padding: EdgeInsets.only(right: 5)),
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
