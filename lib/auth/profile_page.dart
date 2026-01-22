import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin user hiện tại từ Firebase
    final user = FirebaseAuth.instance.currentUser;

    // 1. Kiểm tra nếu là khách (Ẩn danh)
    bool isGuest = user == null || user.isAnonymous;

    // 2. Thiết lập thông tin hiển thị
    // Nếu là khách: đặt tên là Guest + 4 ký tự cuối của UID
    String displayName = isGuest
        ? "Guest_${user?.uid.substring(user.uid.length - 4) ?? 'User'}"
        : (user.displayName ?? "Người dùng");

    String email = isGuest
        ? "Chế độ ẩn danh (Dữ liệu tạm thời)"
        : (user.email ?? "");

    // 3. Ảnh đại diện ngẫu nhiên cho khách hoặc từ Google
    String photoUrl = isGuest || user.photoURL == null
        ? "https://ui-avatars.com/api/?name=$displayName&background=random"
        : user.photoURL!;

    return Scaffold(
      appBar: AppBar(title: const Text("Hồ sơ cá nhân"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hiển thị Avatar
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(photoUrl),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),

              // Hiển thị Tên người dùng
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Hiển thị Email hoặc trạng thái
              Text(
                email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Nút Đăng xuất
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Thực hiện đăng xuất khỏi Firebase
                    await FirebaseAuth.instance.signOut();

                    // Quay lại trang Login và xóa sạch lịch sử điều hướng
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Đăng xuất"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 82, 160),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
