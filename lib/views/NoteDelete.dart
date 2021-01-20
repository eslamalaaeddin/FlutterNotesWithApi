import 'package:flutter/material.dart';

class NoteDelete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Warning'),
      content: Text('Are you sure you want to delete this note?'),
      actions: [
        FlatButton(onPressed: (){
          Navigator.pop(context, true);
        } , child: Text('Yes')),
        FlatButton(onPressed: (){
          Navigator.pop(context, false);
        } , child: Text('No'))
      ],
    );
  }
}
