import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'support_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool _hasProfileImage = false;
  String? _userName;
  String? _userEmail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .get();
        if (userDoc.exists) {
          if (mounted) {
            setState(() {
              _userEmail = userDoc.data()!['email'] ?? user.email;
              _userName =
                  userDoc.data()!['name']?.isNotEmpty == true
                      ? userDoc.data()!['name']
                      : _extractFirstWordFromEmail(_userEmail ?? user.email) ??
                          'User';
              _isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _errorMessage = 'User profile not found.';
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'No user signed in.';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error fetching user data: $e';
          _isLoading = false;
        });
      }
    }
  }

  // Helper method to extract the first word from the email
  String? _extractFirstWordFromEmail(String? email) {
    if (email == null || !email.contains('@')) return null;
    final localPart = email.split('@')[0]; // Get part before @
    final words = localPart.split('.'); // Split by dots or spaces
    return words.isNotEmpty ? words[0] : null;
  }

  Future<void> _pickImage() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Upload Image'),
            content: const Text('Select an image from your gallery?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Select'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() {
        _hasProfileImage = true;
      });
    } else {
      setState(() {
        _hasProfileImage = false;
      });
    }
  }

  void _resetToDefault() {
    setState(() {
      _hasProfileImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            title: const Text(''),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              _hasProfileImage
                                  ? const NetworkImage(
                                    'https://via.placeholder.com/150',
                                  )
                                  : const AssetImage(
                                        'assets/default-profile.png',
                                      )
                                      as ImageProvider,
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.transparent,
                          child:
                              _hasProfileImage
                                  ? null
                                  : Image.asset(
                                    'assets/default-profile.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 40,
                                      );
                                    },
                                  ),
                        ),
                        if (_hasProfileImage)
                          GestureDetector(
                            onTap: _resetToDefault,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.brown,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : _errorMessage != null
                        ? Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        )
                        : Column(
                          children: [
                            Text(
                              _userName ?? 'User',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _userEmail ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                    const SizedBox(height: 30),
                    _buildMenuItem(
                      icon: Icons.upload,
                      title: 'Upload Image',
                      onTap: _pickImage,
                    ),
                    const SizedBox(height: 10),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Support and Help',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportHelpPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/landing',
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: null,
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[800]?.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
