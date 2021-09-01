import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/names.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/helpers/diction_functions.dart';
import 'package:kenkan_app_x/models/wordModel.dart';
import 'package:kenkan_app_x/views/dictionary/dictionHomepage.dart';
import 'package:kenkan_app_x/views/dictionary/dictionWordDetails.dart';

class DictionHistory extends StatefulWidget {
  DictionHistory({Key? key}) : super(key: key);

  @override
  _DictionHistoryState createState() => _DictionHistoryState();
}

class _DictionHistoryState extends State<DictionHistory> {
  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DictionHomePage(),
        ));
    return true;
  }

  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Obx(() => Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0.0,
              title: Text("${LocalSave.recent}"),
              actions: [
                PopupMenuButton(
                    color: Theme.of(context).backgroundColor,
                    onSelected: (value) async {
                      switch (value) {
                        case 1:
                          await dictionaryController.clearHistory();
                          break;
                        default:
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry>[
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                title: Text("Clear ${LocalSave.recent}",
                                    style:
                                        Theme.of(context).textTheme.headline3),
                              ))
                        ])
              ],
            ),
            body: Container(
                child: dictionaryController.recentWORDs.length == 0
                    ? Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Icon(
                              Icons.timelapse_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: 200,
                            )),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                "No Recent",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: (_, __) => Divider(
                              height: 0.5,
                            ),
                        itemCount: dictionaryController.recentWORDs.length,
                        itemBuilder: (context, index) {
                          WordModel wordModel =
                              dictionaryController.getHistory[index];
                          return Dismissible(
                            child: ListTile(
                              title: Text(
                                "${DictionFunctions.capitalise(wordModel.wordName!)}",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              onTap: () async {
                                if ( dictionaryController
                                        .isFavWord(wordModel.wordID!) ==
                                    true) {
                                } else {}
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DictionWordDetails(
                                            wordModel: wordModel)));
                              },
                            ),
                            key: Key(wordModel.wordName!),
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                await dictionaryController.removeHistory(
                                    wordModel, wordModel.wordName!);
                              } else {
                                await dictionaryController
                                    .addFavWORD(wordModel.wordID!);
                              }
                            },
                            secondaryBackground: slideLeftBackground(),
                            background: slideRightBackground(),
                            movementDuration: Duration(milliseconds: 1000),
                            confirmDismiss: (direction) async {
                              bool? res;
                              if (direction == DismissDirection.endToStart) {
                                res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            Theme.of(context).backgroundColor,
                                        content: Text(
                                            "Are you sure you want to delete ${DictionFunctions.capitalise(wordModel.wordName!)}?",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              dictionaryController
                                                  .removeHistory(wordModel,
                                                      wordModel.wordID!);
                                              dictionaryController
                                                  .setRecentWORDs();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                                          backgroundColor: Theme.of(context).backgroundColor,

                                                duration: Duration(
                                                    milliseconds: NumberConstants
                                                        .snackBarDurationInMilliseconds),
                                                content: Text(
                                                    "\"${wordModel.wordName!.capitalize}\" is deleted from recent", style: Theme.of(context).textTheme.headline2,),
                                              ));
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              } else {
                                // TODO: Navigate to edit page;
                                res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            Theme.of(context).backgroundColor,
                                        content: Text(
                                          "Are you sure you want to save ${DictionFunctions.capitalise(wordModel.wordName!)}?",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            onPressed: () async {
                                              // TODO: Save the item to DB etc..
                                              await dictionaryController
                                                  .addFavWORD(
                                                      wordModel.wordID!);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                duration: Duration(
                                                    milliseconds: NumberConstants
                                                        .snackBarDurationInMilliseconds),
                                                content: Text(
                                                    "\"${wordModel.wordName!.capitalize}\" is saved to favourites"),
                                              ));
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });

                                return res;
                              }
                              return res;
                            },
                          );
                        })),
          )),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.star,
              color: Colors.white,
            ),
            Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
