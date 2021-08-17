import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/controllers/app_state_controller.dart';
import 'package:kenkan_app_x/controllers/dictionary_controller.dart';
import 'package:kenkan_app_x/controllers/notes_controller.dart';
import 'package:kenkan_app_x/controllers/pdf_view_controller.dart';
import 'package:kenkan_app_x/controllers/reader_controller.dart';
import 'package:kenkan_app_x/helpers/app_theme.dart';
import 'package:kenkan_app_x/reader_homepage.dart';
import 'package:kenkan_app_x/views/guideScreen.dart';
import 'package:kenkan_app_x/views/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'constants/names.dart';

late SharedPreferences prefs;

const wordOfTheDayTask = "wordOfTheDayTask";
const wordOfTheDayTaskID = "1";

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case wordOfTheDayTask:
        dictionaryController.updateWordForDay();
        break;
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  Get.put(AppStateController());
  Get.put(PDFViewerController());
  Get.put(NotesController());
  Get.put(ReaderController());
  Get.put(DictionaryController());

  //Check App Theme for initial App setup
  prefs.getBool("isDarkModeOn") == null
      ? prefs.setBool("isDarkModeOn", false)
      : prefs.setBool("isDarkModeOn", prefs.getBool("isDarkModeOn")!);

  //Check App Theme for initial App setup
  prefs.getString("${LocalSave.wordForTheDay}") == null
      ? prefs.setString("${LocalSave.wordForTheDay}", "Inspiration")
      : prefs.setString("${LocalSave.wordForTheDay}",
          prefs.getString("${LocalSave.wordForTheDay}")!);

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
      ? prefs.setDouble("ReaderSpeechRate", 0.8)
      : prefs.setDouble(
          "ReaderSpeechRate", prefs.getDouble("ReaderSpeechRate")!);

 await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
await  Workmanager().registerPeriodicTask(wordOfTheDayTaskID, wordOfTheDayTask);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: appStateController.isDarkModeOn.value!
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
    return Obx(() => MaterialApp(
          title: 'KenKan',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          darkTheme: AppTheme.darkTheme,
          themeMode: appStateController.isDarkModeOn.value!
              ? ThemeMode.dark
              : ThemeMode.light,
          home: SplashScreen(),
        ));
  }
}
