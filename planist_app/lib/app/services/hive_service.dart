import 'package:hive/hive.dart';

import '../data/models/appointment_model.dart';

class HiveService {
  static Box<AppointmentModel> getAppointmentsBox() {
    return Hive.box<AppointmentModel>('appointments');
  }
}
