import 'dart:io';
import 'package:kenkan_app_x/constants/names.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/models/fileModel.dart';
import 'package:kenkan_app_x/models/noteModel.dart';
import 'package:kenkan_app_x/models/wordModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase db = AppDatabase._();

  Database? _db;

  Future get database async {
    if (_db == null) {
      _db = await init();
    }

    return _db;
  }

  Future<Database> init() async {
    Directory? directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "kenkan.db");

    Database db = await openDatabase(path, version: 1, onCreate: _createDB);

    return db;
  }

  _createDB(Database db, int version) async {
    String CREATE_WORD_OF_THE_DAY_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.word_of_the_day} ("
        " ${LocalSave.wordName} ${DbConstants.textType},"
        "${LocalSave.wordDefinition} ${DbConstants.textType},"
        "${LocalSave.isFavWord} ${DbConstants.booleanType},"
        "${LocalSave.day} ${DbConstants.textType},"
        "${LocalSave.date} ${DbConstants.textType}"
        ")";

    String CREATE_FAV_WORD_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.favouritesDiction} ("
        " ${LocalSave.wordName} ${DbConstants.textType},"
        "${LocalSave.wordDefinition} ${DbConstants.textType},"
        "${LocalSave.isFavWord} ${DbConstants.booleanType}"
        ")";

    String CREATE_RECENT_WORD_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.recentDiction} ("
        " ${LocalSave.wordName} ${DbConstants.textType},"
        "${LocalSave.wordDefinition} ${DbConstants.textType},"
        "${LocalSave.isFavWord} ${DbConstants.booleanType}"
        ")";

    String CREATE_NOTE_TABLE = " CREATE TABLE IF NOT EXISTS ${LocalSave.note} ("
        " ${LocalSave.noteID} ${DbConstants.idType},"
        "${LocalSave.noteTitle} ${DbConstants.textType},"
        "${LocalSave.noteBody} ${DbConstants.textType},"
        "${LocalSave.createdNoteAt} ${DbConstants.textType}"
        ")";
    String CREATE_FAV_READER_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.favouritesReader} ("
        " ${LocalSave.fileID} ${DbConstants.idType},"
        "${LocalSave.fileName} ${DbConstants.textType},"
        "${LocalSave.filePath} ${DbConstants.textType},"
        "${LocalSave.fileType} ${DbConstants.textType},"
        "${LocalSave.isFavFile} ${DbConstants.booleanType},"
        "${LocalSave.timeOpened} ${DbConstants.textType}"
        ")";
    String CREATE_RECENT_READER_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.recentReader} ("
        " ${LocalSave.fileID} ${DbConstants.idType},"
        "${LocalSave.fileName} ${DbConstants.textType},"
        "${LocalSave.filePath} ${DbConstants.textType},"
        "${LocalSave.fileType} ${DbConstants.textType},"
        "${LocalSave.isFavFile} ${DbConstants.booleanType},"
        "${LocalSave.timeOpened} ${DbConstants.booleanType}"
        ")";
    await db.execute(CREATE_NOTE_TABLE);
    await db.execute(CREATE_FAV_READER_TABLE);
    await db.execute(CREATE_RECENT_READER_TABLE);
    await db.execute(CREATE_FAV_WORD_TABLE);
    await db.execute(CREATE_RECENT_WORD_TABLE);
    await db.execute(CREATE_WORD_OF_THE_DAY_TABLE);
  }

  ///NOTES DATABASE FUNCTIONS
  Future addNote(NoteModel noteModel) async {
    Database db = await database;

    return await db.rawInsert(
        "INSERT INTO ${LocalSave.note} ( ${LocalSave.noteID} ,  ${LocalSave.noteTitle},${LocalSave.noteBody},${LocalSave.createdNoteAt})"
        "VALUES (?, ?, ? , ?)",
        [
          noteModel.noteID,
          noteModel.noteTitle,
          noteModel.noteBody,
          noteModel.createdNoteAt
        ]);

    // await db.insert(LocalSave.note, noteModel.toMap());
  }

  Future<List<NoteModel>> getAllNotes() async {
    Database db = await database;

    var favRecs = await db.query("${LocalSave.note}");

    List<NoteModel> list = favRecs.isNotEmpty
        ? favRecs.map((m) => NoteModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future deleteNote(int noteId) async {
    Database db = await database;

    await db.delete("${LocalSave.note}",
        where: "${LocalSave.noteID}", whereArgs: [noteId]);
  }

  Future removeNotes() async {
    Database db = await database;

    return await db.delete("${LocalSave.note}");
  }

  Future<int> removeNoteAt(int? noteID) async {
    Database db = await database;
    return await db.delete("${LocalSave.note}",
        where: "${LocalSave.noteID} = ?", whereArgs: [noteID]);
  }

  Future updateNoteAt(NoteModel noteModel, int? noteID) async {
    Database db = await database;

    await db.rawUpdate(
        "UPDATE ${LocalSave.note} "
        " SET ${LocalSave.noteID} = ?,"
        " ${LocalSave.noteTitle} = ?,"
        " ${LocalSave.noteBody} = ?,"
        " ${LocalSave.createdNoteAt} = ?"
        " WHERE ${LocalSave.noteID} = ?",
        [
          noteModel.noteID,
          noteModel.noteTitle,
          noteModel.noteBody,
          noteModel.createdNoteAt,
          noteID
        ]);
  }

  /// READER FILES DATABASE FUNCTIONS
  Future addFileToRecent(FileModel fileModel) async {
    Database db = await database;

    return await db.rawInsert(
        "INSERT INTO ${LocalSave.recentReader} (${LocalSave.fileName},${LocalSave.filePath},${LocalSave.isFavFile},${LocalSave.fileType},${LocalSave.timeOpened})"
        "VALUES (?, ?, ? , ?, ?)",
        [
          fileModel.fileName,
          fileModel.filePath,
          fileModel.isFavFile,
          fileModel.fileType,
          fileModel.timeOpened
        ]);

    // await db.insert(LocalSave.note, noteModel.toMap());
  }

  Future addFileToFav(FileModel fileModel) async {
    Database db = await database;

    await db.rawInsert(
        "INSERT INTO ${LocalSave.favouritesReader} ( ${LocalSave.fileName},${LocalSave.filePath},${LocalSave.fileType},${LocalSave.isFavFile},${LocalSave.timeOpened})"
        "VALUES (?, ?, ?, ?, ?)",
        [
          fileModel.fileName,
          fileModel.filePath,
          fileModel.fileType,
          fileModel.isFavFile,
          fileModel.timeOpened
        ]);
  }

  Future<List<FileModel>> getAllRecentFiles() async {
    Database db = await database;

    var recentFileRecs = await db.query("${LocalSave.recentReader}");

    List<FileModel> list = recentFileRecs.isNotEmpty
        ? recentFileRecs.map((m) => FileModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future<List<FileModel>> getAllFavFiles() async {
    Database db = await database;

    var favFileRecs = await db.query("${LocalSave.favouritesReader}");

    List<FileModel> list = favFileRecs.isNotEmpty
        ? favFileRecs.map((m) => FileModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future<int> removeRecentFileAt(int? fileID) async {
    Database db = await database;
    return await db.delete("${LocalSave.recentReader}",
        where: "${LocalSave.fileID} = ?", whereArgs: [fileID]);
  }

  Future<int> removeAllRecentFiles() async {
    Database db = await database;

    return await db.delete("${LocalSave.recentReader}");
  }

  Future<int> removeFavFileAt(String? fileName) async {
    Database db = await database;
    return await db.delete("${LocalSave.favouritesReader}",
        where: "${LocalSave.fileName} = ?", whereArgs: [fileName]);
  }

  Future<int> removeAllFavFiles() async {
    Database db = await database;

    return await db.delete("${LocalSave.favouritesReader}");
  }

  ///DICTIONARY DATABASE FUNCTIONS
  Future addFavWORD(WordModel wordModel) async {
    Database db = await database;

    return await db.rawInsert(
        "INSERT INTO ${LocalSave.favouritesDiction} (wordName, wordDefinition, isFavWord)"
        "VALUES (?, ?, ?)",
        [wordModel.wordName, wordModel.wordDefinition, wordModel.isFav]);
  }

  Future<List<WordModel>> getAllFavWORDs() async {
    Database db = await database;

    var favRecs = await db.query("${LocalSave.favouritesDiction}");

    List<WordModel> list = favRecs.isNotEmpty
        ? favRecs.map((m) => WordModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future<int> removeFavWORDAt(String word) async {
    Database db = await database;
    return await db.delete("${LocalSave.favouritesDiction}",
        where: "${LocalSave.wordName} = ?", whereArgs: [word]);
  }

  Future<int> removeAllFavWORDs() async {
    Database db = await database;

    return await db.delete("${LocalSave.favouritesDiction}");
  }

  //History
  //-----------------------------------------------------------------------------
  Future<List<WordModel>> getAllRecentWORDs() async {
    Database db = await database;

    var recentRecs = await db.query("${LocalSave.recentDiction}");

    List<WordModel> list = recentRecs.isNotEmpty
        ? recentRecs.map((m) => WordModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future addRecentWORDToDB(WordModel wordModel) async {
    Database db = await database;

    return await db.rawInsert(
        "INSERT INTO ${LocalSave.recentDiction} (wordName, wordDefinition, isFavWord)"
        "VALUES (?, ?, ?)",
        [wordModel.wordName, wordModel.wordDefinition, wordModel.isFav]);
  }

  Future<int> removeRecentWORDAt(String word) async {
    Database db = await database;
    return await db.delete("${LocalSave.recentDiction}",
        where: "${LocalSave.wordName} = ?", whereArgs: [word]);
  }

  Future<int> removeAllRecentWORDs() async {
    Database db = await database;

    return await db.delete("${LocalSave.recentDiction}");
  }

// ------------------------------------------------------------------------------------------------------

  Future addWordOfTheDay(WordModel wordModel) async {
    Database db = await database;

    return await db.rawInsert(
        "INSERT INTO ${LocalSave.word_of_the_day} (wordName, wordDefinition, isFavWord, day, date)"
        "VALUES (?, ?, ?, ?, ?)",
        [wordModel.wordName, wordModel.wordDefinition, wordModel.isFav, wordModel.day, wordModel.date]);
  }

  Future<List<WordModel>> getAllWORDSOfTheDay() async {
    Database db = await database;

    var wordsOfTheDay = await db.query("${LocalSave.word_of_the_day}");

    List<WordModel> list = wordsOfTheDay.isNotEmpty
        ? wordsOfTheDay.map((m) => WordModel.fromMap(m)).toList()
        : [];

    return list;
  }


}
