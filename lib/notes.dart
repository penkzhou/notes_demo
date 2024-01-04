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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late WidgetBuilder _widgetBuilder;
  late EditorState _editorState;
  late Future<String> _jsonString;

  @override
  void initState() {
    super.initState();

    _jsonString = rootBundle.loadString('assets/mobile_example.json');

    _widgetBuilder = (context) => Editor(
          jsonString: _jsonString,
          onEditorStateChange: (editorState) {
            _editorState = editorState;
          },
        );
  }

  @override
  void reassemble() {
    super.reassemble();

    _widgetBuilder = (context) => Editor(
          jsonString: _jsonString,
          onEditorStateChange: (editorState) {
            _editorState = editorState;
            _jsonString = Future.value(
              jsonEncode(_editorState.document.toJson()),
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
        ),
        body: _widgetBuilder(context));
  }
}
