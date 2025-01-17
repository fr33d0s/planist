import 'package:get/get.dart';

import '../../appointment/controllers/add_appointment_view_controller.dart';
import '../../daily/controllers/daily_view_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AddAppointmentViewController>(
        () => AddAppointmentViewController());
    Get.lazyPut<DailyViewController>(() => DailyViewController());
  }
}
