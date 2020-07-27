import 'package:chokchey_finance/components/Listdrawer.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/screens/listCustomerRegistration/listCustomerRegistration.dart';
import 'package:chokchey_finance/screens/listLoanRegistration/listLoanRegistration.dart';
import 'package:chokchey_finance/screens/login/Login.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Menu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  Home({
    Key key,
  }) : super(key: key);
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  PageController _pageController;
  final storage = new FlutterSecureStorage();

  String userId = '';
  String userName = '';

  final profile = const AssetImage('assets/images/profile_create.jpg');
  final profile2 = const AssetImage('assets/images/profile2.jpg');

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getStoreUser();
    super.didChangeDependencies();
  }

  getStoreUser() async {
    String user_id = await storage.read(key: 'user_id');
    String user_name = await storage.read(key: 'user_name');
    setState(() {
      userName = user_name ?? '';
      userId = user_id ?? '';
    });
  }

  onLogOut() async {
    await storage.delete(key: 'valueid');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        ModalRoute.withName("/login"));
  }

  onListCustomerRegistration() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ListCustomerRegistration()),
        ModalRoute.withName(""));
  }

  onListLoanRegistration() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ListLoanRegistration()),
        ModalRoute.withName(""));
  }

  _drawerList(context) {
    return Drawer(
      child: Container(
        color: logolightGreen,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: logolightGreen),
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image:
                            DecorationImage(image: profile, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Text(
                    userName ?? '',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Center(
                    child: Text(
                      " Your ID: ${userId ?? null} ",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    CustomListTile(Icons.face, 'List Customer Registration',
                        () => {onListCustomerRegistration()}),
                    CustomListTile(Icons.payment, 'List Loan Registration',
                        () => {onListLoanRegistration()}),
                    CustomListTile(Icons.lock, 'Log Out', () => {onLogOut()}),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      drawers: new Drawer(
        child: _drawerList(context),
      ),
      headerTexts: 'Loan',
      actionsNotification: <Widget>[
        // Using Stack to show Notification Badge
        new Stack(
          children: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: 25,
                ),
                onPressed: () {}),
            0 != 0
                ? new Positioned(
                    right: 11,
                    top: 11,
                    child: new Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '12',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : new Container()
          ],
        ),
      ],
      bodys: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: Menu(),
            ),
            Container(
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
            ),
          ],
        ),
      ),
      bottomNavigationBars: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home),
              textAlign: TextAlign.center,
              activeColor: logolightGreen),
          BottomNavyBarItem(
              title: Text('Category'),
              icon: Icon(Icons.apps),
              textAlign: TextAlign.center,
              activeColor: logolightGreen),
          BottomNavyBarItem(
              title: Text('Search'),
              icon: Icon(Icons.search),
              textAlign: TextAlign.center,
              activeColor: logolightGreen),
          BottomNavyBarItem(
              title: Text('Setting'),
              icon: Icon(Icons.settings),
              textAlign: TextAlign.center,
              activeColor: logolightGreen),
        ],
      ),
    );
  }
}
