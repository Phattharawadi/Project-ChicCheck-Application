import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/callapi.dart';
import 'package:flutter_application_1/model/favorite_service.dart';
import 'package:flutter_application_1/model/product.dart';
import 'package:flutter_application_1/screen/favorite_screen.dart';
import 'package:flutter_application_1/screen/home.dart';
import 'package:flutter_application_1/screen/product.dart';
import 'package:flutter_application_1/screen/product_detail_screen.dart';
import 'package:flutter_application_1/screen/profile_screen.dart';
import 'package:flutter_application_1/screen/setting_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screen/setting_screen.dart';

Future<void> main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteService(),
      child: MyApp(),
    ),
  );
   WidgetsFlutterBinding.ensureInitialized(); // Required for Firebase initialization

  await Firebase.initializeApp(); // Initialize Firebase

}

class MyApp extends StatelessWidget {
  // สร้าง instance ของ ApiService
  final apiService = MakeupAPI();
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductScreen(),
    );
  }
}

