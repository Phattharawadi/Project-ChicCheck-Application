import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screen/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        
        if (userDoc.exists) {
          setState(() {
            _userData = userDoc.data() as Map<String, dynamic>;
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _editProfile() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(
            userId: currentUser.uid,
            userData: _userData,
          ),
        ),
      );
      
      if (result == true) {
        _loadUserData(); // Reload user data if profile was updated
      }
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              'Log Out',
              style: TextStyle(color: const Color.fromARGB(255, 213, 92, 142)),
            ),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context); // Close the dialog
              // Navigate to login screen or handle in auth state changes
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 213, 87, 129)),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    // Profile Image
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: _userData['profileImageUrl'] != null
                          ? ClipOval(
                              child: Image.network(
                                _userData['profileImageUrl'],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          const Color.fromARGB(255, 233, 162, 186)),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey[400],
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _userData['name'] ?? 'User',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      _auth.currentUser?.email ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_userData['bio'] != null && _userData['bio'].isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          _userData['bio'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    SizedBox(height: 30),
                    // Edit Profile Button
                    ElevatedButton.icon(
                      onPressed: _editProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 246, 167, 195),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      icon: Icon(Icons.edit),
                      label: Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 16),
                        selectionColor: const Color.fromARGB(255, 109, 25, 52),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Profile Information
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          ProfileInfoField(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: _auth.currentUser?.email ?? '',
                          ),
                          ProfileInfoField(
                            icon: Icons.phone_outlined,
                            title: 'Phone',
                            value: _userData['phone'] ?? '',
                            isEditable: true,
                            onEdit: _editProfile,
                          ),
                          ProfileInfoField(
                            icon: Icons.lock_outline,
                            title: 'Password',
                            value: '••••••••',
                            isEditable: true,
                            isPassword: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Log Out Button
                    ElevatedButton.icon(
                      onPressed: _confirmLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(255, 114, 31, 74),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: const Color.fromARGB(255, 115, 29, 67)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 0,
                      ),
                      icon: Icon(Icons.logout),
                      label: Text(
                        'Log Out',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProfileInfoField extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isEditable;
  final bool isPassword;
  final VoidCallback? onEdit;

  const ProfileInfoField({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.isEditable = false,
    this.isPassword = false,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.grey[600],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isPassword ? '••••••••' : (value.isEmpty ? 'Not set' : value),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: value.isEmpty ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (isEditable)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: const Color.fromARGB(255, 192, 55, 101),
                size: 20,
              ),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}