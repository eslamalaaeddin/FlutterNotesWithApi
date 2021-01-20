import 'package:flutter/material.dart';
import 'package:flutter_notes_api/models/ApiResponse.dart';
import 'package:flutter_notes_api/models/Note.dart';
import 'package:flutter_notes_api/services/NoteService.dart';
import 'package:flutter_notes_api/views/NoteDelete.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import 'NoteDetails.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  // NoteService get service => GetIt.I<NoteService>();

  ApiResponse<List<Note>> _apiResponse;
  bool _isLoading = false;
  List<Note> notes;

  NoteService service = NoteService() ;

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Builder(
        builder: (context) {
          if(_isLoading){return Center(child: CircularProgressIndicator());}
          if (_apiResponse.isError){return Center(child: Text(_apiResponse.errorMessage),);}
          return getListView();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NoteDetails())
          ).then((result) {
            if (result){
              _fetchNotes();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getListView() {
    return ListView.builder(
      itemCount: _apiResponse.data.length,
      itemBuilder: (context, index) {
        return Card(
          child: Dismissible(
            key: ValueKey(_apiResponse.data[index].id),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              setState(() {
                notes.removeAt(index);
              });
            },
            //show dialog returns future so we need to use async and await
            confirmDismiss: (direction) async {
              final result = await showDialog(
                  context: context, builder: (_) => NoteDelete());
              if(result){
                final deleteResult = await service.deleteNote(_apiResponse.data[index].id);
                var message = '';
                if (deleteResult != null && deleteResult.data == true){
                   message = 'Note deleted successfully';
                }
                else{
                   message = deleteResult?.errorMessage ?? 'An error occurred';
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: Duration(milliseconds: 1000),));

                return deleteResult?.data ?? false;
              }
              print('$result');
              return result;
            },
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.only(left: 16),
              child: Align(
                child: Icon(Icons.delete, color: Colors.white),
                alignment: Alignment.centerLeft,
              ),
            ),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => NoteDetails(noteId: _apiResponse.data[index].id))).then((result) {
                  if (result){
                    _fetchNotes();
                  }
                });
              },
              title: Text(_apiResponse.data[index].title, style: TextStyle(color: Colors.blue),),
              subtitle: Text(formatDateTime(_apiResponse.data[index].creationDateTime)),
            ),
          ),
        );
      },
    );
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }



  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }
}
