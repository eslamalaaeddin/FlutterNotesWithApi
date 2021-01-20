import 'package:flutter/material.dart';
import 'file:///C:/Users/IslamAlaaEddin/AndroidStudioProjects/flutter_notes_api/lib/services/NoteService.dart';
import 'package:flutter_notes_api/views/NoteDetails.dart';
import 'package:flutter_notes_api/views/NoteList.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUpLocator();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => NoteList(),
        '/noteDetails': (context) => NoteDetails()
      },
    ),);
}

void setUpLocator(){
  GetIt locator = GetIt.instance;

  // GetIt.instance.registerLazySingleton(() => NoteService());
  locator.registerSingleton<NoteService>(NoteService());
}
