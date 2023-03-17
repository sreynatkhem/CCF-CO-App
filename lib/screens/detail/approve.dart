import 'dart:io';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Approve extends StatefulWidget {
  final loanApprovalApplicationNo;
  final futureListApprove;

  Approve(
    this.loanApprovalApplicationNo,
    this.futureListApprove,
  );
  @override
  _ApproveState createState() => new _ApproveState();
}

class _ApproveState extends State<Approve> with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController? _searchQuery;
  dynamic? loanApprovalApplicationNo;
  bool _isSearching = false;
  String searchQuery = "Search query";

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    // _animation = new CurvedAnimation(
    //   parent: _controller,
    //   curve: new Interval(0.0, 1.0, curve: Curves.linear),
    // );

    // _animation2 = new CurvedAnimation(
    //   (parent: _controller)!,
    //   curve: new Interval(0.5, 1.0, curve: Curves.linear),
    // );

    // _animation3 = new CurvedAnimation(
    //   (parent: _controller)!,
    //   curve: new Interval(0.8, 1.0, curve: Curves.linear),
    // );
    // _controller!.reverse();
    super.initState();
    _searchQuery = new TextEditingController();
  }

  void _startSearch() {
    ModalRoute.of(context)!
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
    setState(() {
      _searchQuery!.clear();
      updateSearchQuery("Search query");
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState!.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.translate('approval_lists') ??
                  'Approval Lists ',
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
      decoration: InputDecoration(
        hintText:
            AppLocalizations.of(context)!.translate('search') ?? 'Search...',
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
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery!.text.isEmpty) {
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

  int _angle = 90;
  bool _isRotated = true;

  AnimationController? _controller;
  Animation<double>? _animation;
  Animation<double>? _animation2;
  Animation<double>? _animation3;
  void _rotate() {
    setState(() {
      if (_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller!.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller!.reverse();
      }
    });
  }

  _refreshDetail(context) async {
    // await fetchDetail(http.Client(), loanApprovalApplicationNo);
  }

  final _imagesList = const AssetImage('assets/images/list.png');
  final images = const AssetImage('assets/images/request.png');
  final _imagesFindApproval =
      const AssetImage('assets/images/findApproval.png');
  final _imageReturn = const AssetImage('assets/images/return.png');
  final _imageReject = const AssetImage('assets/images/reject.png');
  statusApproval(value, context) {
    switch (value) {
      case '10':
        {
          return Text(
              AppLocalizations.of(context)!.translate('request') ?? 'Request');
        }
        break;

      case '20':
        {
          return Text(AppLocalizations.of(context)!.translate('approved') ??
              'Approved');
        }
        break;

      case '30':
        {
          return Text(
              AppLocalizations.of(context)!.translate('final_approve') ??
                  'Final Approve');
        }
        break;

      case '80':
        {
          return Text(
              AppLocalizations.of(context)!.translate('return') ?? 'Return');
        }
        break;

      case '90':
        {
          return Text(
              AppLocalizations.of(context)!.translate('reject') ?? 'Reject');
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

  statusApprovalImage(value, context) {
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

  getDateTimeApprove(time) {
    DateTime dateTimeApproved = DateTime.parse(time);
    String dateTime = DateFormat("yyyy-MM-dd").format(dateTimeApproved);
    return Text(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshDetail(context),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ListView.builder(
                    itemCount: widget.futureListApprove.length,
                    itemBuilder: (context, index) {
                      DateTime dateTimeParseCreated = DateTime.parse(
                          widget.futureListApprove![index]['applicationDate']);
                      String dateTimeCreated =
                          DateFormat("yyyy-MM-dd").format(dateTimeParseCreated);
                      var status = statusApproval(
                          widget.futureListApprove![index]
                              ['evaluateStatusCode'],
                          context);
                      var imageStatus = widget.futureListApprove![index]
                                  ['evaluateStatusCode'] !=
                              null
                          ? statusApprovalImage(
                              widget.futureListApprove![index]
                                  ['evaluateStatusCode'],
                              context)
                          : _imagesList;

                      return Container(
                        height: 110,
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: logolightGreen, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {},
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5)),
                                          Image(
                                            image: imageStatus != null
                                                ? imageStatus
                                                : _imagesFindApproval,
                                            width: 45,
                                            height: 45,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15)),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  child: Text(
                                                widget.futureListApprove![index]
                                                    ['authorizerEmpName'],
                                                style: mainTitleBlack,
                                              )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 2)),
                                              Text(
                                                  '${widget.futureListApprove![index]['authorizerEmployeeNo']} / ${widget.futureListApprove![index]['authorizationBranchCode']}'),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 2)),
                                              Text('$dateTimeCreated'),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 2)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          status,
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 2)),
                                          if (widget.futureListApprove![index]
                                                  ['authorizationDate'] !=
                                              '')
                                            getDateTimeApprove(
                                                widget.futureListApprove![index]
                                                    ['authorizationDate']),
                                          Text(''),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 100))
                                        ],
                                      ),
                                    ]))),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
