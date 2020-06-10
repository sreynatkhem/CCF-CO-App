import 'dart:io';
import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/services/approvalList.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class ApprovalLists extends StatefulWidget {
  @override
  _ApprovalListsState createState() => new _ApprovalListsState();
}

class _ApprovalListsState extends State<ApprovalLists>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "Search query";
  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
    futureAlbum = ApprovalListApi().fetchQuote();
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
            fontWeight: fontWeight),
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

  final image = '';
  List<String> litems = ["1", "2", "3", "4", "5"];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
        backgroundColor: blueColor,
      ),
      // body: Container(
      //   padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
      //   height: 220,
      //   width: double.maxFinite,
      //   child: Card(
      //     elevation: 5,
      //   ),
      // ),
      body: Container(
          child: FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot);
            // return Text(snapshot.data.id);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      )
          //   padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
          //   child: new ListView.builder(
          //       itemCount: futureAlbum,
          //       itemBuilder: (BuildContext ctxt, int index) {
          //         return new Card(
          //           child: Row(
          //             children: <Widget>[
          //               Container(
          //                 width: 70.0,
          //                 height: 70.0,
          //                 decoration: BoxDecoration(
          //                   borderRadius:
          //                       BorderRadius.all(Radius.elliptical(45.5, 46.0)),
          //                   image: DecorationImage(
          //                     image: AssetImage('assets/images/profile.jpg'),
          //                     fit: BoxFit.cover,
          //                   ),
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: const Color(0x29000000),
          //                       offset: Offset(0, 3),
          //                       blurRadius: 6,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Text(litems[index])
          //             ],
          //           ),
          //         );
          //       }),
          ),
    );
  }
}
