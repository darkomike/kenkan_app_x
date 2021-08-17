import 'package:kenkan_app_x/constants/names.dart';

class NoteModel {
  int? noteID;
  String noteTitle = '';
  String noteBody = '';
  String createdNoteAt = '';


  NoteModel(
      {required this.createdNoteAt,
      required this.noteBody,
      this.noteID,
      required this.noteTitle,
      });

  NoteModel.fromMap(Map<String, dynamic> map) {
    noteID = map[LocalSave.noteID] as int?;
    noteBody = map[LocalSave.noteBody];
    noteTitle = map[LocalSave.noteTitle];
    createdNoteAt = map[LocalSave.createdNoteAt];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[LocalSave.noteID] = this.noteID;
    data[LocalSave.noteTitle] = this.noteTitle;
    data[LocalSave.noteBody] = this.noteBody;
    data[LocalSave.createdNoteAt] = this.createdNoteAt;


    return data;
  }


}
