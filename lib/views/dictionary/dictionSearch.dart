import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/db/diction_db/a.dart';
import 'package:kenkan_app_x/db/diction_db/b.dart';
import 'package:kenkan_app_x/db/diction_db/c.dart';
import 'package:kenkan_app_x/db/diction_db/d.dart';
import 'package:kenkan_app_x/db/diction_db/e.dart';
import 'package:kenkan_app_x/db/diction_db/f.dart';
import 'package:kenkan_app_x/db/diction_db/g.dart';
import 'package:kenkan_app_x/db/diction_db/h.dart';
import 'package:kenkan_app_x/db/diction_db/i.dart';
import 'package:kenkan_app_x/db/diction_db/j.dart';
import 'package:kenkan_app_x/db/diction_db/k.dart';
import 'package:kenkan_app_x/db/diction_db/l.dart';
import 'package:kenkan_app_x/db/diction_db/m.dart';
import 'package:kenkan_app_x/db/diction_db/n.dart';
import 'package:kenkan_app_x/db/diction_db/o.dart';
import 'package:kenkan_app_x/db/diction_db/p.dart';
import 'package:kenkan_app_x/db/diction_db/q.dart';
import 'package:kenkan_app_x/db/diction_db/r.dart';
import 'package:kenkan_app_x/db/diction_db/u.dart';
import 'package:kenkan_app_x/db/diction_db/s.dart';
import 'package:kenkan_app_x/db/diction_db/t.dart';
import 'package:kenkan_app_x/db/diction_db/v.dart';
import 'package:kenkan_app_x/db/diction_db/w.dart';
import 'package:kenkan_app_x/db/diction_db/x.dart';
import 'package:kenkan_app_x/db/diction_db/y.dart';
import 'package:kenkan_app_x/db/diction_db/z.dart';
import 'package:kenkan_app_x/helpers/app_functions.dart';
import 'package:kenkan_app_x/helpers/diction_functions.dart';
import 'package:kenkan_app_x/models/wordModel.dart';
import 'package:kenkan_app_x/views/dictionary/dictionWordDetails.dart';

import 'dictionHomepage.dart';

class DictionSearch extends StatefulWidget {
  const DictionSearch({Key? key}) : super(key: key);

  @override
  _DictionSearchState createState() => _DictionSearchState();
}

class _DictionSearchState extends State<DictionSearch>
    with SingleTickerProviderStateMixin {
  Future<void>? _launched;

  List<dynamic> _words = [];

  String message = 'Start typing to search word...';

  TextEditingController _searchDictionController = TextEditingController();

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
    double width = MediaQuery.of(context).size.width;

    String assetName = 'assets/icons/google.svg';
    Widget svgGoogleIcon =
        SvgPicture.asset(assetName, semanticsLabel: "Google Icon", height: 20);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          tooltip: "Search on Google",
          onPressed: () {
            setState(() {
              _launched = AppFunctions.launchIn(LinkNames.toGoogle +
                  DictionFunctions.transformStringForGoogleSearch(
                      _searchDictionController.text));
            });
          },
          label: Text("Search"),
          backgroundColor: Colors.green[800],
          icon: svgGoogleIcon,
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            // height:40,
            width: 600,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(20),
              // border: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))
            ),
            child: TextField(
              controller: _searchDictionController,
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(
                  suffix: IconButton(
                    iconSize: 20,
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _searchDictionController.clear();

                      setState(() {
                        message = 'Start typing to search word...';
                        _words = [];
                      });
                    },
                  ),
                  hintText: "Search word ...",
                  hintStyle: TextStyle(color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  focusColor: Colors.green[500]),
              style: TextStyle(fontSize: 18, color: Colors.black),
              cursorHeight: 18,
              cursorWidth: 1,
              cursorColor: Colors.black,
              onChanged: (String value) {
                setState(() {
                  if (value.isEmpty) {
                    // _searchDictionController.clear();
                    _words = [];
                  }
                  switch (value.toUpperCase()[0].trim()) {
                    case "A":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryA.categoryA);
                      break;
                    case "B":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryB.categoryB);
                      break;
                    case "C":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryC.categoryC);
                      break;
                    case "D":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryD.categoryD);
                      break;
                    case "E":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryE.categoryE);
                      break;
                    case "F":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryF.categoryF);
                      break;
                    case "G":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryG.categoryG);
                      break;
                    case "H":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryH.categoryH);
                      break;
                    case "I":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryI.categoryI);
                      break;
                    case "J":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryJ.categoryJ);
                      break;
                    case "K":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryK.categoryK);
                      break;
                    case "L":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryL.categoryL);
                      break;
                    case "M":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryM.categoryM);
                      break;
                    case "N":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryN.categoryN);
                      break;
                    case "O":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryO.categoryO);
                      break;
                    case "P":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryP.categoryP);
                      break;
                    case "Q":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryQ.categoryQ);
                      break;
                    case "R":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryR.categoryR);
                      break;
                    case "S":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryS.categoryS);
                      break;
                    case "T":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryT.categoryT);
                      break;
                    case "U":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryU.categoryU);
                      break;
                    case "V":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryV.categoryV);
                      break;
                    case "W":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryW.categoryW);
                      break;
                    case "X":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryX.categoryX);
                      break;
                    case "Y":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryY.categoryY);
                      break;
                    case "Z":
                      _words = DictionFunctions.searchMany(
                          value.trim(), CategoryZ.categoryZ);
                      break;

                    default:
                      _words = [];
                      break;
                  }
                });
              },
              textInputAction: TextInputAction.search,
              onSubmitted: (String value) {
                print("Submitted");
              },
            ),
          ),
        ),
        body: _words.length == 0
            ? Container(
                child: Center(
                    child: Text(
                  message,
                  style: Theme.of(context).textTheme.headline3,
                )),
              )
            : Container(
                child: ListView.separated(
                    separatorBuilder: (context, child) => Divider(
                          height: 2,
                        ),
                    shrinkWrap: true,
                    reverse: false,
                    physics:
                        ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: _words.length == 0 ? 0 : _words.length,
                    itemBuilder: (BuildContext context, int index) {
                      WordModel wordModel = WordModel.fromMap(_words[index]);

                      return ListTile(
                        title: Text(
                          "${wordModel.wordName!.toLowerCase()}",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        onTap: ()  {
                          dictionaryController.addWORD(wordModel);
                          dictionaryController
                              .addWordToHistory(wordModel.wordID!);
                          print('added to history');
                          Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (_) => DictionWordDetails(
                                        wordModel: wordModel,
                                      )));
                        },
                      );
                    }),
              ),
      ),
    );
  }
}
