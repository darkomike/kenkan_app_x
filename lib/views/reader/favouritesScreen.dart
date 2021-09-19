import 'dart:io';
import 'dart:math';
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
import 'system_files.dart';

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
            floatingActionButton: Visibility(
              visible: readerController.getFavFiles.length > 0 ? true : false,
              child: FloatingActionButton.extended(
                backgroundColor: primaryColor,
                tooltip: "Add Favourite File",
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
                              onPressed: () {
                                Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: (_) => SystemFilesScreen(
                                              isFavFile: true,
                                            )));
                              },
                              child: Text(
                                "PDF Files",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            )
                          ],
                        );
                      });
                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return SimpleDialog(
                  //         backgroundColor: Theme.of(context).backgroundColor,
                  //         title: Text(
                  //           "Select Files",
                  //           style: Theme.of(context).textTheme.headline3,
                  //         ),
                  //         children: [
                  //           SimpleDialogOption(
                  //             padding: EdgeInsets.symmetric(
                  //                 vertical: 8, horizontal: 20),
                  //             onPressed: () async {
                  //               final file = await PDFApi.pickPDF('');

                  //               DateTime now = DateTime.now();
                  //               _formattedDate = DateFormat(
                  //                       DateFormat.YEAR_MONTH_WEEKDAY_DAY)
                  //                   .format(now);
                  //               _formattedTime =
                  //                   DateFormat(DateFormat.HOUR_MINUTE)
                  //                       .format(now);
                  //               _fileOpenedAt =
                  //                   "$_formattedDate $_formattedTime";

                  //               String fileName = basename(file.path);
                  //               Random random = new Random();
                  //               String fileID =
                  //                   random.nextInt(100000).toString();
                  //               FileModel fileModel = FileModel(
                  //                   filePath: file.path,
                  //                   fileName: fileName,
                  //                   fileType: 'PDF',
                  //                   fileID: fileID,
                  //                   file: file,
                  //                   fileTimeOpened: _fileOpenedAt.toString());
                  //               await readerController.addFile(fileModel);

                  //               await readerController.addToFavFile(
                  //                   fileModel.fileID, fileModel.fileName);
                  //               await readerController.addToRecentFile(
                  //                   fileModel.fileID, fileModel.fileName);

                  //               Navigator.of(context)
                  //                   .pushReplacement(MaterialPageRoute(
                  //                       builder: (context) => SyncPDFViewer(
                  //                             file: file,
                  //                             fileModel: fileModel,
                  //                           )));
                  //             },
                  //             child: Text(
                  //               "PDF Files",
                  //               style: Theme.of(context).textTheme.headline2,
                  //             ),
                  //           )
                  //         ],
                  //       );
                  //     });
                },
                label: Text(
                  "Add File",
                  style: TextStyle(color: Colors.white),
                ),
                isExtended: true,
                icon: Icon(
                  Icons.add_task,
                  color: Colors.white,
                ),
              ),
            ),
            drawer: AppDrawer(),
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
              title: Text("Starred Files ",
                  style: Theme.of(context).textTheme.headline6),
            ),
            body: readerController.favFiles.length == 0
                ? _noFilesBody(context)
                : Container(
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => SizedBox(
                              height: 2,
                            ),
                        itemCount: readerController.favFiles.length,
                        itemBuilder: (context, index) {
                          FileModel fileModel =
                              readerController.getFavFiles[index];
                          return InkWell(
                            onTap: () async {
                              print(fileModel.filePath);

                              File file = File(fileModel.filePath);

                              readerController.addToRecentFile(
                                  fileModel.fileID, fileModel.fileName);

                              print(file);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SyncPDFViewer(
                                        file: file,
                                        fileModel: fileModel,
                                      )));
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
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      title: Text(
                                        "${fileModel.fileName.replaceAll(".pdf", " ")}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle:
                                          Text("${fileModel.fileTimeOpened}"),
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
                                            icon: Icon(
                                                Icons.delete_outline_outlined),
                                            onPressed: () {
                                              readerController.removeFavFileAt(
                                                  fileModel.fileID);
                                              readerController.setFavFiles();

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                action: SnackBarAction(
                                                  onPressed: () {
                                                    // TODO: Remove from fav
                                                    setState(() {});
                                                    readerController
                                                        .addToFavFile(
                                                            fileModel.fileID,
                                                            fileModel.fileName);
                                                    readerController
                                                        .setFavFiles();
                                                  },
                                                  label: "UNDO",
                                                  textColor: Colors.white,
                                                ),
                                                backgroundColor: primaryColor,
                                                duration: Duration(
                                                    milliseconds: NumberConstants
                                                        .snackBarDurationInMilliseconds),
                                                content: Text(
                                                  "${fileModel.fileName.replaceAll(".pdf", " ")} removed!",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ));
                                            },
                                            color: Colors.red),
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
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return SimpleDialog(
                //         backgroundColor: Theme.of(context).backgroundColor,
                //         title: Text(
                //           "Select Files",
                //           style: Theme.of(context).textTheme.headline3,
                //         ),
                //         children: [
                //           SimpleDialogOption(
                //             padding: EdgeInsets.symmetric(
                //                 vertical: 8, horizontal: 20),
                //             onPressed: () async {
                //               final file = await PDFApi.pickPDF('');

                //               DateTime now = DateTime.now();
                //               _formattedDate =
                //                   DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY)
                //                       .format(now);
                //               _formattedTime =
                //                   DateFormat(DateFormat.HOUR_MINUTE)
                //                       .format(now);
                //               _fileOpenedAt = "$_formattedDate $_formattedTime";

                //               String fileName = basename(file.path);
                //               Random random = new Random();
                //               String fileID = random.nextInt(100000).toString();
                //               FileModel fileModel = FileModel(
                //                   filePath: file.path,
                //                   fileName: fileName,
                //                   fileType: 'PDF',
                //                   fileID: fileID,
                //                   file: file,
                //                   fileTimeOpened: _fileOpenedAt.toString());
                //               await readerController.addFile(fileModel);

                //               await readerController.addToFavFile(
                //                   fileModel.fileID, fileModel.fileName);
                //               await readerController.addToRecentFile(
                //                   fileModel.fileID, fileModel.fileName);

                //               Navigator.of(context)
                //                   .pushReplacement(MaterialPageRoute(
                //                       builder: (context) => SyncPDFViewer(
                //                             file: file,
                //                             fileModel: fileModel,
                //                           )));
                //             },
                //             child: Text(
                //               "PDF Files",
                //               style: Theme.of(context).textTheme.headline2,
                //             ),
                //           )
                //         ],
                //       );
                //     });

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
                            onPressed: () {
                              Navigator.push(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (_) => SystemFilesScreen(
                                            isFavFile: true,
                                          )));
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor))),
        ],
      ),
    );
  }

  // void openPDF(BuildContext context, File file) {
  //   Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (context) => SyncPDFViewer(file: file,)));
  //   // Navigator.pop(context);
  // }
}
