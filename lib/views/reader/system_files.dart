import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/models/fileModel.dart';
import 'package:kenkan_app_x/views/reader/SyncFusionPDFViewer.dart';
import 'package:kenkan_app_x/widgets/app_drawer.dart';
import 'package:path/path.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class SystemFilesScreen extends StatefulWidget {
  bool? isFavFile;

   SystemFilesScreen({Key? key,required this.isFavFile}) : super(key: key);

  @override
  _SystemFilesScreenState createState() => _SystemFilesScreenState();
}

class _SystemFilesScreenState extends State<SystemFilesScreen> {
  String? _formattedDate;
  String? _formattedTime;
  String? _fileOpenedAt;
  var files;

  void getFiles() async {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();

    var root = storageInfo[0].rootDir;
    var fm = FileManager(root: Directory(root));

    files = await fm.filesTree(
        sortedBy: FileManagerSorting.Alpha,
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"] // optional to filter files, list only pdf files

        );

    setState(() {}); //Update UI
  }

  @override
  void initState() {
    getFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "PDF Files",
          style: Theme.of(context).textTheme.headline6,
        ),
        elevation: 0,
      ),
      drawer: AppDrawer(),
      body: files == null
          ? Text("Searching Files")
          : ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: files?.length ?? 0,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      tileColor: Theme.of(context).backgroundColor,
                      leading: Icon(
                        Icons.picture_as_pdf,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        files[index].path.split('/').last,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      onTap: () {
                        File file = File(files[index].path);
                        DateTime now = DateTime.now();
                        _formattedDate =
                            DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY)
                                .format(now);
                        _formattedTime =
                            DateFormat(DateFormat.HOUR_MINUTE).format(now);
                        _fileOpenedAt = "$_formattedDate $_formattedTime";

                        String fileName = basename(file.path);
                        Random random = new Random();
                        String fileID = random.nextInt(100000).toString();
                        FileModel fileModel = FileModel(
                            filePath: file.path,
                            fileName: fileName,
                            fileID: fileID,
                            file: file,
                            fileType: 'PDF',
                            fileTimeOpened: _fileOpenedAt!);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SyncPDFViewer(
                                  file: file,
                                  fileModel: fileModel,
                                )));
                        if (widget.isFavFile!){
                            readerController.addToFavFile(
                                  fileModel.fileID, fileModel.fileName);
                        }
                        readerController.addFile(fileModel);
                        readerController.addToRecentFile(
                            fileModel.fileID, fileModel.fileName);
                      },
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
