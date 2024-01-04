import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:editor_demo/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
///a page used to make notes
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late EditorState _editorState;
  Future<String> jsonString = Future<String>.value('');

  Future<String> getJsonString() {
    return rootBundle.loadString('assets/mobile_example.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
        ),
        body: Editor(
          jsonString: getJsonString(),
          onEditorStateChange: (EditorState editorState) {
            _editorState = editorState;
            setState(() {
              jsonString = Future<String>.value(
                  jsonEncode(_editorState.document.toJson()));
            });
          },
        ));
  }
}
