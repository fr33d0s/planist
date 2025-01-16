import 'package:get/get.dart';

import '../../../data/models/appointment_model.dart';
import '../../../data/providers/appointment_provider.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final AppointmentProvider appointmentProvider = AppointmentProvider();
  final RxList<AppointmentModel> appointments = <AppointmentModel>[].obs;
  final RxInt currentIndex = 0.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final selectedDay = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;

  final Rx<AppointmentModel?> selectedAppointment = Rx<AppointmentModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  void nextDay() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
  }

  void previousDay() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
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
    // Adjust the date to the nearest Thursday in the week (ISO 8601 standard)
    final adjustedDate = date.add(Duration(days: 4 - date.weekday));

    // Get the first day of the year and the difference in days
    final firstDayOfYear = DateTime(adjustedDate.year, 1, 1);
    final daysDifference = adjustedDate.difference(firstDayOfYear).inDays;

    // Calculate the week number
    return ((daysDifference) ~/ 7) + 1;
  }
}
