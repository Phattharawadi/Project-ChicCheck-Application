import 'package:flutter/material.dart';

class QuizResultScreen extends StatefulWidget {
  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundColor: Colors.pink.shade100,
            child: Icon(Icons.close,
                color: const Color.fromARGB(255, 118, 19, 52)),
          ),
        ),
        title: Text(
          'Skin Type Quiz',
          style: TextStyle(color: const Color.fromARGB(255, 193, 72, 118)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color.fromARGB(255, 193, 72, 118),
              child: Icon(Icons.check, color: Colors.white, size: 50),
            ),
            SizedBox(height: 20),
            Text(
              'Done',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 156, 32, 74)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // ทำให้มองเห็นพื้นหลังได้
        selectedItemColor: const Color.fromARGB(255, 85, 85, 85),
        unselectedItemColor: const Color.fromARGB(255, 255, 254, 254),
        backgroundColor: const Color.fromARGB(255, 198, 72, 120),
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        iconSize: 30, // เพิ่มขนาดของไอคอน
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}