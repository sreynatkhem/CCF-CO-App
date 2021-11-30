import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:logger/logger.dart';

class CallLogScreen extends StatefulWidget {
  const CallLogScreen({Key? key}) : super(key: key);

  @override
  _CallLogScreenState createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  @override
  void didChangeDependencies() async {
    onFetchCallLog();
    super.didChangeDependencies();
  }

  bool _isLoading = false;
  dynamic _callLogEntries;

  onFetchCallLog() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Iterable entries = await CallLog.get();
// QUERY CALL LOG (ALL PARAMS ARE OPTIONAL)
      var now = DateTime.now();
      int from = now.subtract(Duration(days: 60)).millisecondsSinceEpoch;
      int to = now.subtract(Duration(days: 30)).millisecondsSinceEpoch;
      entries = await CallLog.query(
        dateFrom: from,
        dateTo: to,
      );
      setState(() {
        _isLoading = false;
      });
      for (CallLogEntry entry in entries) {
        var callType = entry.callType.toString().substring(9).toCapitalized();
        children.add(
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: logolightGreen, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 100,
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/phonecall.png"),
                              radius: 20,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8),
                            alignment: Alignment.bottomLeft,
                            width: 260,
                            height: 120,
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 200,
                                        child: Text(
                                          "Name: ${entry.name == null ? "" : entry.name}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          overflow: TextOverflow.fade,
                                        )),
                                    Row(
                                      children: [
                                        Container(
                                          width: 170,
                                          child: Text(
                                            'Number: ${entry.number} ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 15)),
                                        Column(
                                          children: [
                                            Text(
                                              "Duration",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              child: Text(
                                                '${entry.duration} min',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        'Type: ${callType}',
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final List<Widget> children = <Widget>[];

  @override
  Widget build(BuildContext context) {
    var entry;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: logolightGreen,
        title: Text(
            AppLocalizations.of(context)!.translate('call_log') ?? "Call log"),
      ),

      // keys: _scaffoldKeyCreateCustomer,
      // headerTexts: 'Call Log',
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(child: Column(children: children)),
    );
  }
}
