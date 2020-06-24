import 'dart:io';
import 'package:chokchey_finance/components/button.dart';
import 'package:chokchey_finance/components/buttonPlus.dart';
import 'package:chokchey_finance/services/approvalList.dart';
import 'package:chokchey_finance/services/reject.dart';
import 'package:chokchey_finance/services/returnFuc.dart';
import 'package:http/http.dart' as http;
import 'package:chokchey_finance/components/detailApproval.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/services/detialJson.dart';
import 'package:chokchey_finance/services/registerApproval.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  final loanApprovalApplicationNo;
  Detail(this.loanApprovalApplicationNo);
  @override
  _DetailState createState() => new _DetailState(loanApprovalApplicationNo);
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  _DetailState(this.loanApprovalApplicationNo);
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;

  // borderRadius
  bool _isSearching = false;
  String searchQuery = "Search query";
  double _widtdButton = 100.0;
  double _heightButton = 40.0;
  double _borderRadius = 12.0;
  final loanApprovalApplicationNo;

  // body fetch data

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.linear),
    );

    _animation3 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.8, 1.0, curve: Curves.linear),
    );
    _controller.reverse();
    super.initState();
    _searchQuery = new TextEditingController();
    // futureAlbum = fetchAlbum();
  }

  void _startSearch() {
    print("open search box");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            Text(
              'Approval Lists',
              style: mainTitleStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(
            color: Colors.white30,
            fontFamily: 'Segoe UI',
            fontSize: fontSizeSm,
            fontWeight: fontWeight700),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    print("search query " + newQuery);
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  var _isLoading = false;
  onApprove(value) {
    return print('object');
  }

  int _angle = 90;
  bool _isRotated = true;

  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;
  Animation<double> _animation3;
  void _rotate() {
    setState(() {
      if (_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller.reverse();
      }
    });
  }

  authrize(context) {
    setState(() {
      _isLoading = true;
    });
    registerApproval(http.Client(), loanApprovalApplicationNo, 20).then(
      (_) => setState(() {
        _isLoading = false;
        Navigator.pop(context);
        fetchApprovals(http.Client());
      }),
    );
  }

  returnFuc(context) async {
    setState(() {
      _isLoading = true;
    });
    returnFunction(http.Client(), loanApprovalApplicationNo, 80).then(
      (_) => setState(() {
        _isLoading = false;
        Navigator.pop(context);
        fetchApprovals(http.Client());
      }),
    );
  }

  reject(context) async {
    setState(() {
      _isLoading = true;
    });
    rejectFunction(http.Client(), loanApprovalApplicationNo, 90).then(
      (_) => setState(() {
        _isLoading = false;
        Navigator.pop(context);
        fetchApprovals(http.Client());
      }),
    );
  }

  _refreshDetail(context) async {
    await fetchDetail(http.Client(), loanApprovalApplicationNo);
  }

  @override
  Widget build(BuildContext context) {
    return new Header(
        headerTexts: 'Detail',
        bodys: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshDetail(context),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 0,
                        child: Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Button(
                                    widtdButton: _widtdButton,
                                    heightButton: _heightButton,
                                    borderRadius: _borderRadius,
                                    onPressed: () {
                                      authrize(context);
                                    },
                                    color: logolightGreen,
                                    text: 'Authrize'),
                                Padding(padding: EdgeInsets.only(right: 5)),
                                Button(
                                    widtdButton: _widtdButton,
                                    heightButton: _heightButton,
                                    borderRadius: _borderRadius,
                                    onPressed: () {
                                      returnFuc(context);
                                    },
                                    color: Colors.green,
                                    text: 'Return'),
                                Padding(padding: EdgeInsets.only(right: 5)),
                                Button(
                                    widtdButton: _widtdButton,
                                    heightButton: _heightButton,
                                    borderRadius: _borderRadius,
                                    onPressed: () {
                                      reject(context);
                                    },
                                    color: Colors.red,
                                    text: 'Reject'),
                                Padding(padding: EdgeInsets.only(right: 5)),
                              ],
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: FutureBuilder<List<DetailApproval>>(
                          future: fetchDetail(
                              http.Client(), loanApprovalApplicationNo),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? DetailApprovalListCard(
                                    approvalListDetail: snapshot.data)
                                : Center(child: CircularProgressIndicator());
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
        floatingActionButtons: new Stack(children: <Widget>[
          ButtonPlus(
            bottom: 200.0,
            right: 24.0,
            animation3: _animation3,
            color: new Color(0xFF9E9E9E),
            text: 'Co-Borrower / Gu',
            onTap: () {
              if (_angle == 45.0) {
                print("GG1");
              }
            },
          ),
          ButtonPlus(
            bottom: 144.0,
            right: 24.0,
            animation3: _animation3,
            color: new Color(0xFF00BFA5),
            text: 'Collateral Info',
            onTap: () {
              if (_angle == 45.0) {
                print("Collateral Info");
              }
            },
          ),
          ButtonPlus(
            bottom: 88.0,
            right: 24.0,
            animation3: _animation3,
            color: new Color(0xFFE57373),
            text: 'Application Information',
            onTap: () {
              if (_angle == 45.0) {
                print("Application Information");
              }
            },
          ),
          new Positioned(
            bottom: 16.0,
            right: 16.0,
            child: new Material(
                color: new Color(0xFFE57373),
                type: MaterialType.circle,
                elevation: 6.0,
                // child: Container(
                //     width: 56.0,
                //     height: 56.00,
                //     child: RaisedButton(
                //       onPressed: null,
                //     )),
                child: new GestureDetector(
                  child: new Container(
                      width: 56.0,
                      height: 56.00,
                      child: new InkWell(
                        borderRadius: BorderRadius.circular(100),
                        splashColor: Colors.red,
                        onTap: _rotate,
                        child: new Center(
                            child: new RotationTransition(
                          turns: new AlwaysStoppedAnimation(_angle / 360),
                          child: new Icon(
                            Icons.add,
                            color: new Color(0xFFFFFFFF),
                          ),
                        )),
                        // splashColor: Colors.red, // inkwell color
                        // child: SizedBox(
                        //     width: 56, height: 56, child: Icon(Icons.menu)),
                        // onTap: () {},
                      )),
                )),
          ),
        ]));
  }
}
