import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  // Hàm hỗ trợ chuyển trang
  void _navigateToProfile() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  // 1. Đăng nhập bằng Email / Password
  Future<void> login() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      _navigateToProfile(); // Chuyển trang khi thành công
    } on FirebaseAuthException catch (e) {
      _showMsg(e.message ?? "Lỗi đăng nhập");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // 2. Đăng nhập bằng Google
  Future<void> loginWithGoogle() async {
    setState(() => loading = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      await googleSignIn.signOut();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        _navigateToProfile(); // Chuyển trang khi thành công
      }
    } catch (e) {
      _showMsg("Lỗi Google Sign-In: $e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // 3. Đăng nhập ẩn danh (Chế độ khách)
  Future<void> loginAsGuest() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInAnonymously();
      _navigateToProfile(); // Chuyển trang khi thành công
    } catch (e) {
      _showMsg("Lỗi đăng nhập khách: $e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _showMsg(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Journal Login")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              _buildButton(
                onPressed: login,
                label: "Đăng nhập",
                color: Colors.blue,
                isLoading: loading,
              ),

              const SizedBox(height: 16),
              const Text("Hoặc"),
              const SizedBox(height: 16),

              _buildButton( 
                onPressed: loginWithGoogle,
                label: "Tiếp tục với Google",
                isOutlined: true,
                icon: Icons.g_mobiledata,
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: loading ? null : loginAsGuest,
                child: const Text(
                  "Sử dụng không cần đăng nhập\n(Thông tin sẽ mất khi đăng xuất)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    Color? color,
    bool isOutlined = false,
    bool isLoading = false,
    IconData? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: Icon(icon, size: 30),
              label: Text(label),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(label),
            ),
    );
  }
}
