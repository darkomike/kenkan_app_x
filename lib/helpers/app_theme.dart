import 'package:flutter/material.dart';
import 'package:kenkan_app_x/constants/sytle.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(

      dialogTheme: DialogTheme(
        backgroundColor:  Colors.white,

      ),
    fontFamily: "IBMPlexSans",
      iconTheme: IconThemeData(color: Colors.black, size: 20),
      switchTheme: SwitchThemeData(),
      accentColor: accentColor,
      backgroundColor: Colors.white,
      cardTheme: CardTheme(
        elevation: 0.0,
        color: Colors.white,
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
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
          backgroundColor: accentColor,
          textTheme: TextTheme(
              headline6: TextStyle(color: Colors.black, fontSize: 20)),
          iconTheme: IconThemeData(color: Colors.black)));

  static final ThemeData darkTheme = ThemeData(
    dialogTheme: DialogTheme(
      backgroundColor:  Colors.blueGrey[800],

    ),

    fontFamily: "IBMPlexSans",
      iconTheme: IconThemeData(color: Colors.white, size: 20),
      dividerTheme: DividerThemeData(color: Colors.white),
      scaffoldBackgroundColor: Colors.blueGrey[800],
      backgroundColor: Colors.blueGrey[800],

      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white, fontSize: 24, fontFamily: "BalooTammudu2", fontWeight: FontWeight.w600),
        headline5: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200), // Dialog
        headline4: TextStyle(color: Colors.white, fontSize: 16),
        headline3: TextStyle(color: Colors.white, fontSize: 18), //Normal text
        headline2: TextStyle(color: Colors.white, fontSize: 14),
        headline1: TextStyle(color: Colors.white),
          caption:  TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),

          subtitle1: TextStyle(
            fontSize: 25, fontFamily: "IBMPlexSans", color: Colors.white)

        // subtitle style
      ),

      dividerColor: Colors.white,
      appBarTheme: AppBarTheme(
          color: Colors.blueGrey[800],
          iconTheme: IconThemeData(color: Colors.white)));
}
