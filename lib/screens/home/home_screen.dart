import 'package:flutter/material.dart';

import '../../models/mood_selector.dart';

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

final List<String> days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
final List<IconData?> moodData = [
  Icons.local_fire_department_outlined, // Mon
  Icons.local_fire_department_outlined, // Tue
  Icons.local_fire_department_outlined, // Wed
  null, // Thur
  null, // Fri
  null, // Sat
  null, // Sun
];

class HomeScreen extends StatelessWidget {
  final String name;

  const HomeScreen({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Stack(
          alignment: AlignmentGeometry.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 280,
              // decoration: BoxDecoration(border: Border.all(width: 2)),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Stack(
                alignment: AlignmentGeometry.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 210,
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

                              // Tên người dùng
                              Text(
                                'Hello, $name', // tên người dùng
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
                              Icons.notifications_none,
                              color: Colors.grey.shade800,
                              size: 28,
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
                            foregroundColor: WidgetStatePropertyAll(Colors.red),
                            minimumSize: WidgetStatePropertyAll(Size.zero),
                            maximumSize: WidgetStatePropertyAll(Size(300, 300)),
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
                  color: Colors.white, // Màu trắng của phần body bên dưới
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30), // Chỉ bo góc trên bên trái
                    topRight: Radius.circular(30), // Chỉ bo góc trên bên phải
                  ),
                ),
              ),
            ),

            // Positioned(top: 0, left: 0, right: 0, child: iconSection()),
            Positioned(
              bottom: 0,
              // top: 0,
              left: 0,
              right: 0,
              child: const MoodSelector(),
            ),
          ],
        ),
        Text(
          "How are you feeling today?",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.6,
                    children: [
                      _buildActionCard(
                        "Talk with AI",
                        Icons.edit,
                        Colors.pink[50]!,
                      ),
                      _buildActionCard("Plan", Icons.place, Colors.green[50]!),
                      _buildActionCard(
                        "Read",
                        Icons.menu_book,
                        Colors.blue[50]!,
                      ),
                      _buildActionCard(
                        "Journey",
                        Icons.edit_note,
                        Colors.purple[50]!,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Tiêu đề
                      Text(
                        "Mood history",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      // 2. Dòng các thứ trong tuần
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: days
                            .map(
                              (day) => Expanded(
                                child: Center(
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 15),

                      // 3. Khung chứa Icon Mood
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: moodData
                              .map(
                                (icon) => Expanded(
                                  child: Center(
                                    child: icon != null
                                        ? Icon(
                                            icon,
                                            color: Colors.red,
                                            size: 35,
                                          ) // Thay bằng Image.asset nếu có icon riêng
                                        : SizedBox(
                                            height: 35,
                                          ), // Ô trống nếu không có dữ liệu
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.black54),
          ),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
