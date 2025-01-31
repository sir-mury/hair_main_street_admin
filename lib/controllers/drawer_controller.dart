import 'package:get/get.dart';

class MyDrawerController {
  RxBool isDrawerOpen = true.obs;
  RxInt selectedPage = 0.obs;

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  void closeDrawer() {
    Get.back();
  }
}
