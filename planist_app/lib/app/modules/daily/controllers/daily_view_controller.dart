import 'package:get/get.dart';

import '../../../data/models/appointment_model.dart';
import '../../../data/providers/appointment_provider.dart';

class DailyViewController extends GetxController {
  final AppointmentProvider appointmentProvider = AppointmentProvider();
  final RxList<AppointmentModel> appointments = <AppointmentModel>[].obs;
  final Rx<AppointmentModel?> selectedAppointment = Rx<AppointmentModel?>(null);
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  void loadAppointments() {
    appointments.value = appointmentProvider.getAppointments();
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    appointments.add(appointment);
    await appointmentProvider.saveAppointments(appointments);
  }

  Future<void> updateAppointment(AppointmentModel appointment) async {
    final index = appointments.indexWhere((e) => e.id == appointment.id);
    if (index != -1) {
      appointments[index] = appointment;
      await appointmentProvider.saveAppointments(appointments);
    }
  }

  Future<void> deleteAppointment(int id) async {
    appointments.removeWhere((appointment) => appointment.id == id);

    await appointmentProvider.saveAppointments(appointments);
  }

  void selectAppointment(AppointmentModel appointment) {
    selectedAppointment.value = appointment;
  }

  int getWeekNumber(DateTime date) {
    final adjustedDate = date.add(Duration(days: 4 - date.weekday));

    final firstDayOfYear = DateTime(adjustedDate.year, 1, 1);
    final daysDifference = adjustedDate.difference(firstDayOfYear).inDays;

    return ((daysDifference) ~/ 7) + 1;
  }

  void previousDay() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
  }

  void nextDay() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
  }
}
