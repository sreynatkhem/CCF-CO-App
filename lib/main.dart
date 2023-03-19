import 'dart:async';
import 'package:chokchey_finance/providers/customerRegistration.dart';
import 'package:chokchey_finance/providers/groupLoan/index.dart';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
import 'package:chokchey_finance/providers/lmapProvider/index.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/loan/loanApproval.dart';
import 'package:chokchey_finance/providers/notification/index.dart';
import 'package:chokchey_finance/screens/approval/approvalList.dart';
import 'package:chokchey_finance/providers/approvalList.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/screens/login/index.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'localizations/appLocalizations.dart';
import 'providers/loanArrearProvider/loanArrearProvider.dart';
import 'providers/login.dart';

Future<void> main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyHomePageState state =
        context.findAncestorStateOfType<_MyHomePageState>()!;
    state.setLocale(locale);
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = new FlutterSecureStorage();
  bool _isLogin = false;
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    isLogin();
    super.didChangeDependencies();
  }

  Future<void> isLogin() async {
    String? ids = await storage.read(key: 'user_id');
    logger().e("ids: ${ids}");
    if (ids != null) {
      setState(() {
        _isLogin = true;
      });
    } else {
      setState(() {
        _isLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<LoginProvider>(create: (_) => LoginProvider()),
        Provider<ApprovelistProvider>(create: (_) => ApprovelistProvider()),
        Provider<ListCustomerRegistrationProvider>(
            create: (_) => ListCustomerRegistrationProvider()),
        Provider<CustomerRegistrationProvider>(
            create: (_) => CustomerRegistrationProvider()),
        Provider<LoanInternal>(create: (_) => LoanInternal()),
        Provider<LoanApproval>(create: (_) => LoanApproval()),
        Provider<NotificationProvider>(create: (_) => NotificationProvider()),
        Provider<GroupLoanProvider>(create: (_) => GroupLoanProvider()),
        Provider<LoanArrearProvider>(create: (_) => LoanArrearProvider()),
        Provider<LmapProvider>(create: (_) => LmapProvider()),
      ],
      child: MaterialApp(
        locale: _locale,
        debugShowCheckedModeBanner: false,
        home: _isLogin ? Home() : Login(),
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English, no country code
          const Locale('km', 'KH'), // Hebrew, no country code
        ],
        // Returns a locale which will be used by the app
        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
        routes: {ApprovalLists.routeName: (cxt) => ApprovalLists()},
      ),
    );
  }
}
