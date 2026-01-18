import 'package:flutter/material.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:mood_journal/theme/app_colors.dart';
import 'package:provider/provider.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  int _totalNotes = 0;
  int _totalMoods = 0;
  int _currentStreak = 0;
  int _longestStreak = 0;
  List<bool> _dailyStatus = List.generate(7, (_) => false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      // Generate summary only if it hasn't been generated yet or notes have changed.
      if (noteProvider.insightsSummary == null &&
          noteProvider.notes.isNotEmpty) {
        noteProvider.generateInsightsSummary();
      }
    });
    _loadInsights();
  }

  Future<void> _refreshInsights() async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    await noteProvider.loadNotes();
    await noteProvider.generateInsightsSummary();
  }

  void _loadInsights() {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final notes = noteProvider.notes;

    // Calculate total notes
    _totalNotes = notes.length;

    // Calculate total unique moods
    final moodIndices = notes.map((note) => note.moodIndex).toSet();
    _totalMoods = moodIndices.length;

    // Calculate streaks
    final streaks = _calculateStreaks(notes);
    _currentStreak = streaks['current'] ?? 0;
    _longestStreak = streaks['longest'] ?? 0;

    // Calculate daily status for the last 7 days
    _dailyStatus = _calculateDailyStatus(notes);

    setState(() {});
  }

  Map<String, int> _calculateStreaks(List<NoteModel> notes) {
    if (notes.isEmpty) {
      return {'current': 0, 'longest': 0};
    }

    final uniqueDates = notes
        .map((note) => _toStartOfDay(note.createdAt!))
        .toSet()
        .toList();
    uniqueDates.sort();

    if (uniqueDates.isEmpty) {
      return {'current': 0, 'longest': 0};
    }

    int longestStreak = 0;
    int currentStreak = 0;

    for (int i = 0; i < uniqueDates.length; i++) {
      if (i == 0) {
        currentStreak = 1;
      } else {
        final difference = uniqueDates[i].difference(uniqueDates[i - 1]).inDays;
        if (difference == 1) {
          currentStreak++;
        } else {
          currentStreak = 1;
        }
      }
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
    }

    final today = _toStartOfDay(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    if (uniqueDates.last != today && uniqueDates.last != yesterday) {
      currentStreak = 0;
    }

    return {'current': currentStreak, 'longest': longestStreak};
  }

  List<bool> _calculateDailyStatus(List<NoteModel> notes) {
    final dailyStatus = List.generate(7, (_) => false);
    final today = _toStartOfDay(DateTime.now());
    final uniqueDates = notes
        .map((note) => _toStartOfDay(note.createdAt!))
        .toSet();

    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      if (uniqueDates.contains(date)) {
        dailyStatus[6 - i] = true;
      }
    }
    return dailyStatus;
  }

  DateTime _toStartOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          return RefreshIndicator(
            onRefresh: _refreshInsights,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Insight',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // ===== Stats =====
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.backgroundDark
                          : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white : Colors.black12,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(
                          title: 'Bài viết',
                          value: _totalNotes.toString(),
                        ),
                        _StatItem(
                          title: 'Tâm trạng',
                          value: _totalMoods.toString(),
                        ),
                        _StatItem(
                          title: 'Chuỗi liên tục',
                          value: _currentStreak.toString(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== Journal streak =====
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.backgroundDark
                          : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chuỗi nhật ký',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (index) {
                            final isDone = _dailyStatus[index];
                            final day = DateTime.now().subtract(
                              Duration(days: 6 - index),
                            );
                            return Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDone
                                        ? Colors.pink.shade100
                                        : Colors.grey.shade200,
                                  ),
                                  child: Icon(
                                    isDone ? Icons.favorite : Icons.add,
                                    size: 16,
                                    color: isDone ? Colors.pink : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  DateFormat('dd/MM').format(day),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Chuỗi dài nhất: $_longestStreak',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== Tip card =====
                  Container(
                    decoration: BoxDecoration(
                      // boxShadow: Colors.amber,
                      color: isDark
                          ? const Color.fromARGB(255, 246, 188, 188)
                          : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(20),
                      border: isDark ? null : Border.all(color: Colors.black12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Image.asset(
                            'assets/images/insight_tipcard.png',
                            fit: BoxFit.cover,

                            alignment: Alignment.topCenter,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Liptwo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(height: 4),

                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange.shade100,
                                    ),
                                    child: Image.asset(
                                      'assets/images/shinba.png',
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    Text(
                                      noteProvider.insightsSummary ??
                                          'Hãy viết gì đó để Liptwo có thể trò chuyện cùng bạn nhé!',
                                      style: isDark
                                          ? TextStyle(color: Colors.black)
                                          : TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(height: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
