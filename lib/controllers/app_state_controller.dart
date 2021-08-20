import 'package:get/get.dart';
import 'package:kenkan_app_x/constants/controllers.dart';

import '../main.dart';

class AppStateController extends GetxController {
  static AppStateController instance = Get.find();

  var isDarkModeOn = prefs.getBool("isDarkModeOn").obs;
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

  // @override
  // void onInit() {
  //   // called immediately after the widget is allocated memory

  //   super.onInit();
  // }

  //  @override
  // void onReady() {
  //   // called after the widget is rendered on screen
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   // called just before the Controller is deleted from memory
  //   super.onClose();
  // }

}
