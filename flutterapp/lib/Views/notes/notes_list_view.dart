import 'package:flutter/material.dart';
import 'package:flutterapp/services/crud/notes_service.dart';
import 'package:flutterapp/utlities/dialogs/delete_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNotes note);

class NoteseListView extends StatelessWidget {
  final List<DatabaseNotes> notes;
  final DeleteNoteCallback onDeleteNote;

  const NoteseListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: Icon(
              Icons.delete,
            ),
          ),
        );
      },
    );
  }
}
