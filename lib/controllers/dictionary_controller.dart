import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenkan_app_x/db/diction_db/database.dart';

import 'package:kenkan_app_x/models/wordModel.dart';

class DictionaryController extends GetxController {
  static DictionaryController instance = Get.find();

//instance variables
  var favWORDs = [].obs;
  var recentWORDs = [].obs;
  var wordsOfTheDay = [].obs;
  var words = [].obs;
  var wordForTheDay = WordModel(
          wordName: "CABALIST",
          wordDefinition:
              "One versed in the cabala, or the mysteries of Jewishtraditions. \"Studious cabalists.\" Swift.",
          wordID: "cabalist_id",
          wordDay: "${DateFormat(DateFormat.WEEKDAY).format(DateTime.now())}",
          wordDate:
              "${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}")
      .obs;

//getters
  get getFavWORDs => favWORDs.reversed.toList();
  get getHistory => recentWORDs.reversed.toList();
  get getWordsOfTheDay => wordsOfTheDay.reversed.toList();
  get getWords => words.reversed.toList();

//setters
  setFavWORDs() async {
    this.favWORDs.value = await AppDatabase.db.getFavWORDs();
  }

  setRecentWORDs() async {
    this.recentWORDs.value = await AppDatabase.db.getRecentWORDs();
  }

  setWordsOfTheDay() async {
    this.wordsOfTheDay.value = await AppDatabase.db.getWOTD();
  }
  setWords() async {
    this.words.value = await AppDatabase.db.getAllWORDs();
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

   addWORD(WordModel wordModel) async {
    bool check = false;
      setFavWORDs();

    favWORDs.forEach((element) {
      if (element.wordID == wordModel.wordID) {
        check = true;
      }
    });

    if (check == false) {
     await  AppDatabase.db.addWord(wordModel);
      print(words);
    }
          setFavWORDs();

  }

  Future addFavWORD(String wordID) async {
    bool check = false;

    favWORDs.forEach((element) {
      if (element.wordID == wordID) {
        check = true;
      }
    });

    if (check == false) {
      await AppDatabase.db.addFavWORD(wordID);
      setFavWORDs();
      print(favWORDs);
    }
  }

  bool isFavWord(String? wordID)  {
    setFavWORDs();
    bool check = false;

    favWORDs.forEach((element) {
      if (element.wordID == wordID) {
        check = true;
      }
    });
              setFavWORDs();


    return check;
  }

  Future removeFavWORD(String wordToRemove) async {
    await AppDatabase.db.removeFavWORDAt(wordToRemove);
    setFavWORDs();
  }

  Future clearFavWORDs() async {
    await AppDatabase.db.removeAllFavWORDs();
    setFavWORDs();
  }

  Future addWordToHistory(String wordID) async {
    bool check = false;

    recentWORDs.forEach((element) {
      if (element.wordID == wordID) {
        check = true;
      }
    });

    if (check == false) {
      // history.add(wordModel);
      await AppDatabase.db.addRecentWORD(wordID);
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
