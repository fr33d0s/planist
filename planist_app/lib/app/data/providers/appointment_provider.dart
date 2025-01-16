import '../../services/hive_service.dart';
import '../models/appointment_model.dart';

class AppointmentProvider {
  final _box = HiveService.getAppointmentsBox();

  List<AppointmentModel> getAppointments() {
    return _box.values.cast<AppointmentModel>().toList();
  }

  Future<void> saveAppointments(List<AppointmentModel> appointments) async {
    await _box.clear();
    await _box.addAll(appointments);
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    await _box.add(appointment);
  }
}
