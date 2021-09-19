import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/models/fileModel.dart';
import 'package:kenkan_app_x/views/reader/SyncFusionPDFViewer.dart';
import '../reader_homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void backgroundProcess() {}

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (readerController.recentFiles.length > 0){

              FileModel fileModel =
                            readerController.getRecentFiles[0];

                             File file = File(fileModel.filePath);
                                  // File file = File(fileModel.file);
                                  print("File: ${file.exists()}");
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => SyncPDFViewer(
                                            file: file,
                                            fileModel: fileModel,
                                          )));
      } else {
        Navigator.pushReplacement(
          (context), MaterialPageRoute(builder: (_) => ReaderHomepage()));
      }
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    readerController.setRecentFiles();
    dictionaryController.setRecentWORDs();
    dictionaryController.setFavWORDs();
    notesController.setNotes();
    readerController.setRecentFiles();
    Widget svgNotesIcon = SvgPicture.asset(
      AssetNames.loadingFilesIconName,
      semanticsLabel: "Loading Icon",
      height: height / 4.5,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        // padding: EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            svgNotesIcon,
            SizedBox(
              height: 1,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: CircularProgressIndicator(
                color: accentColor,
                semanticsLabel: "Loading Documents...",
                backgroundColor: Theme.of(context).iconTheme.color,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Loading Documents...",
              style: Theme.of(context).textTheme.headline3,
            ),
            
            
          ],
        ),
      ),
    );
  }
}
