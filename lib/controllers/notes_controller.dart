import 'package:get/get.dart';
import 'package:kenkan_app_x/db/diction_db/database.dart';
import 'package:kenkan_app_x/models/noteModel.dart';
import 'package:kenkan_app_x/models/wordModel.dart';

class NotesController extends GetxController {
  static NotesController instance = Get.find();

  var  notes = [].obs;

  get getNotes => notes.reversed.toList();

   setNotes() async {
    notes.value = await AppDatabase.db.getAllNotes();
  }

   Future addNote(NoteModel noteModel) async {
    await AppDatabase.db.addNote(noteModel);
    setNotes();
    print(notes);
    
  }

   Future clearNotes() async {
    await AppDatabase.db.removeNotes();
    setNotes();
    
  }

  Future removeNoteAt(int? noteIDToRemove) async {
    await AppDatabase.db.removeNoteAt(noteIDToRemove);
    setNotes();
    
  }

  Future updateNoteAt(int? noteIDToUpdate, NoteModel noteModel) async {
    await AppDatabase.db.updateNoteAt(noteModel, noteIDToUpdate);
    setNotes();
  }
}
