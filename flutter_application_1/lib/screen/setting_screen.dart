import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/home.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Color(0xFFD4A6B9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 254, 254, 254),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Account'),
          _buildSettingItem(context, Icons.person, 'Profile Settings'),
          _buildSettingItem(context, Icons.notifications, 'Notifications'),
          _buildSettingItem(context, Icons.lock, 'Privacy and Security'),
          SizedBox(height: 24),
          _buildSectionHeader('Application'),
          _buildSettingItem(context, Icons.language, 'Language'),
          _buildSettingItem(context, Icons.color_lens, 'Appearance'),
          _buildSettingItem(context, Icons.phonelink_setup, 'App Preferences'),
          SizedBox(height: 24),
          _buildSectionHeader('Support'),
          _buildSettingItem(context, Icons.help, 'Help Center'),
          _buildSettingItem(context, Icons.info, 'About'),
          _buildSettingItem(context, Icons.logout, 'Log Out', isLogout: true),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD4A6B9),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title,
      {bool isLogout = false}) {
    return Card(
      elevation: 0,
      color: Color(0xFFF8E1EB),
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : Color(0xFFD4A6B9),
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: isLogout
            ? null
            : Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          if (isLogout) {
            _showLogoutDialog(context);
          } else {
            // Navigate to respective settings screen
            _navigateToSettingDetail(context, title);
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4A6B9),
                foregroundColor: Colors.white,
              ),
              child: Text('Log Out'),
              onPressed: () {
                // Perform logout logic here
                Navigator.of(context).pop(); // Close the dialog first
                
                // Navigate to home screen and clear back stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false, // This removes all previous routes
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You have been logged out'),
                    backgroundColor: Color(0xFFD4A6B9),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToSettingDetail(BuildContext context, String settingTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingDetailScreen(title: settingTitle),
      ),
    );
  }
}

// Extra screen to show when a setting is tapped
class SettingDetailScreen extends StatelessWidget {
  final String title;

  const SettingDetailScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color(0xFFD4A6B9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForSetting(title),
              size: 100,
              color: Color(0xFFD4A6B9).withOpacity(0.5),
            ),
            SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'This is the $title screen. Settings functionality would be implemented here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4A6B9),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForSetting(String setting) {
    switch (setting) {
      case 'Profile Settings':
        return Icons.person;
      case 'Notifications':
        return Icons.notifications;
      case 'Privacy and Security':
        return Icons.lock;
      case 'Language':
        return Icons.language;
      case 'Appearance':
        return Icons.color_lens;
      case 'App Preferences':
        return Icons.phonelink_setup;
      case 'Help Center':
        return Icons.help;
      case 'About':
        return Icons.info;
      default:
        return Icons.settings;
    }
  }
}