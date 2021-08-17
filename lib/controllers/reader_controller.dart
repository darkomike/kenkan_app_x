
import 'package:get/get.dart';
import 'package:kenkan_app_x/db/diction_db/database.dart';
import 'package:kenkan_app_x/models/fileModel.dart';

class ReaderController extends GetxController{
  static ReaderController instance = Get.find();

  //instance variables 

   var  recentFiles = [].obs;
  var  favFiles = [].obs;

//getters   

  get getFavFiles => favFiles.reversed.toList();
  get getRecentFiles => recentFiles.reversed.toList();

//setters
 setRecentFiles() async {
    recentFiles.value = await AppDatabase.db.getAllRecentFiles();
  }

  setFavFiles() async {
      favFiles.value = await AppDatabase.db.getAllFavFiles();
  }

  Future<int> isFavFile(FileModel fileModel) async {
    setFavFiles();
    int check = 0;

    favFiles.forEach((element) {
      if (element.fileName == fileModel.fileName) {
        check = 1;
      }
    });

    return check;
  }

  Future addToRecentFile(FileModel fileModel) async {
    bool check = false;

    recentFiles.forEach((element) {
      if (element.fileName == fileModel.fileName) {
        check = true;
      }
    });

    if (check == false) {
      await AppDatabase.db.addFileToRecent(fileModel);
      setRecentFiles();
      print(recentFiles);
    }
    
  }

  Future addToFavFile(FileModel fileModel) async {
    bool check = false;

    favFiles.forEach((element) {
      if (element.fileName == fileModel.fileName) {
        check = true;
      }
    });

    if (check == false) {
      await AppDatabase.db.addFileToFav(fileModel);
      setFavFiles();
      print(favFiles);
    }
  }

  Future removeRecentFileAt(int? fileIDToRemove) async {
    await AppDatabase.db.removeRecentFileAt(fileIDToRemove);
    setRecentFiles();
    
  }

  Future clearRecentFiles() async {
    await AppDatabase.db.removeAllRecentFiles();
    setRecentFiles();
  }

  Future removeFavFileAt(String? fileNameToRemove) async {
    await AppDatabase.db.removeFavFileAt(fileNameToRemove);
    setFavFiles();
  }

  Future clearFavFiles() async {
    await AppDatabase.db.removeAllRecentFiles();
    setFavFiles();
  }



}