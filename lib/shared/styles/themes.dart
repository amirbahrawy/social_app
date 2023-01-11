import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    elevation: 0.0,
    titleTextStyle:
        TextStyle(color: Colors.black, fontSize: 22.0, fontFamily: 'Jannah'),
    backgroundColor: Colors.white,
    
  ),
  fontFamily: 'Jannah',
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 20.0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor),
);
