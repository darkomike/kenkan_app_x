import 'dart:io';
import 'package:get/get.dart';
import 'package:kenkan_app_x/api/pdf_api.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/models/fileModel.dart';
import 'package:kenkan_app_x/reader_homepage.dart';
import 'package:kenkan_app_x/views/dictionary/dictionHomepage.dart';
import 'package:kenkan_app_x/views/helpAndFeedback.dart';
import 'package:kenkan_app_x/views/notes/notesHomepage.dart';
import 'package:kenkan_app_x/views/reader/SyncFusionPDFViewer.dart';
import 'package:kenkan_app_x/views/reader/favouritesScreen.dart';
import 'package:kenkan_app_x/views/settingsScreen.dart';
import 'package:path/path.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);

  String? _formattedDate;

  String? _formattedTime;

  String? _fileOpenedAt;

  Future<void>? _launched;

  @override
  Widget build(BuildContext context) {
    String assetName = 'assets/icons/logo.svg';
    Widget svgNotesIcon = SvgPicture.asset(
      assetName,
      semanticsLabel: "Loading Icon",
      height: height / 8,
    );

    Color color = Theme.of(context).iconTheme.color!;

    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        width: width,
        child: ListView(
          children: [
            Obx(() => Container(
                  // margin: EdgeInsets.all(0.1),
                  decoration: BoxDecoration(
                      color: appStateController.isDarkModeOn.value!
                          ? darkColor
                          : Colors.white),

                  child: Stack(
                    children: [
                      Positioned(left: 0, right: 0, child: svgNotesIcon),
                      Positioned(
                        left: 120,
                        child: Text(
                          "Kenkan",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        bottom: 5,
                      )
                    ],
                  ),
                  height: height * 0.17,
                  width: width,
                )),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: SvgPicture.asset("assets/icons/read_book.svg",
                  height: 20, color: color),
              onTap: () {
                Navigator.pushReplacement((context),
                    MaterialPageRoute(builder: (_) => ReaderHomepage()));
              },
              title: Text("Reading Now",
                  style: Theme.of(context).textTheme.headline2),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(
                Icons.open_in_new,
                color: color,
                size: Theme.of(context).iconTheme.size,
              ),
              title: Text("Open Document",
                  style: Theme.of(context).textTheme.headline2),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        backgroundColor: Theme.of(context).backgroundColor,
                        title: Text(
                          "Select Files",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        children: [
                          SimpleDialogOption(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            onPressed: () async {
                              final file = await PDFApi.pickPDF('');

                              DateTime now = DateTime.now();
                              _formattedDate =
                                  DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY)
                                      .format(now);
                              _formattedTime =
                                  DateFormat(DateFormat.HOUR_MINUTE)
                                      .format(now);
                              _fileOpenedAt = "$_formattedDate $_formattedTime";

                              String fileName = basename(file.path);

                              FileModel fileModel = FileModel(
                                  filePath: file.path,
                                  fileName: fileName,
                                  isFavFile: 0,
                                  fileType: 'PDF',
                                  timeOpened: _fileOpenedAt.toString());

                              Navigator.pop(context);
                              openPDF(context, file);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SyncPDFViewer(file: file)));
                              readerController.addToRecentFile(fileModel);
                            },
                            child: Text(
                              "PDF Files",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          )
                        ],
                      );
                    });
              },
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(
                Icons.star,
                color: color,
                size: Theme.of(context).iconTheme.size,
              ),
              title: Text("Favourites",
                  style: Theme.of(context).textTheme.headline2),
              onTap: () {
                Navigator.pushReplacement((context),
                    MaterialPageRoute(builder: (_) => FavouritesScreen()));
              },
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.book,
                color: color,
                size: Theme.of(context).iconTheme.size,
              ),
              title: Text("Dictionary",
                  style: Theme.of(context).textTheme.headline2),
              onTap: () {
                Navigator.pushReplacement((context),
                    MaterialPageRoute(builder: (_) {
                  return DictionHomePage();
                }));
              },
            ),
            ListTile(
              leading: SvgPicture.asset("assets/icons/notes.svg",
                  height: 20, color: color),
              title:
                  Text("Notes", style: Theme.of(context).textTheme.headline2),
              onTap: () {
                Navigator.pushReplacement((context),
                    MaterialPageRoute(builder: (_) => NotesHomepage()));
              },
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: color,
                size: Theme.of(context).iconTheme.size,
              ),
              title: Text("Settings",
                  style: Theme.of(context).textTheme.headline2),
              onTap: () {
                Navigator.pushReplacement((context),
                    MaterialPageRoute(builder: (_) => SettingsScreen()));
              },
            ),
            ListTile(
                leading: Icon(
                  Icons.feedback,
                  color: color,
                  size: Theme.of(context).iconTheme.size,
                ),
                title: Text("Help & Feedback",
                    style: Theme.of(context).textTheme.headline2),
                onTap: () {
                  Navigator.pushReplacement((context),
                      MaterialPageRoute(builder: (_) => HelpAndFeedback()));
                }),
            Divider(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: color,
                size: Theme.of(context).iconTheme.size,
              ),
              title: Text(
                "Exit App",
                style: Theme.of(context).textTheme.headline2,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        backgroundColor: Theme.of(context).backgroundColor,
                        title: Text(
                          "Do you want to exit the app?",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        children: [
                          SimpleDialogOption(
                            onPressed: () {
                              exit(0);
                            },
                            child: Text(
                              "Yes",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "No",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          )
                        ],
                      );
                    });
              },
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  void openPDF(BuildContext context, File file) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ReaderHomepage()));
}
