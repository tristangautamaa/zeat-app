import 'package:flutter/material.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  AdminDashboardPageState createState() => AdminDashboardPageState();
}

class AdminDashboardPageState extends State<AdminDashboardPage> {
  bool _hasProfileImage = false;

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
        _hasProfileImage = true; // Set to true only if user selects an image
      });
    } else {
      setState(() {
        _hasProfileImage = false; // Reset to default image if user cancels
      });
    }
  }

  void _resetToDefault() {
    setState(() {
      _hasProfileImage = false; // Revert to default image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60), // Increased padding from 40 to 60
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
                          : const AssetImage('assets/default-resto.png')
                              as ImageProvider,
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.transparent,
                  child:
                      !_hasProfileImage
                          ? Image.asset(
                            'assets/default-resto.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 40,
                              );
                            },
                          )
                          : null,
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
            const SizedBox(height: 8),
            const Text(
              'Mariana Bakery',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const Text(
              'MarianaIndonesia@gmail.com',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Navigation Options
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.location_on,
                    title: 'Location',
                    route: '/location',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.list,
                    title: 'Menu List',
                    route: '/menu-list',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.upload,
                    title: 'Upload Image',
                    route: null,
                    onTap: _pickImage,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    route: '/welcome',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String? route,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            if (route != null) {
              Navigator.pushReplacementNamed(context, route);
            }
          },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
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
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
