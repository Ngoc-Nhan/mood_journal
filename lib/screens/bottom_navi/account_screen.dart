import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/providers/theme_provider.dart';
import 'package:mood_journal/services/settings_service.dart';
import 'package:mood_journal/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = SettingsService();
    // final name = settingsService.getUserName();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: FutureBuilder<String?>(
        future: settingsService.getUserName(), // Gọi hàm lấy tên ở đây
        builder: (context, snapshot) {
          // 1. Kiểm tra trạng thái đang chờ dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Lấy dữ liệu từ snapshot (mặc định là 'Bạn' nếu dữ liệu rỗng)
          final displayName = snapshot.data ?? 'Bạn';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60), // Khoảng cách cho status bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Xin chào, $displayName!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _SectionHeader(title: 'Settings'),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) {
                        return ListTile(
                          leading: const Icon(Icons.brightness_6),
                          title: const Text('Theme'),
                          subtitle: Text(
                            _getThemeModeText(themeProvider.themeMode),
                          ),
                          onTap: () {
                            _showThemeModeDialog(context, themeProvider);
                          },
                        );
                      },
                    ),
                    Divider(),
                    _SectionHeader(title: 'Data'),
                    ListTile(
                      leading: const Icon(Icons.file_upload),
                      title: const Text('Export Notes'),
                      subtitle: Text('Export all notes as JSON file'),
                      onTap: () {
                        _exportNotes(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.file_download),
                      title: const Text('Import Notes'),
                      subtitle: Text('Import notes from JSON file'),
                      onTap: () {
                        _importNotes(context);
                      },
                    ),
                    Divider(),
                    _SectionHeader(title: 'About'),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Version'),
                      subtitle: Text('1.0.0'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Help'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showThemeModeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Theme Mode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              return RadioListTile<ThemeMode>(
                title: Text(_getThemeModeText(mode)),
                value: mode,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  themeProvider.setThemeMode(value!);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _exportNotes(BuildContext context) async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final notes = noteProvider.notes;
    if (notes.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            title: const Text('No Notes'),
            content: const Text('There are no notes to export.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.black : Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Exporting ${notes.length} note ${notes.length > 1 ? 's' : ''}...',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ],
            ),
          );
        },
      );
    }
    try {
      final jsonData = jsonEncode({
        'notes': notes.map((note) => note.toJson()).toList(),
        'exportDate': DateTime.now().toIso8601String(),
      });

      final file = File(
        '${Directory.systemTemp.path}/notes_${DateTime.now().microsecondsSinceEpoch}.json',
      );
      await file.writeAsString(jsonData);

      if (context.mounted) {
        Navigator.pop(context);
      }
      await Share.shareXFiles([XFile(file.path)], subject: 'Notes Export');

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? Colors.black : Colors.white,
              icon: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Export Success'),
              content: Text(
                '${notes.length} note${notes.length > 1 ? 's' : ''} exported successfully.',
              ),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return AlertDialog(
              backgroundColor: isDark ? Colors.black : Colors.white,
              icon: const Icon(Icons.error, color: Colors.red),
              title: const Text('Export Failed'),
              content: Text('Failed to export notes: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _importNotes(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) {
      return;
    }

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.black : Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Importing notes ...'),
              ],
            ),
          );
        },
      );
    }

    try {
      final file = File(result.files.single.path!);
      final jsonData = await file.readAsString();
      final data = jsonDecode(jsonData);

      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      int importedCount = 0;

      if (data['notes' != null]) {
        for (final noteData in data['notes']) {
          final note = NoteModel.fromJson(noteData);
          await noteProvider.createNote(note);
          importedCount++;
        }

        if (context.mounted) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return AlertDialog(
                backgroundColor: isDark ? Colors.black : Colors.white,
                icon: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Import Success'),
                content: Text(
                  '$importedCount note${importedCount > 1 ? 's' : ''} imported successfully.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;

              return AlertDialog(
                backgroundColor: isDark ? Colors.black : Colors.white,
                icon: const Icon(Icons.error, color: Colors.red),
                title: const Text('Invalid File'),
                content: Text('The selected file does not contain any notes'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return AlertDialog(
            backgroundColor: isDark ? Colors.black : Colors.white,
            icon: const Icon(Icons.error, color: Colors.red),
            title: const Text('Import Failed'),
            content: Text('Failed to import notes: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

String _getThemeModeText(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.system:
      return 'System';
    case ThemeMode.light:
      return 'Light';
    case ThemeMode.dark:
      return 'Dark';
  }
}

//
