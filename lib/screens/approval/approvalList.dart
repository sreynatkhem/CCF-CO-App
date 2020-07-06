import 'dart:io';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:chokchey_finance/widget/approval_widget.dart';
import 'package:flutter/material.dart';

class ApprovalLists extends StatefulWidget {
  static const routeName = '/ApprovalLists';
  @override
  _ApprovalListsState createState() => new _ApprovalListsState();
}

class _ApprovalListsState extends State<ApprovalLists>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = false;
  bool _isLoading = false;
  bool _isInit = false;

  String searchQuery = "Search query";

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

  // @override
  // void didChangeDependencies() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   if (_isInit) {
  //     Provider.of<ApprovelistProvider>(context)
  //         .fetchApprovals(http.Client())
  //         .then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  void _startSearch() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          leading: _isSearching ? const BackButton() : null,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: _buildActions(),
          backgroundColor: logolightGreen,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Approval_widget());
  }
}
