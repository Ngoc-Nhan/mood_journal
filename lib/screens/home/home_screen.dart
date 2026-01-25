// import 'package:typewritertext/typewritertext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:mood_journal/components/gridview/note_card.dart';
import 'package:mood_journal/components/gridview/time_line_grid_group.dart';
import 'package:mood_journal/components/listview/time_line_group.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/pages/calendar_screen.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/providers/settings_provider.dart';
import 'package:mood_journal/providers/theme_provider.dart';
import 'package:mood_journal/screens/bottom_navi/account_screen.dart';
import 'package:mood_journal/screens/bottom_navi/insights_screen.dart';
import 'package:mood_journal/screens/home/theme_screen.dart';
import 'package:mood_journal/screens/note_edit/note_edit.dart';
import 'package:mood_journal/screens/search/search_screen.dart';
import 'package:mood_journal/services/settings_service.dart';
import 'package:mood_journal/theme/app_colors.dart';
import 'package:provider/provider.dart';

String getGreeting() {
  final hour = DateTime.now().hour;
  String greeting;

  if (hour < 12) {
    greeting = 'Good Morning';
  } else if (hour < 18) {
    greeting = 'Good Afternoon';
  } else {
    greeting = 'Good Evening';
  }

  return '$greeting ! ';
}

Widget iconSection() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Icon(Icons.home, size: 30),
        Icon(Icons.favorite, size: 30),
        Icon(Icons.person, size: 30),
      ],
    ),
  );
}
// final List<Widget> _pages = [
//   const HomeContent(), // Extract your current body logic to this widget
//   const CalendarScreen(),
//   const InsightScreen(),
//   const AccountScreen(),
// ];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  // Sửa lỗi Hot Reload: Khởi tạo lazy với 'late final'.
  // Hàm _getUserName sẽ chỉ được gọi một lần khi _userNameFuture được truy cập lần đầu.
  late final Future<String?> _userNameFuture = _getUserName();

  Future<String?> _getUserName() async {
    final settingsService = SettingsService();
    return await settingsService.getUserName();
  }

  // initState không còn cần thiết để khởi tạo future này nữa.

  Widget _getActiveScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent(); // Your original Banner + Notes List
      case 1:
        return const CalendarScreen();
      case 3:
        return const InsightsScreen();
      case 4:
        return const AccountScreen();
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      // STEP 2: The Body dynamically changes based on _selectedIndex
      body: SafeArea(child: _getActiveScreen()),

      // STEP 3: Centered Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteEditorScreen(editMode: true, note: null),
            ),
          ).then((_) {
            Provider.of<NoteProvider>(context, listen: false).loadNotes();
          });
        },
        child: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // STEP 4: Custom Bottom App Bar
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }
  // --- UI COMPONENTS ---

  Widget _buildBottomAppBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BottomAppBar(
      notchMargin: 10,
      elevation: 20,

      // shape: const CircularNotchedRectangle(),
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.calendar_month_rounded, 'Calendar', 1),
            ],
          ),
          Row(
            children: [
              _buildNavItem(Icons.insights_rounded, 'Insight', 3),
              _buildNavItem(Icons.person_rounded, 'Settings', 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return MaterialButton(
      shape: const CircleBorder(),
      minWidth: 40,
      onPressed: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : Colors.grey),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) {
        final isDark = theme.themeMode == ThemeMode.dark;
        final bgImage = theme.currentBackground;

        return Column(
          children: [
            // Truyền trực tiếp bgImage vào để hiển thị tức thì
            _buildHeaderStack(
              bgImage,
              isDark,
              context.watch<SettingsProvider>(),
            ),
            Expanded(child: _buildBody()),
          ],
        );
      },
    );
  }

  Widget _buildHeaderStack(bgImage, isDark, settings) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userName = context.watch<SettingsProvider>().userName;
    final streak = settings.streak;

    return Stack(
      alignment: Alignment.center,
      children: [
        Selector<ThemeProvider, String?>(
          selector: (_, provider) => provider.currentBackground,
          builder: (context, currentBg, child) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: currentBg != null
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(currentBg),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const BoxDecoration(color: Colors.grey),
                ),
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                //Avatar
                // Container(
                //   width: 50,
                //   height: 50,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.2),
                //         spreadRadius: 2,
                //         blurRadius: 5,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   child: CircleAvatar(
                //     backgroundImage: AssetImage('assets/images/welcome_1.png'),
                //   ),
                // ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lời chào
                    Text(
                      getGreeting(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),

                    // Tên người dùng - ĐÃ SỬA BẰNG FUTUREBUILDER
                    Selector<SettingsProvider, String?>(
                      selector: (_, provider) => provider.userName,
                      builder: (context, currentNAme, snapshot) {
                        final style = const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        );

                        // if (snapshot.connectionState == ConnectionState.done) {
                        if (currentNAme != null && currentNAme.isNotEmpty) {
                          return Text(currentNAme, style: style);
                        } else {
                          // Nếu không có data hoặc data rỗng, hiển thị tên mặc định
                          return Text('My Friend', style: style);
                        }
                        // }
                        // Trong khi chờ, có thể hiển thị một placeholder ngắn
                        // return Text('...', style: style);
                      },
                    ),
                    // Text(
                    //   userName == null || userName.isEmpty
                    //       ? 'My Friend'
                    //       : userName,
                    //   style: const TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.w600,
                    //     color: Colors.black,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(width: 40),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ThemeScreen()),
                      );
                    },
                    icon: Icon(
                      Icons.palette,
                      color: AppColors.primary,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton.icon(
                label: Text(
                  '$streak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: isDark
                      ? WidgetStatePropertyAll(Colors.black)
                      : WidgetStatePropertyAll(Colors.white),

                  foregroundColor: WidgetStatePropertyAll(Colors.red),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  // minimumSize: WidgetStatePropertyAll(Size(40, 40)),
                  // maximumSize: WidgetStatePropertyAll(Size(100, 200)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  Icons.local_fire_department_outlined,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ),
          ],
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.backgroundDark
                  : AppColors.backgroundLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SearchScreen()),
                      );
                    },
                    icon: Icon(Icons.search),
                  ),

                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) {
                      return IconButton(
                        onPressed: () {
                          settings.setViewMode(!settings.isGridView);
                        },
                        icon: Icon(
                          settings.isGridView ? Icons.grid_view : Icons.list,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer2<NoteProvider, SettingsProvider>(
      builder: (context, noteProvider, settings, _) {
        if (noteProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var notes = noteProvider.notes;
        final groupedNotes = noteProvider.groupedNotes;
        if (notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Every moment is priceless.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Save your thoughts and feelings \n in this journal!',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[400]),
                ),
                SizedBox(height: 20),
                Icon(
                  Icons.note_add_outlined,
                  size: 50,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 10),
                Text('Create New Note'),
              ],
            ),
          );
        }
        return settings.isGridView
            ? _buildGridView(groupedNotes)
            : _buildListView(groupedNotes);
      },
    );
  }

  // Widget _buildGridView(Map<String, List<NoteModel>> groupedData) {
  //   return ListView.builder(
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     itemCount: groupedData.length,
  //     itemBuilder: (context, index) {
  //       String dateKey = groupedData.keys.elementAt(index);
  //       List<NoteModel> notesInDay = groupedData[dateKey]!;
  //       return TimelineGridGroup(dateKey: dateKey, notes: notesInDay);
  //     },
  //   );
  // }
  Widget _buildGridView(Map<String, List<NoteModel>> groupedData) {
    return CustomScrollView(
      slivers: groupedData.entries.map((entry) {
        final dateKey = entry.key;
        final notes = entry.value;

        final parsedDate = DateFormat('dd/MM/yyyy').parse(dateKey);

        return SliverMainAxisGroup(
          slivers: [
            // ===== HEADER NGÀY =====
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                child: Row(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd').format(parsedDate),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'thg ${parsedDate.month} ${parsedDate.year}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

            // ===== GRID NOTE =====
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childCount: notes.length,
                itemBuilder: (context, index) {
                  return NoteCard(note: notes[index]);
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildListView(Map<String, List<NoteModel>> groupedData) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedData.keys.length,
      itemBuilder: (context, index) {
        String dateKey = groupedData.keys.elementAt(index);
        List<NoteModel> notesInDay = groupedData[dateKey]!;

        return TimelineGroup(
          // Widget TimelineGroup chúng ta đã viết trước đó
          dateKey: dateKey,
          notes: notesInDay,
        );
      },
    );
  }
}
