import 'package:flutter/material.dart';
import 'package:mood_journal/components/onboarding/pin_page.dart';
import 'package:mood_journal/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'onboarding_layout.dart';
// import './pin_page.dart';

class ChoiceTheme extends StatefulWidget {
  const ChoiceTheme({super.key});

  @override
  State<ChoiceTheme> createState() => _ChoiceThemeState();
}

class _ChoiceThemeState extends State<ChoiceTheme> {
  String? _selectedTheme; // Biến để lưu theme được chọn

  void _onNext() {
    if (_selectedTheme != null) {
      // SỬA LỖI: Dùng Provider để cập nhật và lưu theme, đồng thời thông báo cho toàn app
      Provider.of<ThemeProvider>(
        context,
        listen: false,
      ).updateBackground(_selectedTheme!);
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PinPage()),
      );
    }
  }

  void _onSkip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PinPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OnboardingLayout(
      title: 'Choose \nYour Background',
      subtitle: 'You can change later',
      body: ThemeSelector(
        onThemeChanged: (themePath) {
          _selectedTheme = themePath;
        },
      ),
      primaryText: 'Next',
      onPrimary: _onNext,
      secondaryButton: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: _onSkip, // Bỏ qua không lưu
            child: Text(
              'Skip',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeSelector extends StatefulWidget {
  final void Function(String) onThemeChanged;

  const ThemeSelector({super.key, required this.onThemeChanged});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  final PageController _controller = PageController(
    viewportFraction: 0.6,
    initialPage: 1,
  );

  int currentIndex = 1;

  final themes = [
    'assets/images/theme11.gif',
    'assets/images/theme10.gif',
    'assets/images/theme3.png',
  ];

  @override
  void initState() {
    super.initState();
    widget.onThemeChanged(themes[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: PageView.builder(
        controller: _controller,
        itemCount: themes.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
          widget.onThemeChanged(themes[index]);
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
                child: GestureDetector(
                  onTap: () {
                    if (currentIndex != index) {
                      _controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Transform.scale(
                    scale: scale,
                    child: ThemeCard(
                      imagePath: themes[index],
                      width: index == currentIndex ? 254 : 220,
                      height: index == currentIndex ? 321 : 300,
                      isMain: index == currentIndex,
                    ),
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
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Bo tròn ảnh
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}
