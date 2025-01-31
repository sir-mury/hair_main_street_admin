import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/authentication/sign_in.dart';
import 'package:hair_main_street_admin/pages/dashboard_page.dart';
import 'package:hair_main_street_admin/firebase_options.dart';
import 'package:hair_main_street_admin/pages/homepage.dart';
import 'package:hair_main_street_admin/pages/reviews_page.dart';
import 'package:hair_main_street_admin/pages/user_management.dart';
import 'package:hair_main_street_admin/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: "/", page: () => HomePage()),
        GetPage(name: "/Dashboard", page: () => DashboardPage()),
        GetPage(name: "/User management", page: () => UserManagementPage()),
        GetPage(name: "/Review", page: () => ReviewPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Hair Main Street Admin',
      theme: ThemeData(
        fontFamily: 'Lato',
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF673AB7),
            fontFamily: 'Lato',
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
          backgroundColor: Colors.white,
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
