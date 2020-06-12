import 'dart:io';
import 'package:chokchey_finance/components/button.dart';
import 'package:chokchey_finance/components/buttonPlus.dart';
import 'package:chokchey_finance/components/cardListApproval.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/services/approvalList.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => new _DetailState();
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "Search query";
  double _widtdButton = 120.0;
  double _heightButton = 45.0;
  double _borderRadius = 12.0;

  // borderRadius

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

  var isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return new Header(
        headerTexts: 'Detail',
        bodys: Container(
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
                            onPressed: () {},
                            color: blueColor,
                            text: 'Authrize'),
                        Padding(padding: EdgeInsets.only(right: 5)),
                        Button(
                            widtdButton: _widtdButton,
                            heightButton: _heightButton,
                            borderRadius: _borderRadius,
                            onPressed: () {},
                            color: Colors.green,
                            text: 'Return'),
                        Padding(padding: EdgeInsets.only(right: 5)),
                        Button(
                            widtdButton: _widtdButton,
                            heightButton: _heightButton,
                            borderRadius: _borderRadius,
                            onPressed: () {},
                            color: Colors.red,
                            text: 'Reject'),
                        Padding(padding: EdgeInsets.only(right: 5)),
                      ],
                    )),
              ),
              Expanded(
                flex: 1,
                child: FutureBuilder<List<Approval>>(
                  future: fetchApprovals(http.Client()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? ApprovalListCard(approvalList: snapshot.data)
                        : Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButtons: new Stack(children: <Widget>[
          ButtonPlus(
            bottom: 200.0,
            right: 24.0,
            animation3: _animation3,
            color: new Color(0xFF9E9E9E),
            text: 'GG1',
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
            text: 'GG2',
            onTap: () {
              if (_angle == 45.0) {
                print("GG2");
              }
            },
          ),
          ButtonPlus(
            bottom: 88.0,
            right: 24.0,
            animation3: _animation3,
            color: new Color(0xFFE57373),
            text: 'GG3',
            onTap: () {
              if (_angle == 45.0) {
                print("GG3");
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
                child: new GestureDetector(
                  child: new Container(
                      width: 56.0,
                      height: 56.00,
                      child: new InkWell(
                        onTap: _rotate,
                        child: new Center(
                            child: new RotationTransition(
                          turns: new AlwaysStoppedAnimation(_angle / 360),
                          child: new Icon(
                            Icons.add,
                            color: new Color(0xFFFFFFFF),
                          ),
                        )),
                      )),
                )),
          ),
        ]));
  }
}
