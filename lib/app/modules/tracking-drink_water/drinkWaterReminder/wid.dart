import 'package:flutter/material.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/drinkWaterReminder/utils/Debug.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/drinkWaterReminder/models/Preference.dart';

class MyApp extends StatefulWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  bool isFirstTimeUser = true;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // _initGoogleMobileAds();
    isFirstTime();
    super.initState();
  }

  isFirstTime() async {
    isFirstTimeUser =
        Preference.shared.getBool(Preference.IS_USER_FIRSTTIME) ?? true;
    Debug.printLog(isFirstTimeUser.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
