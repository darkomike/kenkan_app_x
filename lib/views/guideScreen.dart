import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/main.dart';
import 'package:kenkan_app_x/reader_homepage.dart';
import 'package:kenkan_app_x/views/splashScreen.dart';


class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _index,
        children: [
          Container(
            padding: EdgeInsets.only(top: height / 20, right: 10, left: 10),
            color: Theme.of(context).backgroundColor,
            width: width,
            child: Positioned(
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Brief Guide",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Container(
                    child: SvgPicture.asset(AssetNames.welcomeIconName,
                        height: height / 3.0),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "Welcome to the most sort after pdf reader.\nIn this app, we have three main components."
                        "They include: \n1. PDF Reader \n2. Dictionary \n3. Notepad\n\nPlease follow this guide to know some"
                        " awesome features we have in store for you.\n",
                        style: Theme.of(context).textTheme.headline3,
                      )),
                  SizedBox(
                    height: height / 100,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _index = _index + 1;
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              primaryColor)),
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )),
                  SizedBox(
                    height: height / 50,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (_) => SplashScreen()));
                            },
                            child: Text("Skip>>",
                                style: Theme.of(context).textTheme.headline3)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // -------------------------------------------------------------------------------------------------------------------

          Container(
            padding: EdgeInsets.only(top: height / 20, right: 10, left: 10),
            color: Theme.of(context).backgroundColor,
            width: width,
            child: Positioned(
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Reader",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Container(
                    child: SvgPicture.asset(AssetNames.welcomeReaderIconName,
                        height: height / 2.5),
                  ),
                  Container(
                      child: Text(
                    "Please follow this guide to know some awesome features we have in store for you. ",
                    style: Theme.of(context).textTheme.headline3,
                  )),
                  SizedBox(
                    height: height / 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  primaryColor)),
                          onPressed: () {
                            setState(() {
                              _index = _index - 1;
                            });
                          },
                          child: Text(
                            "<<Back",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  primaryColor)),
                          onPressed: () {
                            setState(() {
                              _index = _index + 1;
                            });
                          },
                          child: Text(
                            "Next>>",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: height / 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (_) => SplashScreen()));
                            },
                            child: Text("Skip>>",
                                style: Theme.of(context).textTheme.headline3)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // -------------------------------------------------------------------------------------------------------------------

          Container(
            padding: EdgeInsets.only(top: height / 20, right: 10, left: 10),
            color: Colors.blue[200],
            width: width,
            child: Positioned(
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Dictionary",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: SvgPicture.asset(AssetNames.welcomeDictionaryIconName,
                        height: height / 2.5),
                  ),
                  Container(
                      child: Text(
                    "Please follow this guide to know some awesome features we have in store for you. ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  )),
                  SizedBox(
                    height: height / 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  primaryColor)),
                          onPressed: () {
                            setState(() {
                              _index = _index - 1;
                            });
                          },
                          child: Text(
                            "<<Back",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  primaryColor)),
                          onPressed: () {
                            setState(() {
                              _index = _index + 1;
                            });
                          },
                          child: Text(
                            "Next>>",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: height / 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (_) => SplashScreen()));
                            },
                            child: Text("Skip>>",
                                style: Theme.of(context).textTheme.headline3)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // -------------------------------------------------------------------------------------------------------------------
          Container(
            padding: EdgeInsets.only(top: height / 20, right: 10, left: 10),
            color: Colors.blue[200],
            width: width,
            child: Positioned(
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: SvgPicture.asset(AssetNames.welcomeNotesIconName,
                        height: height / 2.5),
                  ),
                  Container(
                      child: Text(
                    "Please follow this guide to know some awesome features we have in store for you. ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  )),
                  SizedBox(
                    height: height / 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  primaryColor)),
                          onPressed: () {
                            setState(() {
                              _index = _index - 1;
                            });
                          },
                          child: Text(
                            "<<Back",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  primaryColor)),
                          onPressed: () {
                            prefs.setBool("isGuideChecked", true);
                            Navigator.pushReplacement(
                                (context),
                                MaterialPageRoute(
                                    builder: (_) => ReaderHomepage()));
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: height / 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (_) => SplashScreen()));
                            },
                            child: Text("Skip>>",
                                style: Theme.of(context).textTheme.headline3)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // -------------------------------------------------------------------------------------------------------------------
        ],
      ),
    );
  }
}
