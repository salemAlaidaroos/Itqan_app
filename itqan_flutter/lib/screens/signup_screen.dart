import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _db = DatabaseService();

  void _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("كلمة المرور غير متطابقة")));
      return;
    }

    await _db.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0F2854);
    const linkColor = Color(0xFF4988C4);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: linkColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("رجوع",
            style: TextStyle(color: linkColor, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 0, left: 30.0, right: 30.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                  width: 250,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 0),
              const Text(
                "إنشاء حساب",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: mainColor),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                  hint: "الاسم الكامل",
                  icon: Icons.person_outline,
                  controller: _nameController),
              const SizedBox(height: 10),
              CustomTextField(
                  hint: "البريد الإلكتروني",
                  icon: Icons.email_outlined,
                  controller: _emailController),
              const SizedBox(height: 10),
              CustomTextField(
                  hint: "كلمة المرور",
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  isPassword: true),
              const SizedBox(height: 10),
              CustomTextField(
                  hint: "تأكيد كلمة المرور",
                  icon: Icons.lock_outline,
                  controller: _confirmPasswordController,
                  isPassword: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "إنشاء حساب",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: linkColor,
                          fontSize: 16),
                    ),
                  ),
                  const Text("لديك حساب بالفعل؟ ",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
