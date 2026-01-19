import 'package:flutter/material.dart';
import 'package:mood_journal/components/onboarding/pin_page.dart';
import 'onboarding_layout.dart';
import './pin_page.dart';

class ChoiceTheme extends StatefulWidget {
  final String name;
  const ChoiceTheme({super.key,required this.name});

  @override
  State<ChoiceTheme> createState() => _ChoiceThemeState();
}

class _ChoiceThemeState extends State<ChoiceTheme> {
  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      title: 'Choose \nYour Theme',
      subtitle: 'You can change later',
      body: const ThemeSelector(),
      primaryText: 'Next',
      onPrimary: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => PinPage(name: widget.name,)));
      },
      secondaryButton: Padding(
        padding: EdgeInsetsGeometry.only(right: 16),
        child: SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: () {},
            child: Text('Skip', style: TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}

// class ThemeSelector extends StatelessWidget {
//   const ThemeSelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 260,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           ThemeCard(imagePath: 'assets/images/theme1.png', isMain: false),
//           SizedBox(width: 16),
//           ThemeCard(
//             imagePath: 'assets/images/theme2.png',
//             isMain: true, // 👈 hình giữa lớn
//           ),
//           SizedBox(width: 16),
//           ThemeCard(imagePath: 'assets/images/theme3.png', isMain: false),
//         ],
//       ),
//     );
//   }
// }

/* class ThemeSelector extends StatelessWidget {

  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: const [
          // Card trái (bị cắt)
          Positioned(
            left: -120,
            child: ThemeCard(
              imagePath: 'assets/images/theme1.png',
              width: 220,
              height: 300,
            ),
          ),

          // Card phải (bị cắt)
          Positioned(
            right: -120,
            child: ThemeCard(
              imagePath: 'assets/images/theme3.png',
              width: 220,
              height: 300,
            ),
          ),

          // Card chính (ở giữa)
          ThemeCard(
            imagePath: 'assets/images/theme2.png',

            width: 254, // 👈 đúng như Figma
            height: 321,
            isMain: true,
          ),
        ],
      ),
    );
  }
}
*/
// class ThemeSelector extends StatelessWidget {
//   const ThemeSelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const mainWidth = 254.0;
//     const sideWidth = 220.0;
//     const gap = 8.0;

//     final sideOffset = (mainWidth / 2) + (sideWidth / 2) + gap;

//     return SizedBox(
//       height: 360,
//       child: Stack(
//         children: [
//           // Card trái
//           Align(
//             alignment: Alignment.center,
//             child: Transform.translate(
//               offset: Offset(-sideOffset, 0),
//               child: const ThemeCard(
//                 imagePath: 'assets/images/theme1.png',
//                 width: sideWidth,
//                 height: 300,
//               ),
//             ),
//           ),

//           // Card phải
//           Align(
//             alignment: Alignment.center,
//             child: Transform.translate(
//               offset: Offset(sideOffset, 0),
//               child: const ThemeCard(
//                 imagePath: 'assets/images/theme3.png',
//                 width: sideWidth,
//                 height: 300,
//               ),
//             ),
//           ),

//           // Card chính
//           const Align(
//             alignment: Alignment.center,
//             child: ThemeCard(
//               imagePath: 'assets/images/theme2.png',
//               width: mainWidth,
//               height: 321,
//               isMain: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});


  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  final PageController _controller = PageController(
    viewportFraction: 0.6, // 👈 khoảng hở 2 bên
    initialPage: 1,
  );

  int currentIndex = 1;

  final themes = [
    'assets/images/theme1.png',
    'assets/images/theme2.png',
    'assets/images/theme3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: PageView.builder(
        controller: _controller,
        itemCount: themes.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double scale = 1.0;

              if (_controller.position.haveDimensions) {
                final page = _controller.page ?? currentIndex.toDouble();
                scale = (1 - (page - index).abs() * 0.2).clamp(0.8, 1.0);
              }

              return Center(
                child: Transform.scale(
                  scale: scale,
                  child: ThemeCard(
                    imagePath: themes[index],
                    width: index == currentIndex ? 254 : 220,
                    height: index == currentIndex ? 321 : 300,
                    isMain: index == currentIndex,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ThemeCard extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final bool isMain;

  const ThemeCard({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 12,
        //     offset: Offset(0, 6),
        //   ),
        // ],
      ),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover, // 👈 phủ kín card
        ),

        // 🔹 PHẦN CONTENT
        // Expanded(
        //   child: Padding(
        //     padding: const EdgeInsets.all(16),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: List.generate(
        //         4,
        //         (_) => Container(
        //           height: 10,
        //           margin: const EdgeInsets.only(bottom: 10),
        //           decoration: BoxDecoration(
        //             color: Colors.grey.shade300,
        //             borderRadius: BorderRadius.circular(6),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
