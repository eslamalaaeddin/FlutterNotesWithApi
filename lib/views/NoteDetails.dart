import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes_api/models/Note.dart';
import 'package:flutter_notes_api/models/NoteInsert.dart';
import 'package:flutter_notes_api/services/NoteService.dart';
import 'package:get_it/get_it.dart';

class NoteDetails extends StatefulWidget {
  final String noteId;

  NoteDetails({this.noteId});

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  bool get isEditing => (widget.noteId != null) ? true : false;

  //NoteService get service => GetIt.I<NoteService>(); --> app crashes
  NoteService service = NoteService();
  String errorMessage;
  Note currentNote;
  bool _isLoading = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    print(widget.noteId);
    if (widget.noteId != null) {
      setState(() {
        _isLoading = true;
      });
      service.getNote(widget.noteId).then((response) {
        if (response.isError) {
          print(response.errorMessage);
          errorMessage = response.errorMessage ?? 'An error occurred';
        }
        currentNote = response.data;
        _titleController.text = currentNote.title;
        _contentController.text = currentNote.content;
        print(currentNote);
        setState(() {
          _isLoading = false;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((isEditing) ? 'Edit note' : 'Create note'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(hintText: 'Description'),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.all(32),
                          child: RaisedButton(
                            color: Colors.blue,
                            onPressed: () async {
                              if (isEditing) {
                                setState(() {
                                  _isLoading = true;
                                });
                                currentNote.title = _titleController.text;
                                currentNote.content = _contentController.text;
                                final result = await service.updateNote(currentNote);
                                final description = result.isError
                                    ? result.errorMessage ?? 'An error occurred'
                                    : 'Note Update';
                                setState(() {
                                  _isLoading = false;
                                });
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(
                                          result.isError ? 'Oops' : 'Done'),
                                      content: Text(description),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK!'))
                                      ],
                                    )).then((response) {
                                  if (result.data) {
                                    Navigator.of(context).pop(true);
                                  }
                                });

                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                String noteTitle = _titleController.text;
                                String noteContent = _contentController.text;
                                NoteInsert note = NoteInsert(
                                    noteTitle: noteTitle,
                                    noteContent: noteContent);
                                final result = await service.createNote(note);
                                final description = result.isError
                                    ? result.errorMessage ?? 'An error occurred'
                                    : 'Note created';
                                setState(() {
                                  _isLoading = false;
                                });
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text(
                                              result.isError ? 'Oops' : 'Done'),
                                          content: Text(description),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK!'))
                                          ],
                                        )).then((response) {
                                          if (result.data) {
                                            Navigator.of(context).pop(true);
                                          }
                                });
                              }
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
