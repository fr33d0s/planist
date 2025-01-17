import 'package:get/get.dart';
import 'package:planist_app/app/modules/appointment/controllers/add_appointment_view_controller.dart';

class AddAppointmentViewInding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAppointmentViewController>(
        () => AddAppointmentViewController());
  }
}
