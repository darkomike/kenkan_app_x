import 'dart:io';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/helpers/app_functions.dart';
import 'package:kenkan_app_x/helpers/diction_functions.dart';
import 'package:kenkan_app_x/models/wordModel.dart';
import 'package:kenkan_app_x/reader_homepage.dart';
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

enum TtsState { playing, stopped, paused, continued }

class _SyncPDFViewerState extends State<SyncPDFViewer> {
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  bool isCurrentLanguageInstalled = false;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool stopVisibility = false;

  bool isPlayingIconOn = true;
  bool isPausedOn = false;
  bool isStoppedOn = false;

  initTts() {
    flutterTts = FlutterTts();

    flutterTts.setSpeechRate(prefs.getDouble("ReaderSpeechRate")!);
    debugPrint("From shared prefs ${prefs.getDouble("ReaderSpeechRate")}");

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
        stopVisibility = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
        isPlayingIconOn = true;
        stopVisibility = false;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continue");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _speak(String? word) async {
    if (word != null) {
      if (word.isNotEmpty) {
        setState(() async {
          stopVisibility = true;
          await flutterTts.awaitSpeakCompletion(true);
          await flutterTts.speak(word);
        });
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1)
      setState(() {
        isPlayingIconOn = true;
        ttsState = TtsState.stopped;
        stopVisibility = false;
      });
  }

  Future _pause() async {
    var result = await flutterTts.pause();

    if (result == 0) {
      setState(() {
        isPausedOn = true;
        ttsState = TtsState.paused;
      });
    }
  }

  Future _continue() async {
    flutterTts.continueHandler!();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
    initTts();
  }

  Future<void>? _launched;

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController? _pdfViewerController;

  OverlayEntry? _overlayEntry;

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context)!;

    _overlayEntry = OverlayEntry(
        opaque: false,
        builder: (context) => Positioned(
              top: details.globalSelectedRegion!.center.dy - 140,
              left: details.globalSelectedRegion!.shortestSide,
              // top: height / 2,
              // left: width / 4,

              child: Material(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: midNightBlueColor,
                      borderRadius: BorderRadius.circular(9)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: details.selectedText));
                          _pdfViewerController!.clearSelection();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(
                                milliseconds: NumberConstants
                                    .snackBarDurationInMilliseconds),
                            content: Text(
                                "\"${details.selectedText}\" is copied to clipboard"),
                          ));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: midNightBlueColor,
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                            "Copy",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   child: Container(
                      //     height: 5,
                      //     color: primaryColor,
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          print(details.selectedText);
                          WordModel? wordModel =
                              DictionFunctions.wordOfTheDayModel(
                                  DictionFunctions.transformStringWithOperators(
                                          details.selectedText!)
                                      .trim(), '', '');

                          print(wordModel.wordName);

                          if (wordModel.wordName == "wordName") {
                            showDialog(
                                // barrierColor: Theme.of(context).backgroundColor,
                                context: context,
                                builder: (context) => AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).backgroundColor,
                                      title: Text("Word Not Found",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      content: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  " \"${details.selectedText}\", ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                            TextSpan(
                                              text:
                                                  " can not be found in the dictionary. It will be added soon.",
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
                                                              details
                                                                  .selectedText!));
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
                                    builder: (_) => DictionWordDetails(
                                        wordModel: wordModel)));
                            _pdfViewerController!.clearSelection();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: midNightBlueColor,
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                            "Search Word",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _launched = AppFunctions.launchIn(LinkNames
                                    .toGoogle +
                                DictionFunctions.transformStringForGoogleSearch(
                                    details.selectedText!));
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: midNightBlueColor,
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                            "Web Search",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _speak(details.selectedText);
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: midNightBlueColor,
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                            "Read Aloud",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
    _overlayState.insert(_overlayEntry!);
  }

// -------------------------------------------------------------------------------------------------------------

  TextEditingController _controllerFindInDoc = TextEditingController();
  bool isBookTitleOn = true;
  PdfTextSearchResult? _pdfTextSearchResult;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);

    return Obx(() => Scaffold(
          extendBodyBehindAppBar: appStateController.showAppBar.value,
          extendBody: appStateController.showAppBar.value,
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          drawer:AppDrawer(),
          appBar:  AppBar(
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
                            _pdfTextSearchResult =
                                await _pdfViewerController!.searchText(
                              value.trim(),
                            );
                          },
                          onSubmitted: (value) async {
                            _pdfTextSearchResult = await _pdfViewerController!
                                .searchText(value.trim());
                          },
                          textInputAction: TextInputAction.search,
                        ),
                  actions: isBookTitleOn
                      ? [
                          PopupMenuButton(
                              onSelected: (value) {
                                switch (value) {
                                  case 1:
                                    _pdfViewerKey.currentState
                                        ?.openBookmarkView();
                                    break;

                                  case 2:
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
                                          leading: Icon(Icons.bookmark,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color),
                                          title: Text(
                                            "Bookmark",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                        )),
                                    PopupMenuItem(
                                        value: 2,
                                        child: ListTile(
                                          leading: Icon(Icons.find_in_page,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color),
                                          title: Text(
                                            "Find",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
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
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 15,
                              )),
                          IconButton(
                              onPressed: () {
                                _pdfTextSearchResult?.nextInstance();

                                setState(() {});
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isBookTitleOn = true;
                                  _controllerFindInDoc.clear();
                                  _pdfTextSearchResult?.clear();
                                });
                              },
                              icon: Icon(
                                Icons.clear,
                                size: 15,
                              ))
                        ],
                ),
          body: Stack(
            children: [
              Container(
                child: SfPdfViewerTheme(
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
                    onTextSelectionChanged:
                        (PdfTextSelectionChangedDetails details) {
                      if (details.selectedText == null &&
                          _overlayEntry != null) {
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
                    onDocumentLoadFailed:
                        (PdfDocumentLoadFailedDetails details) {
                      //TODO: On document failed func
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => ReaderHomepage()));
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("File Not Found",
                                    style: Theme.of(context).textTheme.caption),
                                content: Text(
                                  "Oops, " + name + " not found!",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        readerController.removeRecentFileAt(
                                            readerController
                                                .recentFiles.length);
                                        readerController.setRecentFiles();
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"))
                                ],
                              ));
                    },
                    canShowScrollStatus: true,
                    enableDocumentLinkAnnotation: true,
                    pageSpacing: 3,
                    onDocumentLoaded: (details){
                        
                    },
                  ),
                ),
              ),
              Visibility(
                  visible: stopVisibility,
                  child: Positioned(
                    bottom: 40,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                        
                        icon: Icon(
                          Icons.stop,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _stop();
                        },
                        
                      ),
                    ),
                  )),
            ],
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

// onVerticalDragUpdate: (details) {
//                   int sensitivity = 1;
//                   if (details.delta.dy > sensitivity) {
//                     appStateController.updateAppBarOnScrollDown();
//                     print("Moving Down");
//                   } else if (details.delta.dy < -sensitivity) {
//                     print("Moving Up");
//                     appStateController.updateAppBarOnScrollUp();
//                   }
//                 },