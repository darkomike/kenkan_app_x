import 'package:kenkan_app_x/constants/names.dart';

class WordModel {
  String? wordName = '';
  String? wordID = '';
  String? wordDefinition = '';
  String? wordDay = '';
  String? wordDate = '';


  WordModel(
      {
      required this.wordName,
      required this.wordDefinition,
      required this.wordID,
       this.wordDay,
       this.wordDate,
    });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[LocalSave.wordName] = this.wordName;
    data[LocalSave.wordDefinition] = this.wordDefinition;
    data[LocalSave.wordDay] = this.wordDay;
    data[LocalSave.wordDate] = this.wordDate;
    data[LocalSave.wordID] = this.wordID;

    return data;
  }

  WordModel.fromMap(Map<String, dynamic> map) {
    wordDefinition = map[LocalSave.wordDefinition];
    wordName = map[LocalSave.wordName];
    wordDay = map[LocalSave.wordDate];
    wordDate = map[LocalSave.wordDate];
    wordID = map[LocalSave.wordID];

  }
}
