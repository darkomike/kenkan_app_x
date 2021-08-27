import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/helpers/app_functions.dart';
import 'package:kenkan_app_x/reader_homepage.dart';
import 'package:kenkan_app_x/widgets/app_drawer.dart';

import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void>? _launched;

  // bool? _isLightTheme = LocalSave.prefs!.getBool("isDarkModeOn");

  bool? _isLightTheme = true;

  double speechRateValue = 0.5;

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReaderHomepage(),
        ));
    return true;
  }

  @override
  void initState() {
    prefs.getDouble("ReaderSpeechRate") == null
        ? speechRateValue = 0.5
        : speechRateValue = prefs.getDouble("ReaderSpeechRate")!;
    prefs.getBool("isDarkModeOn") == null
        ? _isLightTheme = true
        : _isLightTheme = prefs.getBool("isDarkModeOn")!;

    debugPrint("From shared prefs ${prefs.getDouble("ReaderSpeechRate")}");
    debugPrint("From variable $speechRateValue");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        Color color = Theme.of(context).iconTheme.color!;

    return WillPopScope(
      onWillPop: _onWillPop,
      child:Obx (() =>  Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.0,
          title: Text("Settings", style: Theme.of(context).textTheme.headline6),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      "Reader Speech Speed",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Obx(() => Slider(
                        value: appStateController.speechSpeed.value!,
                        onChanged: (value) {
                          prefs.setDouble("ReaderSpeechRate", value);
                          appStateController.updateSpeechSpeed(value);

                          // setState(() {
                          //   speechRateValue = value;
                          //   debugPrint(
                          //       "From shared prefs ${prefs.getDouble("ReaderSpeechRate")}");
                          //   debugPrint("From variable $speechRateValue");
                          // });
                        },
                        label: "${appStateController.speechSpeed.value! * 100}",
                        max: 1.0,
                        min: 0.0,
                        divisions: 10,
                        activeColor: sliderColor,
                        inactiveColor: sliderColor!.withOpacity(0.5),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Obx(() => Text(
                          "Value: ${appStateController.speechSpeed.value! * 100}",
                          style: Theme.of(context).textTheme.headline2,
                        )),
                  ),
                ],
              ),
              Divider(
                height: 20,
                endIndent: 8.0,
                indent: 8.0,
              ),

              ListTile(
                  leading: Icon(
                    _isLightTheme!
                        ? Icons.nightlight_outlined
                        : Icons.light_mode,
                    color: color,
                    size: 30,
                  ),
                  title: Text(_isLightTheme! ? "Dark Theme" : "Light Theme",
                      style: Theme.of(context).textTheme.headline3),
                  trailing:  Switch(
                    activeColor: sliderColor,
                    inactiveThumbColor: sliderColor!.withOpacity(0.5),
                    onChanged: (value) {
                      prefs.setBool("isDarkModeOn", value);
                      appStateController.changeAppTheme(value);

                      // setState(() {
                      //   _isLightTheme = appStateController.isDarkModeOn.value;
                      //
                      // });
                    },
                    value: _isLightTheme =
                        appStateController.isDarkModeOn.value!,
                  )),
              // Divider(
              //   height: 5,
              // ),
              ListTile(
                leading: Icon(
                  Icons.perm_device_information_rounded,
                  color:color,
                  size: 30,
                ),
                title: Text("About App",
                    style: Theme.of(context).textTheme.headline3),
                // leading: Icon(Icons.info, color: Theme.of(context).iconTheme.color,),
                onTap: () {
                  showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return AboutDialog(
                          applicationName: "Kenkan App",
                          applicationVersion: "Version 1.0.1",
                          applicationLegalese: "IntelliSense Inc.",
                        );
                      });
                },
              ),
              // Divider(
              //   height: 5,
              // ),
              // ListTile(
              //   leading: Icon(
              //     Icons.info_outline,
              //     color: color,
              //     size: 30,
              //   ),
              //   title: Text("App Guide",
              //       style: Theme.of(context).textTheme.headline3),
              //   // leading: Icon(Icons.info, color: Theme.of(context).iconTheme.color,),
              //   onTap: () {
              //     // Navigator.push(context,
              //     //     MaterialPageRoute(builder: (_) => GuideScreen()));
              //   },
              // ),
              // Divider(
              //   height: 5,
              // ),
              ListTile(
                onTap: () => setState(() {
                  _launched = AppFunctions.launchIn(LinkNames.toFacebook);
                }),
                leading:
                    SvgPicture.asset("assets/icons/facebook.svg", height: 30),
                title: Text("Like us on FaceBook ",
                    style: Theme.of(context).textTheme.headline3),
                // subtitle: Text("Version 1.0.0"),
                // leading: Icon(Icons.info),
              ),
              // Divider(
              //   height: 5,
              // ),
              ListTile(
                onTap: () => setState(() {
                  _launched = AppFunctions.launchIn(LinkNames.toTwitter);
                }),
                leading:
                    SvgPicture.asset("assets/icons/twitter.svg", height: 30),
                title: Text("Follow us on Twitter ",
                    style: Theme.of(context).textTheme.headline3),
                subtitle: Text("@kenkan_app7"),
                // leading: Icon(Icons.info),
              ),
              // Divider(
              //   height: 5,
              // ),
              ListTile(
                onTap: () => setState(() {
                  _launched = AppFunctions.launchIn(LinkNames.toInstagram);
                }),
                leading: SvgPicture.asset(
                  "assets/icons/instagram.svg",
                  height: 30,
                ),
                title: Text("Follow us on Instagram ",
                    style: Theme.of(context).textTheme.headline3),
                subtitle: Text("@kenkan_app7"),
                // leading: Icon(Icons.info),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
