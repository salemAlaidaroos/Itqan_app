import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_icon.dart';
import 'signup_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _db = DatabaseService();

  void _login() async {
    await _db.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0F2854);
    const linkColor = Color(0xFF4988C4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 80),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.menu_book, size: 60, color: mainColor),
                    const Text(
                      "Itqan",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "تسجيل الدخول",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: mainColor),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                  hint: "البريد الإلكتروني",
                  icon: Icons.person_outline,
                  controller: _emailController),
              const SizedBox(height: 15),
              CustomTextField(
                  hint: "كلمة المرور",
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  isPassword: true),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                  ),
                  child: const Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "أو سجل الدخول باستخدام",
                  style:
                      TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialIcon(label: "G", color: Colors.red, onTap: () {}),
                  const SizedBox(width: 15),
                  SocialIcon(label: "f", color: Colors.blue, onTap: () {}),
                  const SizedBox(width: 15),
                  SocialIcon(label: "X", color: Colors.black, onTap: () {}),
                  const SizedBox(width: 15),
                  SocialIcon(
                      label: "in", color: Colors.blueAccent, onTap: () {}),
                ],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    ),
                    child: const Text(
                      "إنشاء حساب",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: linkColor,
                          fontSize: 16),
                    ),
                  ),
                  const Text("ليس لديك حساب؟ ",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
