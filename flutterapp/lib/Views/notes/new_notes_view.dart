import 'package:flutter/material.dart';
import 'package:flutterapp/services/auth/auth_service.dart';
import 'package:flutterapp/services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNotes? _note;
  late final NotesService _notesService;
  late final TextEditingController _texeController;
  @override
  void initState() {
    _notesService = NotesService();
    _texeController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _texeController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _texeController.removeListener(_textControllerListener);
    _texeController.addListener(_textControllerListener);
  }

  Future<DatabaseNotes> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_texeController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNoteEmpty();
    _texeController.dispose();
    super.dispose();
  }

  void _saveNoteIfTextNoteEmpty() async {
    final note = _note;
    final text = _texeController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
          future: createNewNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.data as DatabaseNotes?;
                _setupTextControllerListener();
                return TextField(
                  controller: _texeController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Start typing your note...',
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
