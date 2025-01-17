import 'package:get/get.dart';

import '../controllers/daily_view_controller.dart';

class DailyViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyViewController>(() => DailyViewController());
  }
}
