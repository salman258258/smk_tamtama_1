import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smk_tamtama_1/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true; // State untuk toggle password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi login
  Future<void> _login() async {
  try {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = email.split('@')[0]; // Ambil username dari email
    print('Email: $email, Password: $password'); // Debugging

    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Mengecek apakah userCredential sudah berhasil login
    if (userCredential.user != null) {
      print('Login Sukses: ${userCredential.user?.email}');
      Get.offAllNamed(AppRoutes.home); // Pindah ke halaman utama
    } else {
      print('Login gagal, user tidak ditemukan');
    }
  } on FirebaseAuthException catch (e) {
    String message = 'Login gagal';
    if (e.code == 'user-not-found') {
      message = 'Email tidak ditemukan';
    } else if (e.code == 'wrong-password') {
      message = 'Password salah';
    }

    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70.0),
            Image.asset(
              'assets/images/tamtama_logo.png',
              height: 200.0,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 340,
              height: 50.0,
              child: TextField(
                controller: _emailController, // Controller untuk email
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Email', // Label Email
                  prefixIcon: const Icon(Icons.person_outlined),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 340,
              height: 50.0,
              child: TextField(
                controller: _passwordController, // Controller untuk password
                obscureText: _isObscured,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 340,
              height: 50,
              child: GestureDetector(
                onTap: _login, // Panggil fungsi _login saat button ditekan
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 43, 151, 46),
                        Color.fromARGB(255, 11, 76, 14)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
