import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/models/noteModel.dart';
import 'package:kenkan_app_x/views/notes/noteDetails.dart';
import 'package:kenkan_app_x/widgets/app_drawer.dart';



import '../../reader_homepage.dart';

class NotesHomepage extends StatefulWidget {
  const NotesHomepage({Key? key}) : super(key: key);

  @override
  _NotesHomepageState createState() => _NotesHomepageState();
}

class _NotesHomepageState extends State<NotesHomepage> with SingleTickerProviderStateMixin {
  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReaderHomepage(),
        ));

    return true;
  }

  AnimationController? _animationController;
  Animation<double>? _animation; 

  

@override
  void initState() {
 _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500));

    _animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.easeInOutQuint));
    _animationController!.forward();
        super.initState();
  }

  @override
  Widget build(BuildContext context) {
     
    
      Widget svgNotesIcon = SvgPicture.asset(AssetNames.defaultNoteIconName,
          semanticsLabel: "Loading Icon", height:height/4 ,);
                       String assetNameEditNote = 'assets/images/edit.png';
                       
      Widget svgPDFIcon = SvgPicture.asset(AssetNames.defaultNoteIconName,
          semanticsLabel: "Loading Icon", height:height/4 ,);
                       String assetNameEditPDFNote = 'assets/images/edit.png';

    return  WillPopScope(

        onWillPop: _onWillPop,
        child: Obx(()=>  Scaffold(

          drawer: AppDrawer(),
          
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          
          backgroundColor: Theme.of(context).backgroundColor,
          floatingActionButtonLocation: readerController.recentFiles.length > 4 ? FloatingActionButtonLocation.centerFloat: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton.extended(
            label: Text("Add Note", style: TextStyle(color: Colors.white),),
            tooltip: "Add Note",
            onPressed: () {
              Navigator.push(
                  (context),
                  MaterialPageRoute(
                      builder: (_) => NoteDetails(
                            isAdd: true,
                          )));
            },
            
            icon: Icon(Icons.add, color: Colors.white),
            isExtended: true,
            
            backgroundColor: primaryColor,
          ),
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,

            title: Text(
              "Notes",
              style: Theme.of(context).textTheme.headline6,
            ),
            elevation: 0.1,
            actions: [
              IconButton(
                  tooltip: "Clear all notes",
                  icon: Icon(Icons.clear_all),
                  onPressed: () {

                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Theme.of(context).backgroundColor,
                          title: Text(
                            "Clear Notes",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          content: Text(
                            "Do you want to clear all notes?",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text("No")),
                            TextButton(
                                onPressed: () {
                                  notesController.clearNotes();
                                  Navigator.of(context).pop(true);

                                },
                                child: Text("Yes")),
                          ],
                        ));


                  }),
              SizedBox(
                width: 5,
              )

            ],
          ),
          body: notesController.notes.length == 0
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: svgNotesIcon ,
                      ),
                      SizedBox(height: 20,),
                      Center(
                        child: Text(
                          "Notes are kept here",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  // color: Constants.accentColor,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: notesController.notes.length,
                    itemBuilder: (context, index) {
                      NoteModel noteModel = notesController.getNotes[index];

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Dismissible(
                          key: Key(noteModel.noteID.toString()),
                          onDismissed: (direction) async {
                            notesController.removeNoteAt(noteModel.noteID);
                          },
                          background: slideLeftBackground(),
                          secondaryBackground: slideLeftBackground(),
                          child: Card(
                            borderOnForeground: true,
                            child: ListTile(
                              
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              tileColor:  accentColor,
                              
                                     leading: Container(
                                      //  alignment: Alignment.center,
                                      padding: EdgeInsets.all(5),
                                       decoration: BoxDecoration(
                                         color: Theme.of(context).backgroundColor,
                                         borderRadius: BorderRadius.circular(15)
                                       ),
                                          child: Image.asset(assetNameEditNote, fit: BoxFit.cover, height: 40),
                                        ),
                              title: Text(
                                "${noteModel.noteTitle}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  
                                    color: Colors.black,
                                    fontFamily: "IBMPlexSans",
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${noteModel.noteTimeCreated}",
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {

                                print (noteModel.noteID);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NoteDetails(
                                        noteFileID: noteModel.noteFileID,
                                        isAdd: false,
                                        noteModel: noteModel,
                                      ),
                                    ));
                              },
                            ),
                          ),
                          confirmDismiss: (direction) async {

                            bool res =  false ;
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    content: Text(
                                      "Are you sure you want to delete this note?",
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        onPressed: ()  {
                                          notesController.removeNoteAt(noteModel.noteID);
                                          res = true;
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                            return res;
                          },
                        ),
                      );
                    },
                  ),
                ),
        )),
      );
    
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                " Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
