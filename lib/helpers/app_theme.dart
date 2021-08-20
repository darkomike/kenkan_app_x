import 'package:flutter/material.dart';
import 'package:kenkan_app_x/constants/sytle.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(

      dialogTheme: DialogTheme(
        backgroundColor:  lightColor,

      ),
    fontFamily: "IBMPlexSans",
      iconTheme: IconThemeData(color: Colors.black, size: 18),
      switchTheme: SwitchThemeData(),
      accentColor: accentColor,
      backgroundColor: lightColor,
      cardTheme: CardTheme(
        elevation: 0.0,
        color: lightColor,
      ),
      dividerColor: Colors.black,
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.black, fontSize: 24, fontFamily: "BalooTammudu2", fontWeight: FontWeight.w600),
        headline5: TextStyle(color: Colors.black, fontSize: 20,  fontWeight: FontWeight.w200), // Dialog
        headline4: TextStyle(color: Colors.black, fontSize: 16),
        headline3: TextStyle(color: Colors.black, fontSize: 18), //Normal text
        headline2: TextStyle(color: Colors.black, fontSize: 14),
        headline1: TextStyle(color: Colors.black, fontSize: 12),
        caption:  TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          //
        subtitle1:  TextStyle(
            fontSize: 25, fontFamily: "IBMPlexSans", color: Colors.black)
      ),
      scaffoldBackgroundColor: lightColor,
      appBarTheme: AppBarTheme(
          backgroundColor: accentColor,
          textTheme: TextTheme(
              headline6: TextStyle(color: Colors.black, fontSize: 20)),
          iconTheme: IconThemeData(color: Colors.black)));

  static final ThemeData darkTheme = ThemeData(
    dialogTheme: DialogTheme(
      backgroundColor:  darkColor,

    ),

    fontFamily: "IBMPlexSans",
      iconTheme: IconThemeData(color: Colors.white, size: 18),
      dividerTheme: DividerThemeData(color: Colors.white),
      scaffoldBackgroundColor:darkColor,
      backgroundColor: darkColor,

      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white, fontSize: 24, fontFamily: "BalooTammudu2", fontWeight: FontWeight.w600),
        headline5: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200), // Dialog
        headline4: TextStyle(color: Colors.white, fontSize: 16),
        headline3: TextStyle(color: Colors.white, fontSize: 18), //Normal text
        headline2: TextStyle(color: Colors.white, fontSize: 14),
        headline1: TextStyle(color: Colors.white, fontSize: 12),
          caption:  TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),

          subtitle1: TextStyle(
            fontSize: 25, fontFamily: "IBMPlexSans", color: Colors.white)

        // subtitle style
      ),

      dividerColor: Colors.white,
      appBarTheme: AppBarTheme(
          color: darkColor,
          iconTheme: IconThemeData(color: Colors.white)));
}
