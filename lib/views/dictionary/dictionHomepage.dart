import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/names.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/helpers/app_functions.dart';
import 'package:kenkan_app_x/helpers/diction_functions.dart';
import 'package:kenkan_app_x/main.dart';
import 'package:kenkan_app_x/models/wordModel.dart';
import 'package:kenkan_app_x/reader_homepage.dart';
import 'package:kenkan_app_x/views/dictionary/dictionFavourites.dart';
import 'package:kenkan_app_x/views/dictionary/dictionHistory.dart';
import 'package:kenkan_app_x/views/dictionary/dictionSearch.dart';
import 'package:kenkan_app_x/views/dictionary/dictionWordDetails.dart';
import 'package:kenkan_app_x/widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DictionHomePage extends StatefulWidget {
  DictionHomePage({Key? key}) : super(key: key);

  @override
  _DictionHomePageState createState() => _DictionHomePageState();
}

class _DictionHomePageState extends State<DictionHomePage>
    with SingleTickerProviderStateMixin {
  WordModel randomWordButtonFunc() {
    int wordCategory = DictionFunctions.generateRandom(1, 27);
    List<String> dictions =
        DictionFunctions.getRandomWordCategory(wordCategory);

    int dictionsTotal = dictions.length;
    int wordSelectedIndex =
        DictionFunctions.generateRandom(1, dictionsTotal + 1);
    String choosenWord = dictions.elementAt(wordSelectedIndex);
    print(choosenWord);
    randomWordModel = DictionFunctions.randomSearch(choosenWord);

    return randomWordModel!;
  }

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReaderHomepage(),
        ));
    return true;
  }

  WordModel? randomWordModel;
  WordModel? wordModel;

  String? _formattedDay;
  String? _formattedDate;

  String? string = prefs.getString("${LocalSave.wordForTheDay}");

  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    DateTime now = DateTime.now();
    _formattedDay = DateFormat(DateFormat.WEEKDAY).format(now);
    _formattedDate = DateFormat(DateFormat.YEAR_MONTH_DAY).format(now);

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.easeInOutQuint));
    _animationController!.forward();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            title: Text(
              "Dictionary",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  AnimatedBuilder(
                      animation: _animation!,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.translationValues(
                              -_animation!.value * width, 0, 0),
                          child: ListTile(
                            leading: Icon(
                              Icons.search,
                              color: Theme.of(context).iconTheme.color,
                              size: Theme.of(context).iconTheme.size,
                            ),
                            title: Text("Search Word",
                                style: Theme.of(context).textTheme.headline3),
                            onTap: () {
                              Navigator.pushReplacement(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (_) => DictionSearch()));
                            },
                          ),
                        );
                      }),
                  AnimatedBuilder(
                      animation: _animation!,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.translationValues(
                              _animation!.value * width, 0, 0),
                          child: ListTile(
                            leading: Icon(
                              Icons.shuffle,
                              color: Theme.of(context).iconTheme.color,
                              size: Theme.of(context).iconTheme.size,
                            ),
                            title: Text("Random Word",
                                style: Theme.of(context).textTheme.headline3),
                            onTap: () async {
                              WordModel randWordModel = randomWordButtonFunc();
                              // LocalSave.prefs!.setString(
                              //     "${Constants.wordForTheDay}",
                              //     randomWordModel!.wordName);

                              if (await dictionaryController
                                      .isFavWord(randWordModel) ==
                                  1) {
                                randomWordModel!.isFav = 1;
                              } else {
                                randomWordModel!.isFav = 0;
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DictionWordDetails(
                                          wordModel: randomWordModel!)));

                              dictionaryController
                                  .addWordToHistory(randomWordModel!);
                            },
                          ),
                        );
                      }),
                  AnimatedBuilder(
                      animation: _animation!,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.translationValues(
                              -_animation!.value * width, 0, 0),
                          child: ListTile(
                            leading: Icon(
                              Icons.bookmark,
                              color: Theme.of(context).iconTheme.color,
                              size: Theme.of(context).iconTheme.size,
                            ),
                            title: Text("Favourites",
                                style: Theme.of(context).textTheme.headline3),
                            onTap: () {
                              Navigator.push(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (_) => DictionFavourites()));
                            },
                          ),
                        );
                      }),
                  AnimatedBuilder(
                      animation: _animation!,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.translationValues(
                              _animation!.value * width, 0, 0),
                          child: ListTile(
                            leading: Icon(
                              Icons.history,
                              color: Theme.of(context).iconTheme.color,
                              size: Theme.of(context).iconTheme.size,
                            ),
                            title: Text("Recent",
                                style: Theme.of(context).textTheme.headline3),
                            onTap: () {
                              Navigator.push(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (_) => DictionHistory()));
                            },
                          ),
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  AnimatedBuilder(
                      animation: _animation!,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.translationValues(
                              -_animation!.value * height, 0, 0),
                          child:  GestureDetector(
                            onTap: () async {
                              if (await dictionaryController
                                      .isFavWord(dictionaryController.wordForTheDay.value) ==
                                  1) {
                                dictionaryController.wordForTheDay.value.isFav = 1;
                              } else {
                                dictionaryController.wordForTheDay.value.isFav = 0;
                              }
                              dictionaryController.addWordToHistory(dictionaryController.wordForTheDay.value);
                              print('added to history');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DictionWordDetails(
                                          wordModel: dictionaryController.wordForTheDay.value)));
                            },
                            child: Container(
                              height: height / 2,
                              width: width / 1.05,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Card(
                                color: Theme.of(context).backgroundColor,
                                elevation: 10,
                                shadowColor: Colors.indigo,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  color: Theme.of(context).backgroundColor,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "WORD OF THE DAY",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      Divider(
                                        height: 5,
                                      ),
                                     Obx(() => Text(
                                        "${dictionaryController.wordForTheDay.value.wordName}",
                                        style:
                                            Theme.of(context).textTheme.caption,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: width / 1.09,
                                        height: height / 3.55,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            // gradient: LinearGradient(
                                            //     tileMode: TileMode.decal,
                                            // colors: [ Theme.of(context).backgroundColor]),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Theme.of(context)
                                                .backgroundColor),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                          Obx(() => Text(
                                              "${dictionaryController.wordForTheDay.value.wordDefinition}",
                                              // overflow: TextOverflow.ellipsis,

                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            )),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "${dictionaryController.wordForTheDay.value.day}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      Divider(
                                        height: 3,
                                        endIndent: 90,
                                        indent: 90,
                                      ),
                                      Text(
                                        "${dictionaryController.wordForTheDay.value.date!}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
