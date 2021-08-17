import 'package:kenkan_app_x/constants/names.dart';

class WordModel {
  String wordName = '';
  String wordDefinition = '';
  int isFav = 0;

  WordModel({required this.wordName, required this.wordDefinition, required this.isFav});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[LocalSave.wordName] = this.wordName;
    data[LocalSave.wordDefinition] = this.wordDefinition;
    data[LocalSave.isFavWord] = this.isFav;

    return data;
  }

  WordModel.fromMap(Map<String, dynamic> map) {
    wordDefinition = map[LocalSave.wordDefinition];
    wordName = map[LocalSave.wordName];
    isFav = map[LocalSave.isFavWord];
  }
}
