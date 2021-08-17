
import 'package:kenkan_app_x/constants/names.dart';

class FileModel {
  int? fileID ;
  String filePath = '';
  String fileName = '';
  String fileType = '';
  String timeOpened = '';
  int isFavFile = 0;


  FileModel(
      { this.fileID,
        required this.filePath,
        required this.fileName,
        required this.fileType,
        required this.isFavFile,
        required this.timeOpened});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[LocalSave.fileID] = this.fileID;
    data[LocalSave.fileName] = this.fileName;
    data[LocalSave.filePath] = this.filePath;
    data[LocalSave.fileType] = this.fileType;
    data[LocalSave.isFavFile] = this.isFavFile;
    data[LocalSave.timeOpened] = this.timeOpened;

    return data;
  }

  FileModel.fromMap(Map<String, dynamic> map) {
    fileID = map[LocalSave.fileID];
    fileName = map[LocalSave.fileName];
    filePath = map[LocalSave.filePath];
    fileType = map[LocalSave.fileType];
    isFavFile = map[LocalSave.isFavFile];
    timeOpened = map[LocalSave.timeOpened];
  }

}
