import 'package:kenkan_app_x/constants/names.dart';

class NoteModel {
  String? noteID;
  String? noteTitle;
  String? noteBody;
  String? noteTimeCreated;
  String? noteFileID = "noteFileID";

  NoteModel(
      {required this.noteTimeCreated,
      required this.noteBody,
      required this.noteID,
      required this.noteTitle,
      required this.noteFileID});

  NoteModel.fromMap(Map<String, dynamic> map) {
    noteID = map[LocalSave.noteID];
    noteBody = map[LocalSave.noteBody];
    noteTitle = map[LocalSave.noteTitle];
    noteTimeCreated = map[LocalSave.noteTimeCreated];
    noteFileID = map[LocalSave.noteFileID];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[LocalSave.noteID] = this.noteID;
    data[LocalSave.noteTitle] = this.noteTitle;
    data[LocalSave.noteBody] = this.noteBody;
    data[LocalSave.noteTimeCreated] = this.noteTimeCreated;
    data[LocalSave.noteFileID] = this.noteFileID;
    
    return data;
  }
}
