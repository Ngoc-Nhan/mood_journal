import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mood_journal/components/listview/time_line_group.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debouce;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debouce?.isActive ?? false) _debouce?.cancel();
    _debouce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<NoteProvider>(context, listen: false).setSearchQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search notes...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            _onSearchChanged(query);
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                Provider.of<NoteProvider>(
                  context,
                  listen: false,
                ).clearSearchQuery();
              },
              icon: Icon(Icons.clear),
            ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, _) {
          final notes = noteProvider.notes;
          if (_searchController.text.isEmpty) {
            return Center(
              // mainAxisAlignment: MainAxisAlignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 70, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Search your notes',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          if (notes.isEmpty) {
            return Center(
              // mainAxisAlignment: MainAxisAlignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 70, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notes found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          final groupedNotes = noteProvider.groupedNotes;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedNotes.keys.length,
            itemBuilder: (context, index) {
              String dateKey = groupedNotes.keys.elementAt(index);
              List<NoteModel> notesInDay = groupedNotes[dateKey]!;

              return TimelineGroup(
                // Widget TimelineGroup chúng ta đã viết trước đó
                dateKey: dateKey,
                notes: notesInDay,
              );
            },
          );
        },
      ),
    );
  }
}
