import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:toodoo/modules/onboarding/onboarding_screen.dart';
import 'package:toodoo/shared/components/constants.dart';
import 'package:toodoo/shared/cubit/bloc_observer.dart';
import 'package:toodoo/shared/network/local.dart';

import 'layout/home_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();
  await CacheHelper.init();
  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  Widget widget;
  if(onBoarding != null){
    widget = HomeLayout();
  }else{
    widget = OnboardingScreen();
  }
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  MyApp({@required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(backgroundColor: kbackgroundColor, elevation: 0),
        primaryColor: kselectedItemColor,
        scaffoldBackgroundColor: kbackgroundColor,
      ),
      home: startWidget,
    );
  }
}
