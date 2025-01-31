import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/pages/create_admin.dart';
import 'package:hair_main_street_admin/pages/edit_user.dart';
import 'package:hair_main_street_admin/pages/orders_page.dart';
import 'package:hair_main_street_admin/pages/reviews_page.dart';
import 'package:hair_main_street_admin/pages/shopsPage.dart';
import 'package:hair_main_street_admin/pages/user_management.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF673AB7),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "DashBoard",
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Text("Dashboard"),
    );
  }
}
