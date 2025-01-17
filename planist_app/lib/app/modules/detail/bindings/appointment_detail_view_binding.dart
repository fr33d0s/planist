import 'package:get/get.dart';
import '../controllers/appointment_detail_view_controller.dart';

class AppointmentDetailViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentDetailViewController>(
        () => AppointmentDetailViewController());
  }
}
