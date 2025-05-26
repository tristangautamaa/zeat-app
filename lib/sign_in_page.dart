import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Example of a state variable for password visibility
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/texture-two.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.365,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Jika ingin rata kiri
              children: [
                Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 3),
                Container(
                  width: 40,
                  height: 2,
                  decoration: BoxDecoration(
                    // Menggunakan BoxDecoration
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 50),

                // Input Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'enter your email',
                    hintStyle: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    prefixIcon: const Icon(Icons.email_outlined, size: 22.0),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Input Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Untuk menyembunyikan password
                  decoration: InputDecoration(
                    hintText: 'enter your password',
                    hintStyle: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    prefixIcon: const Icon(Icons.lock_outline, size: 22.0),
                    // suffixIcon: const Icon(Icons.visibility_outlined, size: 22.0),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Implement navigation to Forgot Password page
                      print('Forgot Password? tapped');

                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 10,
                        color:
                            Colors.grey, // Atau warna lain sesuai desain Anda
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60), // Spasi sebelum tombol Login
                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Ambil nilai dari controller saat tombol ditekan
                      final email = _emailController.text;
                      final password = _passwordController.text;

                      print('Email: $email');
                      print('Password: $password');

                      if (email.isNotEmpty && password.isNotEmpty) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Attempting login...')),
                        // );
                        Navigator.pushNamed(context, '/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter email and password'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background hitam
                      foregroundColor: Colors.white, // Teks putih
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ), // Padding vertikal
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ), // Spasi antara tombol Login dan teks baru

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center, // Pusatkan Row secara horizontal
                  children: [
                    const Text(
                      "Don't have an Account ? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey, // Warna teks abu-abu
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement navigation to Sign Up page
                        print('Sign up tapped!');
                        // Contoh navigasi:
                        Navigator.pushNamed(context, '/sign-up');
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold, // Membuat "Sign up" bold
                          color: Colors.black, // Warna teks hitam
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
