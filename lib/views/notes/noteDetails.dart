import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenkan_app_x/constants/controllers.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/models/noteModel.dart';
import 'package:kenkan_app_x/views/notes/notesHomepage.dart';

class NoteDetails extends StatefulWidget {
  final bool? isAdd;
  final NoteModel? noteModel;
  final String? noteFileID;
  const NoteDetails({Key? key, this.noteModel, this.isAdd, this.noteFileID})
      : super(key: key);

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _textBodyController = new TextEditingController();

  String? _formattedDate;
  String? _formattedTime;
  String? _noteCreatedAt;

  @override
  void initState() {
    DateTime now = DateTime.now();
    _formattedDate = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY).format(now);
    _formattedTime = DateFormat(DateFormat.HOUR_MINUTE).format(now);

    widget.isAdd == true
        ? _textBodyController.clear()
        : _textBodyController.text = widget.noteModel!.noteBody!;
    widget.isAdd == true
        ? _titleController.clear()
        : _titleController.text = widget.noteModel!.noteTitle!;

    print(_formattedDate);
    print(_formattedTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _noteCreatedAt = "$_formattedDate  $_formattedTime";

        Random random = new Random();
        String noteID = random.nextInt(10000).toString();

        if (_titleController.text.trim().isNotEmpty ||
            _textBodyController.text.trim().isNotEmpty) {
          final noteModel = new NoteModel(
              noteTimeCreated: _noteCreatedAt.toString(),
              noteBody: _textBodyController.text.trim(),
              noteTitle: _titleController.text.trim(),
              noteFileID: widget.noteFileID == null ? 'noteFileID' : widget.noteFileID,
              noteID: widget.isAdd == true ? noteID : widget.noteModel!.noteID);
              widget.isAdd == true
              ? notesController.addNote(noteModel)
              : notesController.updateNoteAt(
                  widget.noteModel!.noteID!, noteModel);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Theme.of(context).backgroundColor,

            content: Text(
              widget.isAdd == true ? "Note Saved" : "Note Updated",
              style:Theme.of(context).textTheme.headline2,
            ),
            elevation: 4,
            duration: Duration(milliseconds: 2000),
          ));
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NoteDetails(
                  noteModel: noteModel,
                  noteFileID: widget.noteFileID,
                  isAdd: false,
                ),
              ));

          Navigator.pop(context);
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).backgroundColor,
                    title: Text(
                      "Oops, can not save an empty note!",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    content: Text(
                      "Provide a body or a title.",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text("OK")),
                          
                          TextButton(
                          onPressed: () {
                               // Meeting ID - 83609178745
                              //Passcode - 488546
                           
                             Navigator.push(       context,
              MaterialPageRoute(
                builder: (_) => NotesHomepage (                
                 
                ),
              ));
                          },
                          child: Text("ABORT NOTE")),
                    ],
                  ));
        }
         
       
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.5,
          title: widget.isAdd == true ? Text("Add Note") : Text("Edit Note"),
          actions: [
            IconButton(
                onPressed: () async {
                  _noteCreatedAt = "$_formattedDate  $_formattedTime";

                  Random random = new Random();
                  String noteID = random.nextInt(10000).toString();

                  if (_titleController.text.trim().isNotEmpty ||
                      _textBodyController.text.trim().isNotEmpty) {
                    final noteModel = new NoteModel(
                        noteTimeCreated: _noteCreatedAt.toString(),
                        noteBody: _textBodyController.text.trim(),
                        noteTitle: _titleController.text.trim(),
                        noteID: widget.isAdd == true
                            ? noteID
                            : widget.noteModel!.noteID,
                        noteFileID: widget.noteFileID == null ? 'noteFileID': widget.noteFileID
                        );
                    widget.isAdd == true
                        ? notesController.addNote(noteModel)
                        : notesController.updateNoteAt(
                            widget.noteModel!.noteID!, noteModel);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Theme.of(context).backgroundColor,
                      content: Text(
                        widget.isAdd == true ? "Note Saved" : "Note Updated",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      elevation: 4,
                      duration: Duration(milliseconds: 2000),
                    ));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteDetails(
                            noteModel: noteModel,
                            isAdd: false,
                          ),
                        ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              title: Text(
                                "Oops, can not save an empty note!",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              content: Text(
                                "Provide a body or a title.",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text("OK")),
                              ],
                            ));
                  }
                },
                icon: Icon(
                  Icons.done,
                  color: primaryColor,
                )),
            SizedBox(
              width: 15,
            )
          ],
        ), 
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView(
            children: [
              Text(
                widget.isAdd == true
                    ? "$_formattedDate $_formattedTime"
                    : "${widget.noteModel!.noteTimeCreated}",
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _titleController,
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: Theme.of(context).textTheme.headline5,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: height / 1.4,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _textBodyController,
                  style: Theme.of(context).textTheme.headline4,
                  expands: false,
                  minLines: 30,
                  maxLines: 40,
                  decoration: InputDecoration(
                      hintText: "Note something down...",
                      hintStyle: Theme.of(context).textTheme.headline4,
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
