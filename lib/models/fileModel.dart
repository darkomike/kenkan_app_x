
import 'dart:io';

import 'package:kenkan_app_x/constants/names.dart';

class FileModel {
  String fileID = "";
  String filePath = '';
  String fileName = '';
  String fileType = '';
  String fileTimeOpened = '';
  var file;
  


  FileModel(
      {required this.fileID,
        required this.filePath,
        required this.fileName,
        required this.fileType,
        required this.file,
        required this.fileTimeOpened});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[LocalSave.fileID] = this.fileID;
    data[LocalSave.fileName] = this.fileName;
    data[LocalSave.filePath] = this.filePath;
    data[LocalSave.fileType] = this.fileType;
    data[LocalSave.fileTimeOpened] = this.fileTimeOpened;
    data[LocalSave.file] = this.file; 

    return data;
  }

  FileModel.fromMap(Map<String, dynamic> map) {
    fileID = map[LocalSave.fileID];
    fileName = map[LocalSave.fileName];
    filePath = map[LocalSave.filePath];
    fileType = map[LocalSave.fileType];
    fileTimeOpened = map[LocalSave.fileTimeOpened];
    file = map[LocalSave.file];
  }

}
