import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenkan_app_x/constants/names.dart';
import 'package:kenkan_app_x/db/diction_db/database.dart';
import 'package:kenkan_app_x/helpers/diction_functions.dart';
import 'package:kenkan_app_x/main.dart';
import 'package:kenkan_app_x/models/wordModel.dart';

class DictionaryController extends GetxController {
  static DictionaryController instance = Get.find();

//instance variables
  var favWORDs = [].obs;
  var recentWORDs = [].obs;
  var wordsOfTheDay = [].obs;
  var wordForTheDay = WordModel(
          wordName: "CABALIST",
          wordDefinition:
              "One versed in the cabala, or the mysteries of Jewishtraditions. \"Studious cabalists.\" Swift.",
          isFav: 0,
          day: "${DateFormat(DateFormat.WEEKDAY).format(DateTime.now())}",
          date:
              "${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}")
      .obs;

//getters
  get getFavWORDs => favWORDs.reversed.toList();
  get getHistory => recentWORDs.reversed.toList();
  get getWordsOfTheDay => wordsOfTheDay.reversed.toList();

//setters
  setFavWORDs() async {
    this.favWORDs.value = await AppDatabase.db.getAllFavWORDs();
  }

  setRecentWORDs() async {
    this.recentWORDs.value = await AppDatabase.db.getAllRecentWORDs();
  }

  setWordsOfTheDay() async {
    this.wordsOfTheDay.value = await AppDatabase.db.getAllWORDSOfTheDay();
  }

// //methods
//   void updateWordForDay()  {
//     DateTime now = DateTime.now();
//     String day = DateFormat(DateFormat.WEEKDAY).format(now);
//     String date = DateFormat(DateFormat.YEAR_MONTH_DAY).format(now);
//     int wordCategory = DictionFunctions.generateRandom(1, 27);
//     List<String> dictions =
//         DictionFunctions.getRandomWordCategory(wordCategory);

//     int dictionsTotal = dictions.length;
//     int wordSelectedIndex =
//         DictionFunctions.generateRandom(1, dictionsTotal + 1);
//     String choosenWord = dictions.elementAt(wordSelectedIndex);
//     print(choosenWord);
//     WordModel wordModel =
//         DictionFunctions.wordOfTheDayModel(choosenWord, date, day);
//             print("New Word Of The Day Created and Added to the Word Of the day table: $wordModel");

//     addWordOfTheDay(wordModel);
//     setWordsOfTheDay();
//     print("$getWordsOfTheDay");
//     if (!getWordsOfTheDay.isEmpty) {
//       wordForTheDay = getWordsOfTheDay[0];
//     }

//     // wordForTheDay.value =
//     //     DictionFunctions.wordOfTheDayModel();
//   }

  // Future addWordOfTheDay(WordModel wordModel) async {
  //   bool check = false;

  //   favWORDs.forEach((element) {
  //     if (element.wordName == wordModel.wordName) {
  //       check = true;
  //     }
  //   });

  //   if (check == false) {
  //      AppDatabase.db.addWordOfTheDay(wordModel);
  //     setWordsOfTheDay();
  //     print(wordsOfTheDay);
  //   }
  // }

  Future addFavWORD(WordModel wordModel) async {
    bool check = false;

    favWORDs.forEach((element) {
      if (element.wordName == wordModel.wordName) {
        check = true;
      }
    });

    if (check == false) {
      await AppDatabase.db.addFavWORD(wordModel);
      setFavWORDs();
      print(favWORDs);
    }
  }

  Future<int> isFavWord(WordModel wordModel) async {
    setFavWORDs();
    int check = 0;

    favWORDs.forEach((element) {
      if (element.wordName == wordModel.wordName) {
        check = 1;
      }
    });

    return check;
  }

  Future removeFavWORD(WordModel wordModel, String wordToRemove) async {
    await AppDatabase.db.removeFavWORDAt(wordToRemove);
    setFavWORDs();
  }

  Future clearFavWORDs() async {
    await AppDatabase.db.removeAllFavWORDs();
    setFavWORDs();
  }

  Future addWordToHistory(WordModel wordModel) async {
    bool check = false;

    recentWORDs.forEach((element) {
      if (element.wordName == wordModel.wordName) {
        check = true;
      }
    });

    if (check == false) {
      // history.add(wordModel);
      await AppDatabase.db.addRecentWORDToDB(wordModel);
      setRecentWORDs();
    }
  }

  Future removeHistory(WordModel? wordModel, String wordToRemove) async {
    await AppDatabase.db.removeRecentWORDAt(wordToRemove);
    setRecentWORDs();
  }

  Future clearHistory() async {
    // history.clear();
    await AppDatabase.db.removeAllRecentWORDs();
    setRecentWORDs();
  }
}
