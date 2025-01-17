import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../data/models/appointment_model.dart';

class AddAppointmentViewController extends GetxController {
  final AppointmentModel? initialAppointment;

  AddAppointmentViewController({this.initialAppointment}) {
    initializeDateFormatting('tr_TR', null);
  }

  late final TextEditingController titleController = TextEditingController(
    text: initialAppointment?.title ?? '',
  );

  late final TextEditingController descriptionController =
      TextEditingController(
    text: initialAppointment?.description ?? '',
  );

  final Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());
  final Rx<TimeOfDay> selectedTime = Rx<TimeOfDay>(TimeOfDay.now());
  final Rx<int> selectedColor = Rx<int>(Colors.blueGrey.value);

  final List<int> colorOptions = [
    const Color(0xFFEF9A9A).value,
    const Color(0xFF81D4FA).value,
    const Color(0xFF81C784).value,
    const Color(0xFFFFCC80).value,
    const Color(0xFFCE93D8).value,
  ];

  @override
  void onInit() {
    super.onInit();
    if (initialAppointment != null) {
      selectedDate.value = initialAppointment!.dateTime;
      selectedTime.value = TimeOfDay.fromDateTime(initialAppointment!.dateTime);
      selectedColor.value = initialAppointment!.color;
    }
  }
}
