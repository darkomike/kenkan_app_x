import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/api/pdf_api.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/views/reader/SyncFusionPDFViewer.dart';
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

      return Obx(()=> Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,

          title:
              Text("Reading Now", style: Theme.of(context).textTheme.headline6),
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
                              style: Theme.of(context).textTheme.headline3),
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
                      FileModel fileModel = readerController.getRecentFiles[index];

                      return AnimatedBuilder(
                        animation: _animation!,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.translationValues(
                                direction * _animation!.value * width, 0, 0),
                            child: InkWell(
                              onTap: () async {
                                if (await readerController.isFavFile(fileModel) == 1) {
                                  fileModel.isFavFile = 1;
                                } else {
                                  fileModel.isFavFile = 0;
                                }
                                print(fileModel.filePath);

                                File file = File(fileModel.filePath);
                                print(file);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SyncPDFViewer(file: file)));
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
                                            Text("${fileModel.timeOpened}"),
                                      ),
                                      Divider(
                                        color: Theme.of(context).dividerColor,
                                        height: 0.1,
                                        endIndent: 5,
                                        indent: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          fileModel.isFavFile == 1
                                              ? IconButton(
                                                  tooltip:
                                                      "Removing from Favourites",
                                                  icon: Icon(Icons.star),
                                                  onPressed: ()  {
                                                     readerController
                                                        .removeFavFileAt(
                                                            fileModel.fileName);
                                                    readerController.setFavFiles();
                                                    setState(() {
                                                      fileModel.isFavFile = 0;
                                                    });

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      duration: Duration(
                                                          milliseconds:                                                               NumberConstants.snackBarDurationInMilliseconds),
                                                      content: Text(
                                                          "Removed ${fileModel.fileName.replaceAll(".pdf", "")} from Favourites"),
                                                    ));
                                                  },
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                )
                                              : IconButton(
                                                  tooltip: "Add to Favourites",
                                                  icon: Icon(Icons
                                                      .star_border_outlined),
                                                  onPressed: ()  {
                                                    setState(() {
                                                      fileModel.isFavFile = 1;
                                                    });
                                                     readerController.addToFavFile(
                                                        fileModel);
                                                    readerController.setFavFiles();

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      duration: Duration(
                                                          milliseconds:                                                               NumberConstants.snackBarDurationInMilliseconds),
                                                      content: Text(
                                                          "Saved ${fileModel.fileName.replaceAll(".pdf", " ")} to Favourites"),
                                                    ));
                                                  },
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ),
                                          IconButton(
                                              tooltip:
                                                  "Remove from reading now",
                                              icon: Icon(Icons
                                                  .delete_outline_outlined),
                                              onPressed: ()  {
                                                 readerController
                                                    .removeRecentFileAt(
                                                        fileModel.fileID);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Removed ${fileModel.fileName}"),
                                                ));
                                              },
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color),
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                Icons.open_in_new,
                color: Colors.white,
              ),
              label: Text("Open Document",
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
