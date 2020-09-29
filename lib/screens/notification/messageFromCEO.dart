import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/providers/notification/index.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class AnnouncementDetail extends StatefulWidget {
  var list;
  AnnouncementDetail({this.list});

  @override
  _AnnouncementDetailState createState() =>
      _AnnouncementDetailState(list: list);
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  var list;
  _AnnouncementDetailState({this.list});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAnnouncement();
  }

  var _isLoading = false;
  var listData;

  Future fetchAnnouncement() async {
    setState(() {
      _isLoading = true;
    });
    await NotificationProvider().postNotificationRead(list['id']);
    await NotificationProvider()
        .fetchNotificationAnnouncement(list['lcode'])
        .then((value) => {
              setState(() {
                _isLoading = false;
                listData = value;
              }),
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => AnnouncementDetail(
              //             list: value,
              //           )),
              // )
            })
        .catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      headerTexts: 'announment',
      bodys: _isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 1,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 10),
                        child: Text(
                          listData['anntitle'],
                          style: mainTitleStyleBlack,
                        )),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.width * 0.4,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.network(
                          listData['annpath'],
                          width: MediaQuery.of(context).size.width * 1,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Text(
                          listData['anndes'],
                        )),
                  ],
                ),
              ],
            )),
    );
  }
}
