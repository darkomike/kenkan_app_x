import 'package:get/get.dart';
import 'package:kenkan_app_x/constants/controllers.dart';

import '../main.dart';

class AppStateController extends GetxController {
  static AppStateController instance = Get.find();

  var isDarkModeOn = false.obs;
  // var isDarkModeOn = prefs.getBool("isDarkModeOn").obs;
  var speechSpeed = prefs.getDouble("ReaderSpeechRate").obs;

  var showAppBar = false.obs;

  void updateAppBarOnScrollUp() {
    showAppBar.value = false;
  }

  void updateAppBarOnScrollDown() {
    showAppBar.value = true;
  }

  void changeAppTheme(bool value) {
    isDarkModeOn.value = value;
    prefs.setBool("isDarkModeOn", value);
  }

  void updateSpeechSpeed(double value) {
    speechSpeed.value = prefs.getDouble("ReaderSpeechRate")!;
  }

 

}
