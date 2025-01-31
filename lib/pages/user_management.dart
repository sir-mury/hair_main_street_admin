import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/controllers/userController.dart';
import 'package:hair_main_street_admin/models/userModel.dart';
import 'package:hair_main_street_admin/pages/dashboard_page.dart';
import 'package:recase/recase.dart';

class UserManagementPage extends StatefulWidget {
  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  UserController userController = Get.put(UserController());
  ScrollController horizontalScrollController = ScrollController();
  ScrollController verticalScrollController = ScrollController();

  @override
  void initState() {
    userController.fetchMyusers();
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> dataLabels = [
      "S/N",
      "Fullname",
      "Phonenumber",
      "Email",
      "User\ntype",
      "Actions",
    ];
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Color(0xFF673AB7),
      //   elevation: 0,
      //   scrolledUnderElevation: 0,
      //   title: const Text(
      //     "User Management",
      //     textAlign: TextAlign.center,
      //     style: TextStyle(
      //       fontFamily: 'Lato',
      //       fontSize: 26,
      //       fontWeight: FontWeight.w600,
      //       color: Colors.white,
      //     ),
      //   ),
      //   actions: [
      //     Obx(() {
      //       for (var user in userController.users) {
      //         String type = user!.getUserType();
      //         if (type == "buyer") {
      //           userController.buyers++;
      //         }
      //         if (user.isVendor! && user.isBuyer!) {
      //           userController.vendors++;
      //         }
      //         if (user.isAdmin!) {
      //           userController.admin++;
      //         }
      //       }
      //       return Padding(
      //         padding: const EdgeInsets.only(right: 20, top: 8, bottom: 4),
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   "Total Users: ${userController.users.length}",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w500,
      //                     fontFamily: 'Raleway',
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   width: 4,
      //                 ),
      //                 Text(
      //                   "Buyers: ${userController.buyers}",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w500,
      //                     fontFamily: 'Raleway',
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             const SizedBox(
      //               width: 16,
      //             ),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   "Vendors: ${userController.vendors}",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w500,
      //                     fontFamily: 'Raleway',
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   width: 4,
      //                 ),
      //                 Text(
      //                   "Admin: ${userController.admin}",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w500,
      //                     fontFamily: 'Raleway',
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       );
      //     }),
      //   ],
      //   toolbarHeight: kToolbarHeight,
      // ),
      body: Obx(
        () => userController.users.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : DataTable2(
                horizontalScrollController: horizontalScrollController,
                fixedTopRows: 1,
                isVerticalScrollBarVisible: true,
                isHorizontalScrollBarVisible: true,
                // dataRowMinHeight: 5,
                // dataRowMaxHeight: 50,
                showBottomBorder: true,
                showCheckboxColumn: true,
                columns: dataLabels
                    .map(
                      (label) => DataColumn2(
                        size: ColumnSize.L,
                        label: Text(
                          label,
                          //overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                rows: userController.users
                    .map(
                      (user) => DataRow2(
                        cells: [
                          DataCell(
                            Text("${userController.users.indexOf(user) + 1}"),
                          ),
                          DataCell(
                            Text(
                              user?.fullname ?? "No name",
                              //overflow: TextOverflow.visible,
                            ),
                          ),
                          DataCell(
                            Text(user?.phoneNumber ?? "No phone number"),
                          ),
                          DataCell(
                            Text(user?.email ?? "No email"),
                          ),
                          DataCell(
                            Text(user?.getUserType() ?? "No user type"),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Handle edit action
                                    print("Edit John Doe");
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Handle delete action
                                    print("Delete John Doe");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
      ),
      //drawer: AppDrawer(), // Place the drawer on the left side
    );
  }
}

class UserListTile extends StatelessWidget {
  final int index;
  final String name;
  final String userType;
  final String email;
  final String phoneNumber;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  UserListTile({
    required this.name,
    required this.index,
    required this.email,
    required this.phoneNumber,
    required this.userType,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var colorHover = const Color.fromARGB(255, 200, 242, 237);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xFF673AB7).withValues(alpha: 0.4),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        dense: true,
        focusColor: colorHover,
        //tileColor: colorHover,
        // hoverColor: colorHover,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.all(5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "$index",
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              name.titleCase,
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              phoneNumber,
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              email,
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              userType.capitalizeFirst!,
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              "Actions",
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
        subtitle: Text(
          "User Type: ${userType.titleCase}",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Raleway',
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
