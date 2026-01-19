import 'package:flutter/material.dart';
import 'package:mood_journal/providers/theme_provider.dart';
import 'package:mood_journal/services/settings_service.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> themeImages = [
    'assets/images/theme1.png',
    'assets/images/theme2.png',
    'assets/images/theme3.png',
    'assets/images/theme4.png',
    'assets/images/theme5.png',
    'assets/images/theme6.png',
    'assets/images/theme7.png',
    'assets/images/theme8.png',
    'assets/images/theme9.png',
    'assets/images/theme10.gif',
    'assets/images/theme11.gif',
  ];

  // Logic lưu hình nền mới
  Future<void> _updateTheme(String path) async {
    // Sử dụng context.read để không lắng nghe thay đổi, chỉ gọi hàm
    context.read<ThemeProvider>().updateBackground(path);

    // Thông báo cho người dùng
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật hình nền thành công!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy theme provider và current theme từ context
    final themeProvider = context.watch<ThemeProvider>();
    final currentTheme = themeProvider.currentBackground;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Theme',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Row Dark mode
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark mode', style: TextStyle(fontSize: 16)),
              trailing: Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Grid chọn ảnh nền
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 ảnh mỗi hàng
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8, // Tỉ lệ ảnh hơi dọc
                ),
                itemCount: themeImages.length,
                itemBuilder: (context, index) {
                  final imagePath = themeImages[index];
                  final isSelected = currentTheme == imagePath;

                  return GestureDetector(
                    onTap: () => _updateTheme(imagePath),
                    child: Stack(
                      children: [
                        // Ảnh nền
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Lớp phủ và dấu tick nếu được chọn
                        if (isSelected)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
