import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firabase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;
  late final TextEditingController _textController;
  late final TextEditingController _titleController;

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      _titleController.text = widgetNote.title;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) return existingNote;

    final currentUser = AuthService.firebase().currentUser!;
    final newNote =
        await _noteService.createNewNote(ownerUserId: currentUser.id);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_titleController.text.isEmpty &&
        _textController.text.isEmpty &&
        note != null) {
      _noteService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    var title = _titleController.text;
    final text = _textController.text;
    if (note != null && (text.isNotEmpty || title.isNotEmpty)) {
      if (title.isEmpty) title = 'Untitled Note';
      await _noteService.updateNote(
          documentId: note.documentId, title: title, text: text);
    }
  }

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    _textController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final title = _titleController.text;
    final text = _textController.text;
    await _noteService.updateNote(
        documentId: note.documentId, title: title, text: text);
  }

  void _setupTextControllerListener() {
    _titleController.removeListener(_textControllerListener);
    _titleController.addListener(_textControllerListener);
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener();
                return TextField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white60),
                  controller: _titleController,
                  //keyboardType: TextInputType.,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'Untitled Note.',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_note == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: TextField(
        controller: _textController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: 'Start typing your note..',
        ),
      ),
    );
  }
}
