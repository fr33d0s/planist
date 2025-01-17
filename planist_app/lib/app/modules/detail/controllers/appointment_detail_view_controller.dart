import 'package:get/get.dart';
import '../../../data/models/appointment_model.dart';
import '../../home/controllers/home_controller.dart';

class AppointmentDetailViewController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  late final AppointmentModel appointment;
  late final Rx<AppointmentModel> updatedAppointment;

  @override
  void onInit() {
    super.onInit();
    appointment = Get.arguments as AppointmentModel;

    updatedAppointment = homeController.appointments
        .firstWhere(
          (item) => item.id == appointment.id,
          orElse: () => appointment,
        )
        .obs;
  }

  void deleteAppointment() {
    homeController.deleteAppointment(appointment.id!);
    Get.back();
  }

  void editAppointment() {
    Get.toNamed('/add', arguments: {
      'initialAppointment': updatedAppointment.value,
    });
  }
}
