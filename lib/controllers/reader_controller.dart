
import 'package:get/get.dart';
import 'package:kenkan_app_x/db/diction_db/database.dart';
import 'package:kenkan_app_x/models/fileModel.dart';

class ReaderController extends GetxController{
  static ReaderController instance = Get.find();

  //instance variables 

   var  recentFiles = [].obs;
  var  favFiles = [].obs;
  var  files = [].obs;

//getters   

  get getFavFiles => favFiles.reversed.toList();
  get getRecentFiles => recentFiles.reversed.toList();
  get getFiles => files.reversed.toList();

//setters
 setRecentFiles() async {
    recentFiles.value = await AppDatabase.db.getAllRecentFiles();
  }

  setFavFiles() async {
      favFiles.value = await AppDatabase.db.getAllFavFiles();
  }
  setFiles() async {
      files.value = await AppDatabase.db.getAllFiles();
  }

  bool isFavFile(String fileID)  {
    setFavFiles();
    bool check = false;

    favFiles.forEach((element) {
      if (element.fileID == fileID) {
        check = true;
      }
    });

    return check;
  }

  Future addToRecentFile(String  fileID, String fileName) async {
    bool check = false;

    recentFiles.forEach((element) {
      if (element.fileName == fileName) {
        check = true;
      }
    });

    if (check == false) {
      await AppDatabase.db.addFileToRecentTable(fileID);
      setRecentFiles();
      print(recentFiles);
    }
    
  }


  Future addFile(FileModel fileModel ) async {
    bool check = false;

    recentFiles.forEach((element) {
      if (element.fileID == fileModel.fileID) {
        check = true;
      }
    });

    if (check == false) {
      await AppDatabase.db.addFileToFiles(fileModel);
      setFiles();
      print(files);
    }

  }

  Future addToFavFile(String fileID, String fileName) async {
    bool check = false;

    favFiles.forEach((element) {
      if (element.fileName == fileName) {
        check = true;
      }
    });

    if (check == false) {
      await AppDatabase.db.addFileToFavTable(fileID);
      setFavFiles();
      print(favFiles);
    }
  }

  Future removeRecentFileAt(String fileID) async {
    await AppDatabase.db.removeRecentFileAt(fileID);
    setRecentFiles();
    
  }

  Future clearRecentFiles() async {
    await AppDatabase.db.removeAllRecentFiles();
    setRecentFiles();
  }

  Future removeFavFileAt(String? fileID) async {
    await AppDatabase.db.removeFavFileAt(fileID!);
    setFavFiles();
  }

  Future clearFavFiles() async {
    await AppDatabase.db.removeAllRecentFiles();
    setFavFiles();
  }



}