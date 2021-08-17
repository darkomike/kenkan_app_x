import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/api/pdf_api.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/models/fileModel.dart';
import 'package:kenkan_app_x/widgets/app_drawer.dart';

import 'package:path/path.dart';

import '../../reader_homepage.dart';
import 'SyncFusionPDFViewer.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  String? _formattedDate;
  String? _formattedTime;
  String? _fileOpenedAt;
  @override
  Widget build(BuildContext context) {
    readerController.setFavFiles();
    String assetNamePDF = 'assets/images/pdf.png';

    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushReplacement(
            (context), MaterialPageRoute(builder: (_) => ReaderHomepage()));

        return true;
      },
      child: Obx(() => Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          title:
              Text("Favourites", style: Theme.of(context).textTheme.headline6),
        ),
        body: readerController.favFiles.length == 0
            ? _noFilesBody(context)
            : Container(
                // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(
                          height: 2,
                        ),
                    itemCount: readerController.favFiles.length,
                    itemBuilder: (context, index) {
                      FileModel fileModel = readerController.getFavFiles[index];
                      return InkWell(
                        onTap: () async {
                          print(fileModel.filePath);

                          File file = File(fileModel.filePath);
                          print(file);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SyncPDFViewer(file: file)));
                        },
                        focusColor: primaryColor,
                        excludeFromSemantics: true,
                        enableFeedback: true,
                        hoverColor: buttonColor,
                        splashColor: buttonColor,
                        highlightColor: buttonColor,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            borderOnForeground: true,
                            color: Theme.of(context).backgroundColor,
                            elevation: 5.0,
                            shadowColor: primaryColor,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Container(
                                    child: Image.asset(assetNamePDF,
                                        fit: BoxFit.cover, height: 40),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  title: Text(
                                    "${fileModel.fileName.replaceAll(".pdf", " ")}",
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text("${fileModel.timeOpened}"),
                                ),
                                Divider(
                                  color: Theme.of(context).dividerColor,
                                  height: 3,
                                  endIndent: 5,
                                  indent: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                        tooltip: "Remove from reading now",
                                        icon:
                                            Icon(Icons.delete_outline_outlined),
                                        onPressed: () {
                                          readerController.removeFavFileAt(
                                              fileModel.fileName);
                                          fileModel.isFavFile = 0;

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration: Duration(
                                                milliseconds: NumberConstants
                                                    .snackBarDurationInMilliseconds),
                                            content: Text(
                                                "${fileModel.fileName.replaceAll(".pdf", " ")} removed!"),
                                          ));
                                        },
                                        color:
                                            Theme.of(context).iconTheme.color),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
      )),
    );
  }

  Widget _noFilesBody(BuildContext context) {
    readerController.setFavFiles();
 
    String assetName = 'assets/icons/fav_files.svg';
    Widget svgNotesIcon = SvgPicture.asset(
      assetName,
      semanticsLabel: "Loading Icon",
      height: height / 3.5,
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: svgNotesIcon),
          SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            "Keep favourite files here",
            style: Theme.of(context).textTheme.headline3,
          )),
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
              onPressed: () {
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
                                  fileType: 'PDF',
                                  isFavFile: 1,
                                  timeOpened: _fileOpenedAt.toString());
                               readerController.addToFavFile(fileModel);
                               readerController.addToRecentFile(fileModel);

                              openPDF(context, file);
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
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text("Add Document",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      primaryColor))),
        ],
      ),
    );
  }

  void openPDF(BuildContext context, File file) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SyncPDFViewer(file: file)));
    // Navigator.pop(context);
  }
}
