import 'dart:math';
import 'package:kenkan_app_x/constants/names.dart';
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
import 'package:kenkan_app_x/db/diction_db/s.dart';
import 'package:kenkan_app_x/db/diction_db/t.dart';
import 'package:kenkan_app_x/db/diction_db/u.dart';
import 'package:kenkan_app_x/db/diction_db/v.dart';
import 'package:kenkan_app_x/db/diction_db/w.dart';
import 'package:kenkan_app_x/db/diction_db/x.dart';
import 'package:kenkan_app_x/db/diction_db/y.dart';
import 'package:kenkan_app_x/db/diction_db/z.dart';
import 'package:kenkan_app_x/models/wordModel.dart';
import 'package:url_launcher/url_launcher.dart';


class ReaderFunctions {
  static String display(String word, Map<String, dynamic> map) {
    String value = '';
    map.forEach((key, val) {
      if (word.toUpperCase() == key) {
        value = val;
      }
    });
    print(value);
    return value;
  }


  // --------------------------------------------------------------------------------------------------------

  

// -----------------------------------------------------------------------------------------------------
  static List<dynamic> searchMany(String word, Map<String, dynamic> map) {
    var wordList = [];
    int num = 0;

    map.forEach((key, value) {
      if (word.toUpperCase().compareTo(key) == 0) {
        WordModel wordModel =
            new WordModel(wordName: key, wordDefinition: value, isFav: 0);
        var wordObject = wordModel.toMap();

        wordList.add(wordObject);
      }
      if (num < LocalSave.numOfSearchItems) {
        if (word.toUpperCase().compareTo(key) == -1) {
          WordModel wordModel =
              new WordModel(wordName: key, wordDefinition: value, isFav: 0);
          var wordObject = wordModel.toMap();

          wordList.add(wordObject);
          num++;
        }
      }
    });

    return wordList;
  }

// ----------------------------------------------------------------------------------------------------------

  static WordModel searchOne(String word, Map<String, dynamic> map) {
    late WordModel wordModelToReturn =
        new WordModel(wordName: "wordName", wordDefinition: "wordDefinition", isFav: 0);

    map.forEach((key, value) {
      if (word.toUpperCase().compareTo(key) == 0) {
        WordModel wordModel =
            new WordModel(wordName: key, wordDefinition: value, isFav: 0);
        wordModelToReturn = wordModel;
      }
    });

    return wordModelToReturn;
  }

// ------------------------------------------------------------------------------------------------------------

  static WordModel randomSearch(String word) {
    late WordModel wordModelToReturn =
        new WordModel(wordName: "wordName", wordDefinition: "wordDefinition", isFav: 0);

    wordModelToReturn = wordOfTheDayModel(word);

    return wordModelToReturn;
  }

// ---------------------------------------------------------------------------------------------------------------

  static String capitalise(String wordToCapitalise) {
    String word = wordToCapitalise[0].toUpperCase();
    word = word + wordToCapitalise.substring(1).toLowerCase();

    return word;
  }

  // -----------------------------------------------------------------------------------------------

  static Future<void> launchIn(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        // headers: <String, String>{'my_header_key': 'my_header_value'
        // },
      );
    } else {
      throw 'Could not launch $url';
    }
  }

// ---------------------------------------------------------------------------------------------------
  static Future<void> launchInGmail(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        // headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
// -----------------------------------------------------------------------------------------------------

  static String transformStringForGoogleSearch(String string) {
    String transformedWord = '';

    transformedWord = string.replaceAll(" ", "+");
    print(transformedWord);
    return transformedWord;
  }
// ---------------------------------------------------------------------------------------------------------

  static String transformStringWithOperators(String string) {
    String transformedWord = string.replaceAll(new RegExp('/W+'), '');

    return transformedWord;
  }

// -----------------------------------------------------------------------------------------------------------

  static List<String> getRandomWordCategory(int randomNumberToRepLetter) {
    // int randomNumberToRepLetter = random!.nextInt(26);

    List<String> _words = [];

    switch (randomNumberToRepLetter) {
      case 1:
        CategoryA.categoryA.forEach((key, value) {
          _words.add(key);
        });

        break;
      case 2:
        CategoryB.categoryB.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 3:
        CategoryC.categoryC.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 4:
        CategoryD.categoryD.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 5:
        CategoryE.categoryE.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 6:
        CategoryF.categoryF.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 7:
        CategoryG.categoryG.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 8:
        CategoryH.categoryH.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 9:
        CategoryI.categoryI.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 10:
        CategoryJ.categoryJ.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 11:
        CategoryK.categoryK.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 12:
        CategoryL.categoryL.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 13:
        CategoryM.categoryM.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 14:
        CategoryN.categoryN.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 15:
        CategoryO.categoryO.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 16:
        CategoryP.categoryP.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 17:
        CategoryQ.categoryQ.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 18:
        CategoryR.categoryR.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 19:
        CategoryS.categoryS.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 20:
        CategoryT.categoryT.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 21:
        CategoryU.categoryU.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 22:
        CategoryV.categoryV.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 23:
        CategoryW.categoryW.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 24:
        CategoryX.categoryX.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 25:
        CategoryY.categoryY.forEach((key, value) {
          _words.add(key);
        });
        break;
      case 26:
        CategoryZ.categoryZ.forEach((key, value) {
          _words.add(key);
        });
        break;

      default:
        _words = [];
        break;
    }

    _words.shuffle();
    return _words;
  }

  static int generateRandom(int min, int max) {
    Random random = Random();

    return min + random.nextInt(max - min);
  }

  

  static WordModel wordOfTheDayModel(String? value) {
    WordModel wordSearched;
        
    switch (value!.toUpperCase()[0].trim()) {
      case "A":
        wordSearched = searchOne(value.trim(), CategoryA.categoryA);
        break;
      case "B":
        wordSearched = searchOne(value.trim(), CategoryB.categoryB);
        break;
      case "C":
        wordSearched = searchOne(value.trim(), CategoryC.categoryC);
        break;
      case "D":
        wordSearched = searchOne(value.trim(), CategoryD.categoryD);
        break;
      case "E":
        wordSearched = searchOne(value.trim(), CategoryE.categoryE);
        break;
      case "F":
        wordSearched = searchOne(value.trim(), CategoryF.categoryF);
        break;
      case "G":
        wordSearched = searchOne(value.trim(), CategoryG.categoryG);
        break;
      case "H":
        wordSearched = searchOne(value.trim(), CategoryH.categoryH);
        break;
      case "I":
        wordSearched = searchOne(value.trim(), CategoryI.categoryI);
        break;
      case "J":
        wordSearched = searchOne(value.trim(), CategoryJ.categoryJ);
        break;
      case "K":
        wordSearched = searchOne(value.trim(), CategoryK.categoryK);
        break;
      case "L":
        wordSearched = searchOne(value.trim(), CategoryL.categoryL);
        break;
      case "M":
        wordSearched = searchOne(value.trim(), CategoryM.categoryM);
        break;
      case "N":
        wordSearched = searchOne(value.trim(), CategoryN.categoryN);
        break;
      case "O":
        wordSearched = searchOne(value.trim(), CategoryO.categoryO);
        break;
      case "P":
        wordSearched = searchOne(value.trim(), CategoryP.categoryP);
        break;
      case "Q":
        wordSearched = searchOne(value.trim(), CategoryQ.categoryQ);
        break;
      case "R":
        wordSearched = searchOne(value.trim(), CategoryR.categoryR);
        break;
      case "S":
        wordSearched = searchOne(value.trim(), CategoryS.categoryS);
        break;
      case "T":
        wordSearched = searchOne(value.trim(), CategoryT.categoryT);
        break;
      case "U":
        wordSearched = searchOne(value.trim(), CategoryU.categoryU);
        break;
      case "V":
        wordSearched = searchOne(value.trim(), CategoryV.categoryV);
        break;
      case "W":
        wordSearched = searchOne(value.trim(), CategoryW.categoryW);
        break;
      case "X":
        wordSearched = searchOne(value.trim(), CategoryX.categoryX);
        break;
      case "Y":
        wordSearched = searchOne(value.trim(), CategoryY.categoryY);
        break;
      case "Z":
        wordSearched = searchOne(value.trim(), CategoryZ.categoryZ);
        break;

      default:
               wordSearched = searchOne("fixed", CategoryI.categoryI);
        break;
    }

    return wordSearched;
  }


   static WordModel? search(String? value) {
    WordModel wordSearched = new WordModel(
        wordName: "wordName", wordDefinition: "wordDefinition", isFav: 0);

    switch (value!.toUpperCase()[0].trim()) {
      case "A":
        wordSearched =
            searchOne(value.trim(), CategoryA.categoryA);
        break;
      case "B":
        wordSearched =
            searchOne(value.trim(), CategoryB.categoryB);
        break;
      case "C":
        wordSearched =
            searchOne(value.trim(), CategoryC.categoryC);
        break;
      case "D":
        wordSearched =
            searchOne(value.trim(), CategoryD.categoryD);
        break;
      case "E":
        wordSearched =
            searchOne(value.trim(), CategoryE.categoryE);
        break;
      case "F":
        wordSearched =
            searchOne(value.trim(), CategoryF.categoryF);
        break;
      case "G":
        wordSearched =
            searchOne(value.trim(), CategoryG.categoryG);
        break;
      case "H":
        wordSearched =
            searchOne(value.trim(), CategoryH.categoryH);
        break;
      case "I":
        wordSearched =
            searchOne(value.trim(), CategoryI.categoryI);
        break;
      case "J":
        wordSearched =
            searchOne(value.trim(), CategoryJ.categoryJ);
        break;
      case "K":
        wordSearched =
            searchOne(value.trim(), CategoryK.categoryK);
        break;
      case "L":
        wordSearched =
            searchOne(value.trim(), CategoryL.categoryL);
        break;
      case "M":
        wordSearched =
            searchOne(value.trim(), CategoryM.categoryM);
        break;
      case "N":
        wordSearched =
            searchOne(value.trim(), CategoryN.categoryN);
        break;
      case "O":
        wordSearched =
            searchOne(value.trim(), CategoryO.categoryO);
        break;
      case "P":
        wordSearched =
            searchOne(value.trim(), CategoryP.categoryP);
        break;
      case "Q":
        wordSearched =
            searchOne(value.trim(), CategoryQ.categoryQ);
        break;
      case "R":
        wordSearched =
            searchOne(value.trim(), CategoryR.categoryR);
        break;
      case "S":
        wordSearched =
            searchOne(value.trim(), CategoryS.categoryS);
        break;
      case "T":
        wordSearched =
            searchOne(value.trim(), CategoryT.categoryT);
        break;
      case "U":
        wordSearched =
          searchOne(value.trim(), CategoryU.categoryU);
        break;
      case "V":
        wordSearched =
            searchOne(value.trim(), CategoryV.categoryV);
        break;
      case "W":
        wordSearched =
            searchOne(value.trim(), CategoryW.categoryW);
        break;
      case "X":
        wordSearched =
            searchOne(value.trim(), CategoryX.categoryX);
        break;
      case "Y":
        wordSearched =
            searchOne(value.trim(), CategoryY.categoryY);
        break;
      case "Z":
        wordSearched =
            searchOne(value.trim(), CategoryZ.categoryZ);
        break;

      default:
        wordSearched = new WordModel(
            wordName: "wordName", wordDefinition: "wordDefinition", isFav: 0);
        break;
    }

    return wordSearched;
  }



}
