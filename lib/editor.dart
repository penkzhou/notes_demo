import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:editor_demo/mobile_editor.dart';
import 'package:flutter/material.dart';

class Editor extends StatefulWidget {
  const Editor({
    required this.jsonString,
    required this.onEditorStateChange,
    super.key,
    this.editorStyle,
    this.textDirection = TextDirection.ltr,
  });

  final Future<String> jsonString;
  final EditorStyle? editorStyle;
  final void Function(EditorState editorState) onEditorStateChange;

  final TextDirection textDirection;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  EditorState? editorState;

  @override
  void dispose() {
    editorState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<String>(
        future: widget.jsonString,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            EditorState editorState = EditorState(
              document: Document.fromJson(
                  json.decode(snapshot.data!) as Map<String, dynamic>),
            );
            editorState.logConfiguration
              ..handler = debugPrint
              ..level = LogLevel.off;

            editorState.transactionStream
                .listen(((TransactionTime, Transaction) event) {
              if (event.$1 == TransactionTime.after) {
                widget.onEditorStateChange(editorState);
              }
            });

            this.editorState = editorState;

            return MobileEditor(
              editorState: editorState,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
