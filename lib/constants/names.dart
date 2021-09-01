import 'dart:io';

class LocalSave {

  static final isAppOpened = "isAppOpened";

  // MODELS 

  static final String wordName = "wordName";
  static final String wordID = "wordID";
  static final String wordDefinition = "wordDefinition";  
  static final String wordDay = "wordDay";
  static final String wordDate = "wordDate";

  static final String noteID = "noteID";
  static final String noteTitle = "noteTitle";
  static final String noteBody = "noteBody";
  static final String noteTimeCreated = "noteTimeCreated";
  static final String noteFileID = "noteFileID";

  static final String file = "file";
  static final String filePath = "filePath";
  static final String fileName = "fileName";
  static final String fileID = "fileID";
  static final String fileType = "fileType";
  static final String fileTimeOpened = "fileTimeOpened";

  // TABLES 
  static final String filesTable = "files";
  static final String fileFavouriteTable = "favourite_files";
  static final String fileRecentTable = "recent_files";


  static final String wordsTable = "words";
  static final String wordFavouriteTable = "favourite_words";
  static final String wordRecentTable = "recent_words";
  static final String wordsOfTheDayTable = "words_of_the_day";
  
  static final String noteTable = "notes";
 

 

  static final String recent = "Recent";
  static final String savedWords = "Saved";

  static final int numOfSearchItems = 10;

  static Directory? docsDir;
  
  static final String wordForTheDay = "wordForTheDay";

}
