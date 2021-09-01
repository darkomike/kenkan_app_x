import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/helpers/diction_functions.dart';
import 'package:kenkan_app_x/models/wordModel.dart';
import 'package:kenkan_app_x/views/dictionary/dictionHomepage.dart';
import 'package:kenkan_app_x/views/dictionary/dictionWordDetails.dart';

class DictionFavourites extends StatefulWidget {
  DictionFavourites({Key? key}) : super(key: key);

  @override
  _DictionFavouritesState createState() => _DictionFavouritesState();
}

class _DictionFavouritesState extends State<DictionFavourites> {
  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DictionHomePage(),
        ));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Obx(() => Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0.0,
              title: Text("Favourites"),
              actions: [
                PopupMenuButton(
                    color: Theme.of(context).backgroundColor,
                    onSelected: (value) async {
                      switch (value) {
                        case 1:
                          dictionaryController.clearFavWORDs();
                          break;
                        default:
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry>[
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                title: Text("Clear Favourites",
                                    style:
                                        Theme.of(context).textTheme.headline3),
                              ))
                        ])
              ],
            ),
            body: Container(
                child: dictionaryController.favWORDs.length == 0
                    ? Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Icon(
                              Icons.bookmark_add_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: 200,
                            )),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                "No Favourites",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: dictionaryController.favWORDs.length,
                        itemBuilder: (context, index) {
                          WordModel wordModel =
                              dictionaryController.getFavWORDs[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "${DictionFunctions.capitalise(wordModel.wordName!)}",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    dictionaryController.removeFavWORD(
                                         wordModel.wordID!);
                                    dictionaryController.setFavWORDs();

                                    setState(() {});
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                                                backgroundColor: Theme.of(context).backgroundColor,

                                      duration: Duration(
                                          milliseconds: NumberConstants
                                              .snackBarDurationInMilliseconds),
                                      content: Text(
                                          "Removed ${wordModel.wordName} from Favourites", style: Theme.of(context).textTheme.headline2,),
                                    ));
                                  },
                                ),
                                onTap: ()  {
                                   dictionaryController.addWORD(wordModel);
                                   dictionaryController
                                      .addWordToHistory(wordModel.wordID!);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DictionWordDetails(
                                              wordModel: wordModel)));
                                },
                              ),
                              Divider(
                                height: 5,
                              )
                            ],
                          );
                        })),
          )),
    );
  }
}
