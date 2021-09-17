import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/controllers/app_state_controller.dart';
import 'package:kenkan_app_x/controllers/dictionary_controller.dart';
import 'package:kenkan_app_x/controllers/notes_controller.dart';
import 'package:kenkan_app_x/controllers/pdf_view_controller.dart';
import 'package:kenkan_app_x/controllers/reader_controller.dart';
import 'package:kenkan_app_x/helpers/app_theme.dart';

import 'package:kenkan_app_x/views/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

// const wordOfTheDayTask1 = "wordOfTheDayTask1";
// const wordOfTheDayTaskID1 = "1";

// const wordOfTheDayTask2 = "wordOfTheDayTask2";
// const wordOfTheDayTaskID2 = "2";

// void updateWordForTheDay() {
//   Get.put(DictionaryController());
//   DateTime now = DateTime.now();
//   String day = DateFormat(DateFormat.WEEKDAY).format(now);
//   String date = DateFormat(DateFormat.YEAR_MONTH_DAY).format(now);
//   int wordCategory = DictionFunctions.generateRandom(1, 27);
//   List<String> dictions = DictionFunctions.getRandomWordCategory(wordCategory);

//   int dictionsTotal = dictions.length;
//   int wordSelectedIndex = DictionFunctions.generateRandom(1, dictionsTotal + 1);
//   String choosenWord = dictions.elementAt(wordSelectedIndex);
//   print(choosenWord);
//   WordModel wordModel =
//       DictionFunctions.wordOfTheDayModel(choosenWord, date, day);
//   print("$wordModel has been added to the Words For The Day table");
// }

// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//       Get.put(DictionaryController());

//     switch (taskName) {
//       case wordOfTheDayTask1:
//         dictionaryController.updateWordForDay();

//         break;
//       case wordOfTheDayTask2:
//         break;
//     }

//     return Future.value(true);
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  //Check App Theme for initial App setup
  prefs.getBool("isDarkModeOn") == null
      ? prefs.setBool("isDarkModeOn", false)
      : prefs.setBool("isDarkModeOn", prefs.getBool("isDarkModeOn")!);

  //Check if the periodic process is already running for initial App setup
  prefs.getBool("isPeriodicPressedOn") == null
      ? prefs.setBool("isPeriodicPressedOn", false)
      : prefs.setBool(
          "isPeriodicPressedOn", prefs.getBool("isPeriodicPressedOn")!);

  //Check if the guide is checked ....
  prefs.getBool("isGuideChecked") == null
      ? prefs.setBool("isGuideChecked", false)
      : prefs.setBool("isGuideChecked", prefs.getBool("isGuideChecked")!);

  //Check Reader Speed Rate  for initial App Setup
  prefs.getDouble("ReaderSpeechRate") == null
      ? prefs.setDouble("ReaderSpeechRate", 0.4)
      : prefs.setDouble(
          "ReaderSpeechRate", prefs.getDouble("ReaderSpeechRate")!);

  Get.put(AppStateController());
  Get.put(PDFViewerController());
  Get.put(NotesController());
  Get.put(ReaderController());
  Get.put(DictionaryController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: appStateController.isDarkModeOn.value == true
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: LightAndDarkTheme(),
    );
  }
}

class LightAndDarkTheme extends StatelessWidget {
  const LightAndDarkTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    readerController.setRecentFiles();
    return Obx(() {
      return MaterialApp(
        title: 'KenKan X',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStateController.isDarkModeOn.value
            ? ThemeMode.dark
            : ThemeMode.light,
        home: SplashScreen(),
      );
    });
  }
}
