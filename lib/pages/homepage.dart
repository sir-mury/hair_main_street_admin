import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/controllers/drawer_controller.dart';
import 'package:hair_main_street_admin/controllers/navigation_controller.dart';
import 'package:hair_main_street_admin/pages/create_admin.dart';
import 'package:hair_main_street_admin/pages/dashboard_page.dart';
import 'package:hair_main_street_admin/pages/edit_user.dart';
import 'package:hair_main_street_admin/pages/orders_page.dart';
import 'package:hair_main_street_admin/pages/reviews_page.dart';
import 'package:hair_main_street_admin/pages/shopsPage.dart';
import 'package:hair_main_street_admin/pages/user_management.dart';
import 'package:hair_main_street_admin/utils/screen_sizes.dart';
import 'package:hair_main_street_admin/widgets/drawer_widget.dart';
import 'package:hair_main_street_admin/widgets/page_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MyDrawerController drawerController = Get.put(MyDrawerController());
  NavigationController navigationController = Get.put(NavigationController());
  var colorHover = const Color(0xff673ab7).withValues(alpha: 0.2);

  // @override
  // void initState() {
  //   super.initState();
  //   int selectedPage = drawerController.selectedPage.value;
  // }

  List<IconData> icons = [
    Icons.home,
    Icons.people,
    Icons.shopping_cart,
    Icons.shop_two,
    Icons.reviews,
    Icons.report,
    Icons.payment,
    Icons.settings,
  ];
  Map<String, Widget> pages = {
    "Dashboard": DashboardPage(),
    "User Management": UserManagementPage(),
    "Orders": OrdersPage(),
    "Shops": ShopsPage(),
    "Reviews & Ratings": ReviewPage(),
    "Reports & Analytics": ReviewPage(),
    "Payments & Settlements": ReviewPage(),
    "Settings": ReviewPage(),
  };

  // onPageSelected(int index) {
  //   setState(() {
  //     selectedPage = index;
  //   });
  //   Navigator.pop(context);
  // }

  @override
  Widget build(BuildContext context) {
    var screenWidth = Get.width;
    return Scaffold(
      //drawerScrimColor: Color(0xFF673ab7).withValues(alpha: 0.1),
      drawer: Responsive.isMobile(context)
          ? Drawer(
              child: DrawerWidget(
                icons: icons,
                pages: pages,
              ),
            )
          : null,
      appBar: Responsive.isMobile(context)
          ? AppBar(
              title: Text(
                'Hair Main Street',
              ),
            )
          : null,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 2,
      //   scrolledUnderElevation: 2,
      //   //backgroundColor: const Color.fromARGB(255, 255, 224, 139),
      //   title: const Text(
      //     "Hair Main Street Admin",
      //     style: TextStyle(
      //       fontFamily: 'Lato',
      //       fontSize: 32,
      //       fontWeight: FontWeight.w700,
      //       color: Color(0xFF673AB7),
      //     ),
      //   ),
      //   actions: [
      //     PopupMenuButton<String>(
      //       onSelected: (value) {
      //         if (value == 'editUser') {
      //           // Handle "Edit User" option
      //           Navigator.of(context).push(
      //             MaterialPageRoute(
      //               builder: (context) => EditUserPage(),
      //             ),
      //           );
      //         } else if (value == 'createAdmin') {
      //           // Handle "Create New Admin" option
      //           Navigator.of(context).push(
      //             MaterialPageRoute(
      //               builder: (context) => CreateAdminPage(),
      //             ),
      //           );
      //         }
      //       },
      //       itemBuilder: (BuildContext context) {
      //         return <PopupMenuEntry<String>>[
      //           const PopupMenuItem<String>(
      //             value: 'editUser',
      //             child: ListTile(
      //               title: Text('Edit User'),
      //               leading: Icon(EvaIcons.edit),
      //             ),
      //           ),
      //           const PopupMenuItem<String>(
      //             value: 'createAdmin',
      //             child: ListTile(
      //               title: Text('Create New Admin'),
      //               leading: Icon(Icons.person_add),
      //             ),
      //           ),
      //         ];
      //       },
      //       padding: EdgeInsets.symmetric(
      //         horizontal: 8,
      //         vertical: 2,
      //       ),
      //       child: Container(
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(12),
      //           color: Color(0xff673ab7).withValues(alpha: 0.1),
      //         ),
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      //           child: Row(
      //             children: [
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   const Text(
      //                     "Full Name",
      //                     style: TextStyle(
      //                       fontSize: 18,
      //                       color: Color(0xff673ab7),
      //                       fontFamily: 'Raleway',
      //                     ),
      //                   ),
      //                   const Text(
      //                     "Admin",
      //                     style: TextStyle(
      //                       fontSize: 16,
      //                       color: Color(0xff673ab7),
      //                       fontFamily: 'Raleway',
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               const SizedBox(width: 10),
      //               Icon(
      //                 Icons.arrow_drop_down_rounded,
      //                 color: Color(
      //                   0xff673ab7,
      //                 ),
      //                 size: 24,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //     IconButton(
      //       onPressed: () {
      //         Get.to(UserManagementPage());
      //         ;
      //       },
      //       icon: const Icon(
      //         Icons.notifications,
      //         size: 24,
      //         color: Color(0xff673ab7),
      //       ),
      //       tooltip: 'Notifications',
      //     )
      //   ],
      // ),
      body: Row(
        children: [
          if (!Responsive.isMobile(context))
            DrawerWidget(
              icons: icons,
              pages: pages,
              //selectedPage: selectedPage,
            ),
          Expanded(
            //flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => navigationController.currentPage.value,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
