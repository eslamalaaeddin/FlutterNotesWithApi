import 'dart:convert';
import 'dart:developer';

import 'package:flutter_notes_api/models/ApiResponse.dart';
import 'package:flutter_notes_api/models/Note.dart';
import 'package:flutter_notes_api/models/NoteInsert.dart';
import 'package:http/http.dart' as http;

class NoteService{
  static const String KEY = '1fbe15c5-5476-49bc-8424-1798d7ed8f25';
  static const String API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
  static const String CONTENT_TYPE = 'application/json';
  static const headers = {
    'apiKey' : KEY ,
    'Content-Type': CONTENT_TYPE
  };

  Future<ApiResponse<List<Note>>> getNotesList() {
    return http.get(API + '/notes', headers: headers).then((response) {
      if (response.statusCode == 200) {
        //1// convert raw json to maps
        //2// iterate over maps and extract data from every map and create note object
        //3// add that note to notes list
        final jsonData = json.decode(response.body);
        final notes = <Note>[];
        for (var item in jsonData) {
          notes.add(Note.fromJson(item));
        }
        return ApiResponse<List<Note>>(data: notes);
      }
      return ApiResponse<List<Note>>(isError: true, errorMessage: 'An error occurred');
    }).catchError((_) => ApiResponse<List<Note>>(isError: true, errorMessage: 'An error occurred'));
  }

  Future<ApiResponse<Note>> getNote(String noteId) {
    return http.get(API + '/notes/' + noteId, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData  = json.decode(data.body); //decode takes String and returns Map <String, dynamic>
        print(jsonData);
        return ApiResponse<Note>(data: Note.fromJson(jsonData));
      }
      return ApiResponse<Note>(isError: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => ApiResponse<Note>(isError: true, errorMessage: 'An error occurred'));
  }

  Future<ApiResponse<bool>> createNote(NoteInsert note) {
    return http.post(API + '/notes', headers: headers, body: jsonEncode(note.toJson())).then((data) {
      if (data.statusCode == 201) {
        return ApiResponse<bool>(data: true);
      }
      return ApiResponse<bool>(isError: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => ApiResponse<bool>(isError: true, errorMessage: 'An error occurred'));
  }

  Future<ApiResponse<bool>> updateNote(Note note) {
    NoteInsert noteInsert = NoteInsert(noteTitle: note.title, noteContent: note.content);
    return http.put(API + '/notes/' + note.id, headers: headers, body: jsonEncode(noteInsert.toJson())).then((data) {
      if (data.statusCode == 204) {
        return ApiResponse<bool>(data: true);
      }
      return ApiResponse<bool>(isError: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => ApiResponse<bool>(isError: true, errorMessage: 'An error occurred'));
  }

  Future<ApiResponse<bool>> deleteNote(String noteId) {
    return http.delete(API + '/notes/' + noteId, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return ApiResponse<bool>(data: true);
      }
      return ApiResponse<bool>(isError: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => ApiResponse<bool>(isError: true, errorMessage: 'An error occurred'));
  }
}