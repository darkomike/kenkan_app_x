import 'dart:io';

class LocalSave {

  static final isAppOpened = "isAppOpened";

  static final String wordName = "wordName";
  static final String wordDefinition = "wordDefinition";
  static final String isFavWord = "isFavWord";

  static final String favouritesDiction = "favourites_diction";
  static final String favouritesReader = "favourites_reader";
  static final String recentDiction = "recent_diction";
  static final String recentReader = "recent_reader";

  static final String note = "noteTable";
  static final String noteID = "noteID";
  static final String noteTitle = "noteTitle";
  static final String noteBody = "favWordDefinition";
  static final String createdNoteAt = "createdNoteAt";

  static final String isFavFile = "isFavFile";
  static final String filePath = "filePath";
  static final String fileName = "fileName";
  static final String fileID = "fileID";
  static final String fileType = "fileType";
  static final String timeOpened = "timeOpened";

  static final String recent = "Recent";
  static final String savedWords = "Saved";

  static final int numOfSearchItems = 10;

  static Directory? docsDir;
  
  static final String wordForTheDay = "wordForTheDay";

}
