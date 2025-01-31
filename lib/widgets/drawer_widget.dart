import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/controllers/drawer_controller.dart';
import 'package:hair_main_street_admin/controllers/navigation_controller.dart';
import 'package:hair_main_street_admin/utils/app_colors.dart';
import 'package:hair_main_street_admin/utils/screen_sizes.dart';

class DrawerWidget extends StatefulWidget {
  final Map<String, Widget>? pages;
  final List<IconData>? icons;
  final Function? onPageChange;
  int? selectedPage;
  VoidCallback? newPage;
  DrawerWidget(
      {super.key,
      this.icons,
      this.pages,
      this.selectedPage,
      this.newPage,
      this.onPageChange});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  MyDrawerController drawerController = Get.find<MyDrawerController>();
  NavigationController navigationController = Get.find<NavigationController>();
  List<GlobalKey<TooltipState>> tooltipKeys =
      []; // List to store unique GlobalKeys

  @override
  void initState() {
    super.initState();
    // Initialize the list of GlobalKeys
    if (widget.pages != null) {
      tooltipKeys = List.generate(
          widget.pages!.length, (index) => GlobalKey<TooltipState>());
    }
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = Get.width;
    Color colorHover = AppColors.shade1;
    return Obx(() {
      if (Responsive.isDesktop(context)) {
        return buildDesktop(screenWidth, colorHover);
      } else if (Responsive.isMobile(context)) {
        return buildMobileView(screenWidth, colorHover);
      } else if (Responsive.isTablet(context)) {
        return buildTabletView(screenWidth);
      } else {
        return Container();
      }
    });
  }

  Drawer buildDesktop(num screenWidth, Color colorHover) {
    if (drawerController.isDrawerOpen.value) {
      //print("running this");
      return Drawer(
        shape: BeveledRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: AppColors.main,
        width: screenWidth * 0.20,
        child: ListView(
          //padding: EdgeInsets.all(8),
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 12,
                    top: 4,
                  ),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: screenWidth * 0.12,
                  height: 50,
                  child: Image.asset(
                    'assets/appIcons/HMS main.png',
                    fit: BoxFit.contain,
                  ),
                ),
                InkWell(
                  onTap: () {
                    drawerController.toggleDrawer();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Icon(
                      Icons.menu,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            ...List.generate(
              widget.pages!.length,
              (index) {
                return ListTile(
                  leading: Icon(
                    widget.icons![index],
                    color: Colors.white,
                    size: 20,
                  ),
                  hoverColor: colorHover,
                  tileColor:
                      navigationController.currentPage.value.runtimeType ==
                              widget.pages!.values.elementAt(index).runtimeType
                          ? AppColors.shade4
                          : null,
                  focusColor: const Color.fromARGB(255, 255, 224, 139),
                  title: Text(
                    widget.pages!.keys.elementAt(index),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato',
                    ),
                  ),
                  onTap: () {
                    navigationController
                        .onPageChanged(widget.pages!.values.elementAt(index));
                  },
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide.none,
        ),
        backgroundColor: AppColors.main,
        width: screenWidth * 0.055,
        child: ListView(
          //padding: EdgeInsets.all(8),
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  drawerController.toggleDrawer();
                  //Navigator.pop(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            ...List.generate(
              widget.pages!.length,
              (index) => InkWell(
                hoverColor: colorHover,
                onTap: () {
                  navigationController
                      .onPageChanged(widget.pages!.values.elementAt(index));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  color: navigationController.currentPage.value.runtimeType ==
                          widget.pages!.values.elementAt(index).runtimeType
                      ? AppColors.shade4
                      : null,
                  child: Center(
                    child: Icon(
                      widget.icons![index],
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Drawer buildMobileView(num screenWidth, Color colorHover) {
    return Drawer(
      backgroundColor: AppColors.main,
      width: screenWidth * 0.10,
      child: ListView(
        //padding: EdgeInsets.all(8),
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 12,
                  top: 4,
                ),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: screenWidth * 0.20,
                height: 50,
                child: Image.asset(
                  'assets/appIcons/HMS main.png',
                  fit: BoxFit.contain,
                ),
              ),
              InkWell(
                onTap: () {
                  drawerController.closeDrawer();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          ...List.generate(
            widget.pages!.length,
            (index) {
              return ListTile(
                leading: Icon(
                  widget.icons![index],
                  color: Colors.white,
                  size: 20,
                ),
                hoverColor: colorHover,
                // selectedTileColor: Color(0xff673ab7),
                tileColor: navigationController.currentPage.value.runtimeType ==
                        widget.pages!.values.elementAt(index).runtimeType
                    ? AppColors.shade4
                    : null,
                focusColor: const Color.fromARGB(255, 255, 224, 139),
                title: Text(
                  widget.pages!.keys.elementAt(index),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lato',
                  ),
                ),
                onTap: () {
                  navigationController
                      .onPageChanged(widget.pages!.values.elementAt(index));
                  // onPageSelected(index);
                  // print(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Drawer buildTabletView(num screenWidth) {
    return Drawer(
      shape: BeveledRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: AppColors.main,
      width: screenWidth * 0.055,
      child: ListView(
        children: [
          // Align(
          //   alignment: Alignment.center,
          //   child: InkWell(
          //     hoverColor: AppColors.lighterMain,
          //     onTap: () {
          //       drawerController.toggleDrawer();
          //       //Navigator.pop(context);
          //     },
          //     child: Padding(
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //       child: Icon(
          //         Icons.menu,
          //         size: 30,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 4,
          // ),
          ...List.generate(
            widget.pages!.length,
            (index) => InkWell(
              onLongPress: () {
                tooltipKeys[index].currentState?.ensureTooltipVisible();
              },
              onTap: () {
                navigationController
                    .onPageChanged(widget.pages!.values.elementAt(index));
              },
              child: Tooltip(
                triggerMode: TooltipTriggerMode.manual,
                key: tooltipKeys[index],
                preferBelow: false,
                message: widget.pages!.keys.elementAt(index),
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.shade7,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  color: navigationController.currentPage.value.runtimeType ==
                          widget.pages!.values.elementAt(index).runtimeType
                      ? AppColors.shade4
                      : null,
                  child: Center(
                    child: Icon(
                      widget.icons![index],
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
