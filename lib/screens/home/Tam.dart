// import 'package:typewritertext/typewritertext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mood_journal/components/gridview/note_card.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/providers/settings_provider.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> screens = <Widget>[
    HomeScreen(),
    // CalendarScreen(),
    // InsightScreen(),
    // SettingScreen(),
  ];
  Widget currentScreen = HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, _) {
        return Scaffold(
          // appBar: AppBar(title: Text('The Sanctuary')),
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    SizedBox(width: double.infinity, height: 180),
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Stack(
                        alignment: AlignmentGeometry.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/banner.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

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
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/welcome.png',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

                                      // Tên người dùng
                                      Text(
                                        'Hello, Văn Huỳnh', // tên người dùng
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 40),
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.palette,
                                      color: const Color.fromARGB(
                                        255,
                                        227,
                                        149,
                                        149,
                                      ),
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: ElevatedButton.icon(
                                  label: Text('1'),
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.white,
                                    ),
                                    foregroundColor: WidgetStatePropertyAll(
                                      Colors.red,
                                    ),
                                    minimumSize: WidgetStatePropertyAll(
                                      Size.zero,
                                    ),
                                    maximumSize: WidgetStatePropertyAll(
                                      Size(300, 300),
                                    ),
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
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0, // Dính chặt vào đáy của Stack (Header)
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30, // Độ cao của phần bo góc
                        decoration: BoxDecoration(
                          color: Color(
                            0xFFF5F5F5,
                          ), // Màu trắng của phần body bên dưới
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              30,
                            ), // Chỉ bo góc trên bên trái
                            topRight: Radius.circular(
                              30,
                            ), // Chỉ bo góc trên bên phải
                          ),
                        ),

                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen(); )),
                                },
                                icon: Icon(Icons.search),
                              ),

                              Consumer<SettingsProvider>(
                                builder: (context, settings, _) {
                                  return IconButton(
                                    onPressed: () {
                                      settings.setViewMode(
                                        !settings.isGridView,
                                      );
                                    },
                                    icon: Icon(
                                      settings.isGridView
                                          ? Icons.grid_view
                                          : Icons.list,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // // Positioned(top: 0, left: 0, right: 0, child: iconSection()),
                  ],
                ),

                Expanded(child: _buildBody()),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            shape: CircleBorder(),

            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => NoteEditScreen()),
              // ).then((_) {
              //   Provider.of<NoteProvider>(context, listen: false).loadNotes();
              // });
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shadowColor: Colors.black,
            color: Colors.white,
            shape: CircularNotchedRectangle(),
            notchMargin: 10,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Side
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          setState(() {
                            currentScreen = HomeScreen();
                            _selectedIndex = 0;
                          });
                        },
                        minWidth: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              color: _selectedIndex == 0
                                  ? AppColors.primaryVariant
                                  : Colors.black,
                            ),
                            Text(
                              'Home',
                              style: TextStyle(
                                color: _selectedIndex == 0
                                    ? AppColors.primaryVariant
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          setState(() {
                            currentScreen = HomeScreen();
                            _selectedIndex = 1;
                          });
                        },
                        minWidth: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: _selectedIndex == 1
                                  ? AppColors.primaryVariant
                                  : Colors.black,
                            ),
                            Text(
                              'Calendar',
                              style: TextStyle(
                                color: _selectedIndex == 1
                                    ? AppColors.primaryVariant
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ], // Missing closing parenthesis for Row
                  ),
                  // Right Side
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          setState(() {
                            currentScreen = HomeScreen();
                            _selectedIndex = 3;
                          });
                        },
                        minWidth: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.insights,
                              color: _selectedIndex == 3
                                  ? AppColors.primaryVariant
                                  : Colors.black,
                            ),
                            Text(
                              'Insight',
                              style: TextStyle(
                                color: _selectedIndex == 3
                                    ? AppColors.primaryVariant
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          setState(() {
                            currentScreen = HomeScreen();
                            _selectedIndex = 4;
                          });
                        },
                        minWidth: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people,
                              color: _selectedIndex == 4
                                  ? AppColors.primaryVariant
                                  : Colors.black,
                            ),
                            Text(
                              'Account',
                              style: TextStyle(
                                color: _selectedIndex == 1
                                    ? AppColors.primaryVariant
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ], // Missing closing parenthesis for Row
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Consumer2<NoteProvider, SettingsProvider>(
      builder: (context, noteProvider, settings, _) {
        if (noteProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var notes = noteProvider.notes;

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
            ? _buildGridView(notes)
            : _buildListView(notes);
      },
    );
  }

  Widget _buildGridView(List<NoteModel> notes) {
    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: SlideAnimation(
              child: FadeInAnimation(child: NoteCard(note: notes[index])),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(List<NoteModel> notes) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: NoteCard(note: notes[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
