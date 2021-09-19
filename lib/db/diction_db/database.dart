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
    String CREATE_FILES_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.filesTable} ("
        " ${LocalSave.file} ${DbConstants.blobType},"
        "${LocalSave.fileID}  ${DbConstants.textType} PRIMARY KEY,"
        "${LocalSave.fileName} ${DbConstants.textType},"
        "${LocalSave.filePath} ${DbConstants.textType},"
        "${LocalSave.fileTimeOpened} ${DbConstants.textType},"
        "${LocalSave.fileType} ${DbConstants.textType}"
        ")";

    String CREATE_FAV_FILES_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.fileFavouriteTable} ("
        " ${LocalSave.fileID} ${DbConstants.textType},"
        " CONSTRAINT fk_files ,"
        " FOREIGN KEY (${LocalSave.fileID}) "
        " REFERENCES ${LocalSave.filesTable} (${LocalSave.fileID}) "
        ")";

    String CREATE_RECENT_FILES_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.fileRecentTable} ("
        " ${LocalSave.fileID} ${DbConstants.textType},"
        " CONSTRAINT fk_files, "
        " FOREIGN KEY (${LocalSave.fileID}) "
        " REFERENCES ${LocalSave.filesTable} (${LocalSave.fileID}) "
        ")";

    String CREATE_WORDS_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.wordsTable} ("
        "${LocalSave.wordID}  ${DbConstants.textType} PRIMARY KEY,"
        "${LocalSave.wordName} ${DbConstants.textType},"
        "${LocalSave.wordDefinition} ${DbConstants.textType},"
        "${LocalSave.wordDate} ${DbConstants.textType},"
        "${LocalSave.wordDay} ${DbConstants.textType}"
        ")";

    String CREATE_RECENT_WORDS_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.wordRecentTable} ("
        " ${LocalSave.wordID} ${DbConstants.textType},"
        " CONSTRAINT fk_words ,"
        " FOREIGN KEY (${LocalSave.wordID}) "
        " REFERENCES ${LocalSave.wordsTable} (${LocalSave.wordID}) "
        ")";
    String CREATE_FAV_WORDS_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.wordFavouriteTable} ("
        " ${LocalSave.wordID} ${DbConstants.textType},"
        " CONSTRAINT fk_words ,"
        " FOREIGN KEY (${LocalSave.wordID}) "
        " REFERENCES ${LocalSave.wordsTable} (${LocalSave.wordID}) "
        ")";
    String CREATE_WORDS_OF_THE_DAY_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.wordsOfTheDayTable} ("
        " ${LocalSave.wordID} ${DbConstants.textType},"
        " CONSTRAINT fk_words, "
        " FOREIGN KEY (${LocalSave.wordID}) "
        " REFERENCES ${LocalSave.wordsTable} (${LocalSave.wordID}) "
        ")";

    String CREATE_NOTES_TABLE =
        " CREATE TABLE IF NOT EXISTS ${LocalSave.noteTable} ("
        "${LocalSave.noteID}  ${DbConstants.textType} ,"
        "${LocalSave.noteTitle} ${DbConstants.textType},"
        "${LocalSave.noteBody} ${DbConstants.textType},"
        "${LocalSave.noteTimeCreated} ${DbConstants.textType},"
        "${LocalSave.noteFileID} ${DbConstants.textType},"
        " CONSTRAINT fk_notes, "
        " FOREIGN KEY (${LocalSave.noteFileID}) "
        " REFERENCES ${LocalSave.filesTable} (${LocalSave.fileID}) "
        ")";

    await db.execute(CREATE_FILES_TABLE);
    await db.execute(CREATE_FAV_FILES_TABLE);
    await db.execute(CREATE_RECENT_FILES_TABLE);

    await db.execute(CREATE_WORDS_TABLE);
    await db.execute(CREATE_WORDS_OF_THE_DAY_TABLE);
    await db.execute(CREATE_FAV_WORDS_TABLE);
    await db.execute(CREATE_RECENT_WORDS_TABLE);

    await db.execute(CREATE_NOTES_TABLE);
  }

  /// NOTES DATABASE FUNCTIONS
  ///

  Future<List<NoteModel>> selectNoteWithFileID(String noteFileID) async {
    Database db = await database;

    String query = " SELECT  * "
        " FROM ${LocalSave.noteTable} "
        " WHERE ${LocalSave.noteFileID} = $noteFileID ";

    // String query = " SELECT  * "
    //     " FROM ${LocalSave.noteTable} ";
    // // " WHERE ${LocalSave.noteFileID} = $noteFileID ";
    var noteRec = await db.rawQuery(query);
    print("Single Note Record: $noteRec");

    List<NoteModel> list = noteRec.isNotEmpty
        ? noteRec.map((m) => NoteModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future addNote(NoteModel noteModel) async {
    Database db = await database;

    return await db.rawInsert(
        "INSERT INTO ${LocalSave.noteTable} ( ${LocalSave.noteID} ,  ${LocalSave.noteTitle},${LocalSave.noteBody},${LocalSave.noteTimeCreated}, ${LocalSave.noteFileID})"
        " VALUES (?, ?, ? , ?, ?)",
        [
          noteModel.noteID,
          noteModel.noteTitle,
          noteModel.noteBody,
          noteModel.noteTimeCreated,
          noteModel.noteFileID
        ]);

    // await db.insert(LocalSave.noteTable, noteModel.toMap());
  }

  Future<List<NoteModel>> getAllNotes() async {
    Database db = await database;

    var noteRecs = await db.query("${LocalSave.noteTable}",
        orderBy: "${LocalSave.noteTimeCreated}");

    List<NoteModel> list = noteRecs.isNotEmpty
        ? noteRecs.map((m) => NoteModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future deleteNote(int noteId) async {
    Database db = await database;

    await db.delete("${LocalSave.noteTable}",
        where: "${LocalSave.noteID}", whereArgs: [noteId]);
  }

  Future removeNotes() async {
    Database db = await database;

    return await db.delete("${LocalSave.noteTable}");
  }

  Future<int> removeNoteAt(String noteID) async {
    Database db = await database;
    return await db.delete("${LocalSave.noteTable}",
        where: "${LocalSave.noteID} = ?", whereArgs: [noteID]);
  }

  Future updateNoteAt(NoteModel noteModel, String? noteID) async {
    Database db = await database;

    await db.rawUpdate(
        "UPDATE ${LocalSave.noteTable} "
        " SET ${LocalSave.noteID} = ?,"
        " ${LocalSave.noteTitle} = ?,"
        " ${LocalSave.noteBody} = ?,"
        " ${LocalSave.noteTimeCreated} = ?,"
        " ${LocalSave.noteFileID} = ?"
        " WHERE ${LocalSave.noteID} = ?",
        [
          noteModel.noteID,
          noteModel.noteTitle,
          noteModel.noteBody,
          noteModel.noteTimeCreated,
          noteModel.noteFileID,
          noteID
        ]);
  }

  /// READER FILES DATABASE FUNCTIONS

  Future addFileToFiles(FileModel fileModel) async {
    Database db = await database;

    return db.rawInsert(
        "INSERT INTO ${LocalSave.filesTable} (${LocalSave.fileID}, ${LocalSave.fileName}, ${LocalSave.filePath}, ${LocalSave.fileType}, ${LocalSave.fileTimeOpened})"
        "VALUES (?, ?, ? , ?,  ?)",
        [
          fileModel.fileID,
          fileModel.fileName,
          fileModel.filePath,
          fileModel.fileType,
          fileModel.fileTimeOpened
        ]);

    // await db.insert(LocalSave.noteTable, noteModel.toMap());
  }

  Future addFileToFavTable(String fileID) async {
    Database db = await database;

    await db.rawInsert(
        "INSERT INTO ${LocalSave.fileFavouriteTable} ( ${LocalSave.fileID})"
        "VALUES (?)",
        [fileID]);
  }

  Future addFileToRecentTable(String fileID) async {
    Database db = await database;

    await db.rawInsert(
        "INSERT INTO ${LocalSave.fileRecentTable} ( ${LocalSave.fileID})"
        "VALUES (?)",
        [fileID]);
  }

  Future<List<FileModel>> getAllFavFiles() async {
    Database db = await database;
    String query =
        "SELECT ${LocalSave.filesTable}.${LocalSave.file}, ${LocalSave.filesTable}.${LocalSave.fileID},${LocalSave.filesTable}.${LocalSave.fileName}, ${LocalSave.filesTable}.${LocalSave.filePath},${LocalSave.filesTable}.${LocalSave.fileType},${LocalSave.filesTable}.${LocalSave.fileTimeOpened} "
        "FROM ${LocalSave.filesTable}, ${LocalSave.fileFavouriteTable} "
        "WHERE ${LocalSave.filesTable}.${LocalSave.fileID} = ${LocalSave.fileFavouriteTable}.${LocalSave.fileID} "
        " ORDER BY ${LocalSave.fileTimeOpened}";

    var favFileRecs = await db.rawQuery(query);

    print("Favourite Files Records: " + favFileRecs.toString());

    List<FileModel> list = favFileRecs.isNotEmpty
        ? favFileRecs.map((e) => FileModel.fromMap(e)).toList()
        : [];

    return list;
  }

  Future<List<FileModel>> getAllRecentFiles() async {
    Database db = await database;
    String query =
        "SELECT DISTINCT ${LocalSave.filesTable}.${LocalSave.file}, ${LocalSave.filesTable}.${LocalSave.fileID},${LocalSave.filesTable}.${LocalSave.fileName}, ${LocalSave.filesTable}.${LocalSave.filePath},${LocalSave.filesTable}.${LocalSave.fileType},${LocalSave.filesTable}.${LocalSave.fileTimeOpened} "
        "FROM ${LocalSave.filesTable}, ${LocalSave.fileRecentTable} "
        "WHERE ${LocalSave.filesTable}.${LocalSave.fileID} = ${LocalSave.fileRecentTable}.${LocalSave.fileID} "
        " ORDER BY ${LocalSave.fileTimeOpened} DESC";

    var recentFileRecs = await db.rawQuery(query);
    print("Recent Files Records: " + recentFileRecs.toString());

    List<FileModel> list = recentFileRecs.isNotEmpty
        ? recentFileRecs.map((e) => FileModel.fromMap(e)).toList()
        : [];

    return list;
  }

  // This method updates  recent files....

  Future updateRecentFiles(String updatedTime, String fileID) async {
    Database db = await database;
    String query = "UPDATE ${LocalSave.filesTable} "
        " SET ${LocalSave.fileTimeOpened} = ?,"
        " WHERE ${LocalSave.fileID} = ?"; 

    db.rawUpdate(query, [updatedTime, fileID]);
    
  }

  Future<List<FileModel>> getAllFiles() async {
    Database db = await database;

    var filesRecs = await db.query("${LocalSave.filesTable}");

    print("Files Records: " + filesRecs.toString());

    List<FileModel> list = filesRecs.isNotEmpty
        ? filesRecs.map((m) => FileModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future removeRecentFileAt(String fileID) async {
    Database db = await database;
    return await db.delete("${LocalSave.fileRecentTable}",
        where: "${LocalSave.fileID} = ?", whereArgs: [fileID]);
  }

  Future<int> removeAllRecentFiles() async {
    Database db = await database;

    return await db.delete("${LocalSave.fileRecentTable}");
  }

  Future<int> removeFavFileAt(String fileID) async {
    Database db = await database;
    return await db.delete("${LocalSave.fileFavouriteTable}",
        where: "${LocalSave.fileID} = ?", whereArgs: [fileID]);
  }

  Future<int> removeAllFavFiles() async {
    Database db = await database;

    return await db.delete("${LocalSave.fileFavouriteTable}");
  }

  ///DICTIONARY DATABASE FUNCTIONS
  /// GET RECORDS

  Future<List<WordModel>> getAllWORDs() async {
    Database db = await database;

    var wordRecs = await db.query("${LocalSave.wordsTable}");

    List<WordModel> list = wordRecs.isNotEmpty
        ? wordRecs.map((m) => WordModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future<List<WordModel>> getFavWORDs() async {
    Database db = await database;

    String query =
        "SELECT DISTINCT ${LocalSave.wordsTable}.${LocalSave.wordID}, ${LocalSave.wordsTable}.${LocalSave.wordName},${LocalSave.wordsTable}.${LocalSave.wordDefinition}, ${LocalSave.wordsTable}.${LocalSave.wordDay},${LocalSave.wordsTable}.${LocalSave.wordDate} "
        "FROM ${LocalSave.wordsTable}, ${LocalSave.wordFavouriteTable} "
        "WHERE ${LocalSave.wordsTable}.${LocalSave.wordID} = ${LocalSave.wordFavouriteTable}.${LocalSave.wordID}";

    var favWordsRecs = await db.rawQuery(query);

    List<WordModel> list = favWordsRecs.isNotEmpty
        ? favWordsRecs.map((m) => WordModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future<List<WordModel>> getRecentWORDs() async {
    Database db = await database;

    String query =
        "SELECT DISTINCT ${LocalSave.wordsTable}.${LocalSave.wordID}, ${LocalSave.wordsTable}.${LocalSave.wordName},${LocalSave.wordsTable}.${LocalSave.wordDefinition}, ${LocalSave.wordsTable}.${LocalSave.wordDay},${LocalSave.wordsTable}.${LocalSave.wordDate} "
        "FROM ${LocalSave.wordsTable}, ${LocalSave.wordRecentTable} "
        "WHERE ${LocalSave.wordsTable}.${LocalSave.wordID} = ${LocalSave.wordRecentTable}.${LocalSave.wordID}";

    var recentWordsRecs = await db.rawQuery(query);

    List<WordModel> list = recentWordsRecs.isNotEmpty
        ? recentWordsRecs.map((m) => WordModel.fromMap(m)).toList()
        : [];

    return list;
  }

  Future<List<WordModel>> getWOTD() async {
    Database db = await database;

    String query =
        "SELECT DISTINCT ${LocalSave.wordsTable}.${LocalSave.wordID}, ${LocalSave.wordsTable}.${LocalSave.wordName},${LocalSave.wordsTable}.${LocalSave.wordDefinition}, ${LocalSave.wordsTable}.${LocalSave.wordDay},${LocalSave.wordsTable}.${LocalSave.wordDate} "
        "FROM ${LocalSave.wordsTable}, ${LocalSave.wordsOfTheDayTable} "
        "WHERE ${LocalSave.wordsTable}.${LocalSave.wordID} = ${LocalSave.wordsOfTheDayTable}.${LocalSave.wordID}";

    var wftdRecs = await db.rawQuery(query);

    List<WordModel> list = wftdRecs.isNotEmpty
        ? wftdRecs.map((m) => WordModel.fromMap(m)).toList()
        : [];

    return list;
  }

  /// INSERT RECORDS
  Future addWord(WordModel wordModel) async {
    Database db = await database;

    return await db.rawInsert(
        "INSERT INTO ${LocalSave.wordsTable} (wordName, wordDefinition, ${LocalSave.wordID},${LocalSave.wordDate},${LocalSave.wordDay})"
        "VALUES (?, ?, ?, ?, ?)",
        [
          wordModel.wordName,
          wordModel.wordDefinition,
          wordModel.wordID,
          wordModel.wordDate,
          wordModel.wordDay
        ]);
  }

  Future addFavWORD(String wordID) async {
    Database db = await database;

    return await db.rawInsert(
        "INSERT INTO ${LocalSave.wordFavouriteTable} (${LocalSave.wordID})"
        "VALUES (?)",
        [wordID]);
  }

  Future addRecentWORD(String wordID) async {
    Database db = await database;

    return await db.rawInsert(
        "INSERT INTO ${LocalSave.wordRecentTable} (${LocalSave.wordID})"
        "VALUES (?)",
        [wordID]);
  }

  Future addWordOfTheDay(String wordID) async {
    Database db = await database;

    return await db.rawInsert(
        "INSERT INTO ${LocalSave.wordsOfTheDayTable} (${LocalSave.wordID})"
        "VALUES (?)",
        [
          wordID,
        ]);
  }

  /// DELETE RECORDS

  Future<int> removeFavWORDAt(String wordID) async {
    Database db = await database;
    return await db.delete("${LocalSave.wordFavouriteTable}",
        where: "${LocalSave.wordID} = ?", whereArgs: [wordID]);
  }

  Future<int> removeAllFavWORDs() async {
    Database db = await database;

    return await db.delete("${LocalSave.wordFavouriteTable}");
  }

  Future<int> removeRecentWORDAt(String word) async {
    Database db = await database;
    return await db.delete("${LocalSave.wordRecentTable}",
        where: "${LocalSave.wordID} = ?", whereArgs: [word]);
  }

  Future<int> removeAllRecentWORDs() async {
    Database db = await database;

    return await db.delete("${LocalSave.wordRecentTable}");
  }

  Future<int> removeWFTDAt(String word) async {
    Database db = await database;
    return await db.delete("${LocalSave.wordsOfTheDayTable}",
        where: "${LocalSave.wordID} = ?", whereArgs: [word]);
  }

  Future<int> removeAllWFTD() async {
    Database db = await database;

    return await db.delete("${LocalSave.wordsOfTheDayTable}");
  }
}
