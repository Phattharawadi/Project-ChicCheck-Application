import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const EditProfileScreen({
    Key? key,
    required this.userId,
    required this.userData,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  File? _selectedImage;
  String? _currentProfileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name'] ?? '');
    _bioController = TextEditingController(text: widget.userData['bio'] ?? '');
    _phoneController = TextEditingController(text: widget.userData['phone'] ?? '');
    _currentProfileImageUrl = widget.userData['profileImageUrl'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // User data to update
      Map<String, dynamic> updatedData = {
        'name': _nameController.text,
        'bio': _bioController.text,
        'phone': _phoneController.text,
      };
      
      // Upload image if selected
      if (_selectedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${widget.userId}.jpg');
            
        await ref.putFile(_selectedImage!);
        String downloadUrl = await ref.getDownloadURL();
        
        updatedData['profileImageUrl'] = downloadUrl;
      }
      
      // Update user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update(updatedData);
      
      setState(() {
        _isLoading = false;
      });
      
      // Show success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, true); // Pass true to indicate successful update
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isLoading ? Colors.grey : const Color(0xFFEC407A),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFEC407A)),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  // Profile Image
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 140,
                          height: 140,
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
                          child: _selectedImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    _selectedImage!,
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : _currentProfileImageUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        _currentProfileImageUrl!,
                                        width: 140,
                                        height: 140,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                  const Color(0xFFEC407A)),
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[100],
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.grey[400],
                                              size: 70,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey[100],
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey[400],
                                        size: 70,
                                      ),
                                    ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFEC407A),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tap to change profile picture',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(height: 30),

                  // Form fields
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                      prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: const Color(0xFFEC407A)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  TextField(
                    controller: _bioController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      hintText: 'Write a short bio about yourself',
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 64),
                        child: Icon(Icons.info_outline, color: Colors.grey[600]),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: const Color(0xFFEC407A)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: const Color(0xFFEC407A)),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}