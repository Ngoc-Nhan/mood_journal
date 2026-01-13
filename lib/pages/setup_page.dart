import 'package:flutter/material.dart';
import 'package:mood_journal/app.dart';
import 'package:mood_journal/services/settings_service.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _nameController = TextEditingController();
  final _pinController = TextEditingController();
  final _settingsService = SettingsService();

  // Giả sử bạn có các đường dẫn hình nền này trong assets
  final List<String> _themeImages = [
    'assets/images/tree.png',
    'assets/images/banner.png',
    'assets/images/welcome.png',
  ];
  String? _selectedTheme;

  void _saveSettings() async {
    if (_nameController.text.isEmpty || _pinController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ tên và mã PIN.')),
      );
      return;
    }

    if (_pinController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mã PIN phải có ít nhất 4 ký tự.')),
      );
      return;
    }

    // Lưu tất cả cài đặt
    await _settingsService.saveUserName(_nameController.text);
    await _settingsService.savePin(_pinController.text);
    if (_selectedTheme != null) {
      await _settingsService.saveTheme(_selectedTheme!);
    }

    // Chuyển đến màn hình chính của ứng dụng
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Layout()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt ban đầu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên của bạn',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Tạo mã PIN (ít nhất 4 số)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Chọn hình nền',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _themeImages.map((imagePath) {
                final isSelected = _selectedTheme == imagePath;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTheme = imagePath;
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Lưu và Bắt đầu'),
            ),
          ],
        ),
      ),
    );
  }
}
