import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/api/pdf_api.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/views/reader/SyncFusionPDFViewer.dart';
import 'package:kenkan_app_x/views/reader/system_files.dart';
import 'package:kenkan_app_x/widgets/app_drawer.dart';
import 'package:path/path.dart';
import 'constants/sytle.dart';
import 'main.dart';
import 'models/fileModel.dart';

class ReaderHomepage extends StatefulWidget {
  @override
  _ReaderHomepageState createState() => _ReaderHomepageState();
}

class _ReaderHomepageState extends State<ReaderHomepage>
    with SingleTickerProviderStateMixin {
  double direction = 1.0;
  AnimationController? _animationController;
  Animation<double>? _animation;

  String? _formattedDate;
  String? _formattedTime;
  String? _fileOpenedAt;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.fastLinearToSlowEaseIn));
    _animationController!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String assetNamePDF = 'assets/images/pdf.png';

    String assetName = 'assets/icons/notes_taking.svg';
    Widget svgNotesIcon = SvgPicture.asset(
      assetName,
      semanticsLabel: "Loading Icon",
      height: height / 4,
    );

    readerController.setRecentFiles();

    return Obx(() => Scaffold(
          floatingActionButton: Visibility(
            visible: readerController.getRecentFiles.length > 0 ? true : false,
            child: FloatingActionButton.extended(
              backgroundColor: primaryColor,
              tooltip: "Open Document",
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
                                            isFavFile: false,
                                          )));
                            },
                            child: Text(
                              "PDF Files",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          )
                        ],
                      );

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
                    });
              },
              label: Text(
                "Open File",
                style: TextStyle(color: Colors.white),
              ),
              isExtended: true,
              icon: Icon(
                Icons.open_in_new,
                color: Colors.white,
              ),
            ),
          ),
          drawer: AppDrawer(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            title: Text("Recent Files",
                style: Theme.of(context).textTheme.headline6),
            actions: [
              PopupMenuButton(
                  color: Theme.of(context).backgroundColor,
                  onSelected: (value) async {
                    // final appState = Provider.of<AppStateNotifier>(context);
                    switch (value) {
                      case 1:
                        readerController.clearRecentFiles();
                        readerController.setRecentFiles();
                        break;
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(Icons.clear_all,
                                color: Theme.of(context).iconTheme.color),
                            title: Text("Clear List",
                                style: Theme.of(context).textTheme.headline2),
                          ),
                          value: 1,
                        ),
                      ])
            ],
          ),
          body: readerController.recentFiles.length == 0
              ? _noFilesBody(context)
              : Container(
                  // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => SizedBox(
                            height: 2,
                          ),
                      itemCount: readerController.recentFiles.length,
                      itemBuilder: (context, index) {
                        FileModel fileModel =
                            readerController.getRecentFiles[index];

                        return AnimatedBuilder(
                          animation: _animation!,
                          builder: (context, child) {
                            return Transform(
                              transform: Matrix4.translationValues(
                                  direction * _animation!.value * width, 0, 0),
                              child: InkWell(
                                onTap: () async {
                                  if (readerController
                                          .isFavFile(fileModel.fileID) ==
                                      true) {
                                  } else {}
                                  print(fileModel.filePath);

                                  DateTime now = DateTime.now();
                                  _formattedDate = DateFormat(
                                          DateFormat.YEAR_MONTH_WEEKDAY_DAY)
                                      .format(now);
                                  _formattedTime =
                                      DateFormat(DateFormat.HOUR_MINUTE)
                                          .format(now);
                                  _fileOpenedAt =
                                      "$_formattedDate $_formattedTime";

                                  readerController.updateRecentFiles(
                                      _fileOpenedAt!, fileModel.fileID);
                                  readerController.setRecentFiles();

                                  File file = File(fileModel.filePath);
                                  // File file = File(fileModel.file);
                                  print("File: ${file.exists()}");
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
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
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
                                          subtitle: Text(
                                              "${fileModel.fileTimeOpened}"),
                                        ),
                                        Divider(
                                          color: Theme.of(context).dividerColor,
                                          height: 0.1,
                                          endIndent: 5,
                                          indent: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            readerController
                                                    .isFavFile(fileModel.fileID)
                                                ? IconButton(
                                                    tooltip:
                                                        "Removing from Favourites",
                                                    icon: Icon(Icons.star),
                                                    onPressed: () {
                                                      setState(() {});
                                                      readerController
                                                          .removeFavFileAt(
                                                              fileModel.fileID);
                                                      readerController
                                                          .setFavFiles();

                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                              elevation: 2,
                                                              action:
                                                                  SnackBarAction(
                                                                onPressed: () {
                                                                  //TODO:
                                                                },
                                                                label: "UNDO",
                                                              ),
                                                              backgroundColor:
                                                                  primaryColor,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      NumberConstants
                                                                          .snackBarDurationInMilliseconds),
                                                              content: Text(
                                                                "Removed ${fileModel.fileName.replaceAll(".pdf", "")} from Favourites",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )));
                                                    },
                                                    color: Colors.blue[700],
                                                  )
                                                : IconButton(
                                                    tooltip:
                                                        "Add to Favourites",
                                                    icon: Icon(Icons
                                                        .star_border_outlined),
                                                    onPressed: () {
                                                      setState(() {});
                                                      readerController
                                                          .addToFavFile(
                                                              fileModel.fileID,
                                                              fileModel
                                                                  .fileName);
                                                      readerController
                                                          .setFavFiles();

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        action: SnackBarAction(
                                                          onPressed: () {
                                                            // TODO: Remove from fav
                                                            setState(() {});
                                                            readerController
                                                                .removeFavFileAt(
                                                              fileModel.fileID,
                                                            );
                                                            readerController
                                                                .setFavFiles();
                                                          },
                                                          label: "UNDO",
                                                          textColor:
                                                              Colors.white,
                                                        ),
                                                        backgroundColor:
                                                            primaryColor,
                                                        duration: Duration(
                                                            milliseconds:
                                                                NumberConstants
                                                                    .snackBarDurationInMilliseconds),
                                                        content: Text(
                                                          "Saved ${fileModel.fileName.replaceAll(".pdf", " ")} to Favourites",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ));
                                                    },
                                                    color: Colors.blue[700],
                                                  ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                                tooltip:
                                                    "Remove from reading now",
                                                icon: Icon(Icons
                                                    .delete_outline_outlined),
                                                onPressed: () {
                                                  readerController
                                                      .removeRecentFileAt(
                                                          fileModel.fileID);
                                                  debugPrint(
                                                      "File is removed at index ${fileModel.fileID}");

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        primaryColor,
                                                    action: SnackBarAction(
                                                      onPressed: () {
                                                        // TODO: Remove from fav
                                                        setState(() {});
                                                        readerController
                                                            .addToRecentFile(
                                                                fileModel
                                                                    .fileID,
                                                                fileModel
                                                                    .fileName);
                                                        readerController
                                                            .setRecentFiles();
                                                      },
                                                      label: "UNDO",
                                                      textColor: Colors.white,
                                                    ),
                                                    content: Text(
                                                      "Removed ${fileModel.fileName}",
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
                              ),
                            );
                          },
                        );
                      }),
                ),
        ));
  }

  Widget _noFilesBody(BuildContext context) {
    String assetName = 'assets/icons/recent_files.svg';
    Widget svgNotesIcon = SvgPicture.asset(
      assetName,
      semanticsLabel: "Loading Icon",
      height: height / 3.5,
    );
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: svgNotesIcon,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            "No document reading currently",
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
                            onPressed: () {
                              Navigator.push(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (_) => SystemFilesScreen(
                                            isFavFile: false,
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
                //                   fileID: fileID,
                //                   file: file,
                //                   fileType: 'PDF',
                //                   fileTimeOpened: _fileOpenedAt!);

                //               Navigator.of(context).push(MaterialPageRoute(
                //                   builder: (context) => SyncPDFViewer(
                //                         file: file,
                //                         fileModel: fileModel,
                //                       )));

                //               readerController.addFile(fileModel);
                //               readerController.addToRecentFile(
                //                   fileModel.fileID, fileModel.fileName);
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
              icon: Icon(
                Icons.open_in_new,
                color: Colors.white,
              ),
              label: Text("Open Document",
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
  //       MaterialPageRoute(builder: (context) => SyncPDFViewer(file: file)));
  //   // Navigator.pop(context);
  // }
}
