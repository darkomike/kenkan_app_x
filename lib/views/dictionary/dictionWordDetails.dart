import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/names.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/helpers/app_functions.dart';
import 'package:kenkan_app_x/helpers/diction_functions.dart';
import 'package:kenkan_app_x/models/wordModel.dart';
import 'package:kenkan_app_x/views/dictionary/dictionFavourites.dart';
import 'package:kenkan_app_x/views/dictionary/dictionHistory.dart';
import 'package:kenkan_app_x/views/dictionary/dictionSearch.dart';



import '../../main.dart';
import '../settingsScreen.dart';

class DictionWordDetails extends StatefulWidget {
  WordModel wordModel;
  DictionWordDetails({
    Key? key,
    required this.wordModel,
  }) : super(key: key);

  @override
  _DictionWordDetailsState createState() => _DictionWordDetailsState();
}

enum TtsState { playing, stopped, paused, continued }

class _DictionWordDetailsState extends State<DictionWordDetails> {
  Future<void>? _launched;

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

  bool isPlayingIconOn = true;
  bool isPausedOn = false;
  bool isStoppedOn = false;

  // WordModel? wordModel;

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    // flutterTts.setSpeechRate(prefs.getDouble("ReaderSpeechRate")!);
    // debugPrint("From shared prefs ${prefs.getDouble("ReaderSpeechRate")}");

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
        isPlayingIconOn = true;
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
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(word);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1)
      setState(() {
        isPlayingIconOn = true;
        ttsState = TtsState.stopped;
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
  Widget build(BuildContext context) {
  
   WordModel  wordModel = widget.wordModel;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => DictionSearch()));
        },
        splashColor: Colors.red,
        tooltip: "Search Word",
        backgroundColor: Colors.green[800],
        elevation: 20,
        child: Icon(
          Icons.search,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.9,
        actions: [
          PopupMenuButton(
              color: Theme.of(context).backgroundColor,
              onSelected: (value) {
                switch (value) {
                  case 1:
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => DictionFavourites()));
                    break;
                  case 2:
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => DictionHistory()));
                    break;
                  case 3:
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => SettingsScreen()));
                    break;
                  default:
                }
              },
              itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          leading: Icon(
                            Icons.favorite,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: Text(
                            "Favourites",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        )),
                    PopupMenuItem(
                        value: 2,
                        child: ListTile(
                          leading: Icon(
                            Icons.history,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: Text("${LocalSave.recent}",
                              style: Theme.of(context).textTheme.headline2),
                        )),
                    PopupMenuItem(
                        value: 3,
                        child: ListTile(
                          leading: Icon(
                            Icons.settings,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: Text("Settings",
                              style: Theme.of(context).textTheme.headline2),
                        ))
                  ]),
          SizedBox(
            width: 10,
          ),
        ],
        title: Text(
          "${DictionFunctions.capitalise(widget.wordModel.wordName)} ",
        ),
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: Stack(
          children: [
            Container(
              color: Colors.black12,
              width: width,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _speak(widget.wordModel.wordName);
                    },
                    child: Chip(
                      avatar: Icon(
                        Icons.volume_down_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      backgroundColor: Theme.of(context).backgroundColor,
                      elevation: 10,
                      deleteButtonTooltipMessage:
                          "Pronounce ${widget.wordModel.wordName}",
                      label: Text("${widget.wordModel.wordName.toLowerCase()}",
                          style: Theme.of(context).textTheme.headline3),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              child: Container(
                // height: 50,
                // padding: EdgeInsets.all(5),
                width: width,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          "Definition: ",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        )),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        child: Wrap(
                          clipBehavior: Clip.antiAlias,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          spacing: 0,
                          runAlignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          runSpacing: 0.0,
                          children: searchWordInDefinition(
                              "${widget.wordModel.wordDefinition}")

                          // Text(
                          //   "${widget.wordModel!.wordDefinition}",
                          //   style: Theme.of(context).textTheme.headline3,
                          // ),

                          ,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
              top: 110,
              bottom: height / 45,
            ),
            Positioned(
              top: 60,
              left: width / 25,
              child: Container(
                child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedContainer(
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,
                          duration: Duration(),
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: widget.wordModel.isFav == 1
                              ? IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      widget.wordModel.isFav = 0;
                                    });
                                    await dictionaryController.removeFavWORD(widget.wordModel,
                                        widget.wordModel.wordName);

                                    showFavAdded(context,
                                        "${DictionFunctions.capitalise(widget.wordModel.wordName)} is removed from favourites");

                                    print(
                                        "${widget.wordModel.wordName} is removed from favourites");
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  tooltip: "Remove from Favourites",
                                )
                              : IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      widget.wordModel.isFav = 1;
                                    });
                                     dictionaryController.addFavWORD(widget.wordModel);

                                    showFavAdded(context,
                                        "${DictionFunctions.capitalise(widget.wordModel.wordName)} is added to favourites");

                                    print(
                                        "${widget.wordModel} is added to favourite");
                                  },
                                  icon: Icon(
                                    Icons.favorite_border_outlined,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  tooltip: "Add to Favourites",
                                ),
                        ),
                        SizedBox(
                          width: width / 2 + 70,
                        ),
                        AnimatedContainer(
                            alignment: Alignment.center,
                            height: isPlayingIconOn ? 40 : 42,
                            width: isPlayingIconOn ? 40 : 42,
                            duration: Duration(milliseconds: 50),
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: isPlayingIconOn
                                    ? BorderRadius.circular(20)
                                    : BorderRadius.circular(10)),
                            child: isPlayingIconOn
                                ? IconButton(
                                    tooltip: "Read word meaning",
                                    onPressed: () {
                                      _speak(widget.wordModel.wordName +
                                          ", Definition, " +
                                          widget.wordModel.wordDefinition);
                                      setState(() {
                                        isPlayingIconOn = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.play_circle,
                                      color: Colors.green,
                                    ))
                                : IconButton(
                                    onPressed: () {
                                      _stop();
                                      setState(() {
                                        isPlayingIconOn = true;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.stop,
                                      color: Colors.red,
                                    ))),

                        SizedBox(
                          width: 10,
                        ),
                      ],
                    )
              
                
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFavAdded(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration:
          Duration(milliseconds: NumberConstants.snackBarDurationInMilliseconds),
      content: Text(message!),
    ));
  }

  searchWordInDefinition(String word) {
    List<TextButton> wordTransformed = word
        .split(" ")
        .map((String text) => TextButton(
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size.zero),
                textStyle: MaterialStateProperty.all<TextStyle>(
                    Theme.of(context).textTheme.headline2!),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 0, horizontal: 0))),
            onPressed: () {
              WordModel? model = DictionFunctions.wordOfTheDayModel(text);
              if (model.wordName == "wordName") {
                showDialog(
                    // barrierColor: Theme.of(context).backgroundColor,
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Theme.of(context).backgroundColor,
                          title: Text("Word Not Found",
                              style: Theme.of(context).textTheme.caption),
                          content: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: " \" $text\", ",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                TextSpan(
                                  text:
                                      "can not be found in the dictionary.It will be added soon.\u200d",
                                  style: Theme.of(context).textTheme.headline2,
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
                                                  model.wordName));
                                },
                                child: Text("TRY GOOGLE SEARCH"))
                          ],
                        ));
              } else {
                dictionaryController.addWordToHistory(model);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => DictionWordDetails(wordModel: model)));

                setState(() {
                  widget.wordModel = model;
                });
              }
            },
            child: Text(
              text.trim(),
              style: Theme.of(context).textTheme.headline2,
            )))
        .toList();

    return wordTransformed;
  }
}
