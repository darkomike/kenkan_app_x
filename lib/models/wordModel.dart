import 'package:kenkan_app_x/constants/names.dart';

class WordModel {
  String wordName = '';
  String wordDefinition = '';
  int isFav = 0;
  String? day = '';
  String? date = '';


  WordModel(
      {required this.wordName,
      required this.wordDefinition,
       this.day,
       this.date,
      required this.isFav});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[LocalSave.wordName] = this.wordName;
    data[LocalSave.wordDefinition] = this.wordDefinition;
    data[LocalSave.day] = this.day;
    data[LocalSave.date] = this.date;
    data[LocalSave.isFavWord] = this.isFav;

    return data;
  }

  WordModel.fromMap(Map<String, dynamic> map) {
    wordDefinition = map[LocalSave.wordDefinition];
    wordName = map[LocalSave.wordName];
    isFav = map[LocalSave.isFavWord];
    day = map[LocalSave.day];
    date = map[LocalSave.date];

  }
}
