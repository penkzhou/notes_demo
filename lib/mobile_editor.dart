import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileEditor extends StatefulWidget {
  const MobileEditor({
    required this.editorState,
    super.key,
    this.editorStyle,
  });

  final EditorState editorState;
  final EditorStyle? editorStyle;

  @override
  State<MobileEditor> createState() => _MobileEditorState();
}

class _MobileEditorState extends State<MobileEditor> {
  EditorState get editorState => widget.editorState;

  late final EditorScrollController editorScrollController;

  late EditorStyle editorStyle;
  late Map<String, BlockComponentBuilder> blockComponentBuilders;

  @override
  void initState() {
    super.initState();

    editorScrollController = EditorScrollController(
      editorState: editorState,
    );

    editorStyle = _buildMobileEditorStyle();
    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  void reassemble() {
    super.reassemble();

    editorStyle = _buildMobileEditorStyle();
    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  Widget build(BuildContext context) {
    assert(PlatformExtension.isMobile);
    return MobileToolbarV2(
      toolbarHeight: 48.0,
      toolbarItems: <MobileToolbarItem>[
        textDecorationMobileToolbarItemV2,
        buildTextAndBackgroundColorMobileToolbarItem(),
        blocksMobileToolbarItem,
        linkMobileToolbarItem,
        dividerMobileToolbarItem,
      ],
      editorState: editorState,
      child: Column(
        children: <Widget>[
          // build appflowy editor
          Expanded(
            child: MobileFloatingToolbar(
              editorState: editorState,
              editorScrollController: editorScrollController,
              toolbarBuilder:
                  (BuildContext context, Offset anchor, Function closeToolbar) {
                return AdaptiveTextSelectionToolbar.editable(
                  clipboardStatus: ClipboardStatus.pasteable,
                  onCopy: () {
                    copyCommand.execute(editorState);
                    closeToolbar();
                  },
                  onCut: () => cutCommand.execute(editorState),
                  onPaste: () => pasteCommand.execute(editorState),
                  onSelectAll: () => selectAllCommand.execute(editorState),
                  onLiveTextInput: null,
                  onLookUp: null,
                  onSearchWeb: null,
                  onShare: null,
                  anchors: TextSelectionToolbarAnchors(
                    primaryAnchor: anchor,
                  ),
                );
              },
              child: AppFlowyEditor(
                editorStyle: editorStyle,
                editorState: editorState,
                editorScrollController: editorScrollController,
                blockComponentBuilders: blockComponentBuilders,
                // showcase 3: customize the header and footer.
                header: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Image.asset(
                    'assets/images/header.png',
                  ),
                ),
                footer: const SizedBox(
                  height: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // showcase 1: customize the editor style.
  EditorStyle _buildMobileEditorStyle() {
    return EditorStyle.mobile(
      cursorColor: const Color.fromARGB(255, 134, 46, 247),
      selectionColor: const Color.fromARGB(50, 134, 46, 247),
      textStyleConfiguration: TextStyleConfiguration(
        text: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black,
        ),
        code: GoogleFonts.sourceCodePro(
          backgroundColor: Colors.grey.shade200,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
    );
  }

  // showcase 2: customize the block style
  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final Map<String, BlockComponentBuilder> map =
        <String, BlockComponentBuilder>{
      ...standardBlockComponentBuilderMap,
    };
    // customize the heading block component
    final List<double> levelToFontSize = <double>[
      24.0,
      22.0,
      20.0,
      18.0,
      16.0,
      14.0,
    ];
    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (int level) => GoogleFonts.poppins(
        fontSize: levelToFontSize.elementAtOrNull(level - 1) ?? 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
    map[ParagraphBlockKeys.type] = ParagraphBlockComponentBuilder(
      configuration: BlockComponentConfiguration(
        placeholderText: (Node node) => 'Type something...',
      ),
    );
    return map;
  }
}