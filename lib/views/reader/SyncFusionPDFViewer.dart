import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/helpers/app_functions.dart';
import 'package:kenkan_app_x/helpers/diction_functions.dart';
import 'package:kenkan_app_x/models/wordModel.dart';
import 'package:kenkan_app_x/views/dictionary/dictionHomepage.dart';
import 'package:kenkan_app_x/views/dictionary/dictionWordDetails.dart';
import 'package:kenkan_app_x/views/notes/notesHomepage.dart';
import 'package:kenkan_app_x/widgets/app_drawer.dart';


import 'package:path/path.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../main.dart';


class SyncPDFViewer extends StatefulWidget {
  final File file;

  const SyncPDFViewer({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  _SyncPDFViewerState createState() => _SyncPDFViewerState();
}

class _SyncPDFViewerState extends State<SyncPDFViewer> {
  Future<void>? _launched;

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController? _pdfViewerController;


  TextEditingController _searchWordController = new TextEditingController();

  String? _newVoiceText;



  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  OverlayEntry? _overlayEntry;

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context)!;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    _overlayEntry = OverlayEntry(
      opaque: false,
      builder: (context) =>   Obx (() => Positioned(
            top: details.globalSelectedRegion!.center.dy - 55,
            left: details.globalSelectedRegion!.shortestSide,
            // top: height / 2,
            // left: width / 4,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).backgroundColor),
                  ),
                  child: Icon(
                    Icons.copy,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: details.selectedText));
                    _pdfViewerController!.clearSelection();
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).backgroundColor),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    print(details.selectedText);
                    WordModel? wordModel =
                        DictionFunctions.wordOfTheDayModel(details.selectedText);

                    print(wordModel.wordName);

                    if (wordModel.wordName == "wordName") {
                      showDialog(
                          // barrierColor: Theme.of(context).backgroundColor,
                          context: context,
                          builder: (context) => AlertDialog(
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
                                title: Text("Word Not Found",
                                    style: Theme.of(context).textTheme.caption),
                                content: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            " \" ${details.selectedText} \", ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      TextSpan(
                                        text:
                                            "can not be found in the dictionary.It will be added soon.\u200d",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK")),
                                  TextButton(
                                      onPressed: () {
                                        _launched = AppFunctions.launchIn(
                                            LinkNames.toGoogle +
                                                DictionFunctions
                                                    .transformStringForGoogleSearch(
                                                        details.selectedText!));
                                      },
                                      child: Text("TRY GOOGLE SEARCH"))
                                ],
                              ));
                      _pdfViewerController!.clearSelection();
                    } else {
                      dictionaryController.addWordToHistory(wordModel);
                      dictionaryController.setRecentWORDs();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  DictionWordDetails(wordModel: wordModel)));
                      _pdfViewerController!.clearSelection();
                    }
                    _pdfViewerController!.clearSelection();
                  },
                ),
                TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).backgroundColor),
                    ),
                    onPressed: () => setState(() {
                          _launched = AppFunctions.launchIn(LinkNames
                                  .toGoogle +
                              DictionFunctions.transformStringForGoogleSearch(
                                  details.selectedText!));
                        }),
                    child: SvgPicture.asset(
                      "assets/icons/google.svg",
                      height: 20,
                    ))
              ],
            ),
          ))

    );
    _overlayState.insert(_overlayEntry!);
  }

// -------------------------------------------------------------------------------------------------------------

  TextEditingController _controllerFindInDoc = TextEditingController();
  bool isBookTitleOn = true;
  PdfTextSearchResult? _pdfTextSearchResult;

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);


    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,

        drawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.0,
          title: isBookTitleOn
              ? Text(
                  "${name.replaceAll(".pdf", " ")}",
                  style: Theme.of(context).textTheme.headline3,
                )
              : TextField(
                  controller: _controllerFindInDoc,
                  autofocus: true,
                  cursorColor: Theme.of(context).iconTheme.color,
                  style: Theme.of(context).textTheme.headline3,
                  decoration: InputDecoration(
                      hintText: "Find word in document...",
                      hintStyle: Theme.of(context).textTheme.headline2,
                      border: InputBorder.none),
                  onChanged: (value) async {
                  _pdfTextSearchResult = await  _pdfViewerController!.searchText(
                      value.trim(),
                    );
                  },
                  onSubmitted: (value) async {
                  _pdfTextSearchResult = await   _pdfViewerController!.searchText(value.trim());
                  },
                  textInputAction: TextInputAction.search,
                ),
          actions: isBookTitleOn
              ? <Widget>[
                  PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DictionHomePage()));
                            break;
                          case 2:
                            _pdfViewerKey.currentState?.openBookmarkView();
                            break;

                          case 3:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => NotesHomepage()));
                            break;
                          case 4:
                            setState(() {
                              isBookTitleOn = false;
                            });
                            break;
                        }
                      },
                      color: Theme.of(context).backgroundColor,
                      itemBuilder: (context) => <PopupMenuEntry>[
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  leading: Icon(Icons.book_outlined,
                                      color: Theme.of(context).iconTheme.color),
                                  title: Text(
                                    "Dictionary",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                )),
                            PopupMenuItem(
                                value: 2,
                                child: ListTile(
                                  leading: Icon(Icons.bookmark,
                                      color: Theme.of(context).iconTheme.color),
                                  title: Text(
                                    "Bookmark",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                )),
                            PopupMenuItem(
                                value: 3,
                                child: ListTile(
                                  leading: Icon(Icons.notes,
                                      color: Theme.of(context).iconTheme.color),
                                  title: Text(
                                    "Notes",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                )),
                            PopupMenuItem(
                                value: 4,
                                child: ListTile(
                                  leading: Icon(Icons.find_in_page,
                                      color: Theme.of(context).iconTheme.color),
                                  title: Text(
                                    "Find",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                )),
                          ]),
                ]
              : [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _pdfTextSearchResult?.previousInstance();

                        });
                      },
                      icon: Icon(Icons.arrow_back_ios)),
            IconButton(
                      onPressed: () {
                        _pdfTextSearchResult?.nextInstance();

                        setState(() {
                        });
              },
                      icon: Icon(Icons.arrow_forward_ios)),
            IconButton(
                      onPressed: () {
                        setState(() {
                          isBookTitleOn = true;
                          _controllerFindInDoc.clear();
                          _pdfTextSearchResult?.clear();
                        });
                      },
                      icon: Icon(Icons.clear))
                ],
        ),
        body: SfPdfViewerTheme(
          data: SfPdfViewerThemeData(
              brightness: prefs.getBool("isDarkModeOn") == true
                  ? Brightness.dark
                  : Brightness.light
              // backgroundColor: Theme.of(context).backgroundColor,

              ),
          child: SfPdfViewer.file(
            widget.file,
            key: _pdfViewerKey,
            canShowScrollHead: true,
            onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
              if (details.selectedText == null && _overlayEntry != null) {
                _overlayEntry!.remove();
                _overlayEntry = null;
              } else if (details.selectedText != null &&
                  _overlayEntry == null) {
                _showContextMenu(context, details);
              }

            },
            controller: _pdfViewerController,
            enableDoubleTapZooming: true,
            enableTextSelection: true,
            canShowPaginationDialog: true,
            searchTextHighlightColor: primaryColor,
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              //TODO: On document failed func

              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("File Not Found",
                            style: Theme.of(context).textTheme.caption),
                        content: Text(
                          "Oops" + name + " not found!",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"))
                        ],
                      ));
            },
            canShowScrollStatus: true,
            enableDocumentLinkAnnotation: true,
            pageSpacing: 5,
          ),
        ));
  }
}

// showModalBottomSheet(
//
// context: context,
// builder:(context) {
// return Container(
// padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// height: height/6,
// child: Column(
// children: [
// Text("data"),
// TextField(
// controller: _controllerFindInDoc,
// )
// ],
// ),
// );
// },
// isDismissible: true,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.only(
//
// topLeft: Radius.circular(30),
// topRight: Radius.circular(30),
//
// ))
// );
