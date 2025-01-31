import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/pages/dashboard_page.dart';
import 'package:hair_main_street_admin/pages/homepage.dart';

class NavigationController extends GetxController {
  Rx<Widget> currentPage = Rx<Widget>(DashboardPage());
  Rx<Widget> previousPage = Rx<Widget>(Scaffold());

  onPageChanged(Widget page) {
    previousPage.value = currentPage.value;
    currentPage.value = page;
  }
}
