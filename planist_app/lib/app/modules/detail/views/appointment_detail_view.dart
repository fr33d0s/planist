import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/appointment_model.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/widgets/add_appointment_dialog.dart';

class AppointmentDetailPage extends StatelessWidget {
  const AppointmentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final appointment = Get.arguments as AppointmentModel;

    return Obx(() {
      final updatedAppointment = controller.appointments.firstWhere(
        (item) => item.id == appointment.id,
        orElse: () => appointment,
      );

      return Scaffold(
        appBar: AppBar(
          title: Text(
            DateFormat('dd MMMM yyyy, HH:mm', 'tr')
                .format(updatedAppointment.dateTime),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(updatedAppointment.color),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                updatedAppointment.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                updatedAppointment.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Silme işlemi
                      controller.deleteAppointment(appointment.id!);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(),
                    child: const Text('Sil'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => AddAppointmentDialog(
                            initialAppointment: updatedAppointment,
                          ));
                    },
                    style: ElevatedButton.styleFrom(),
                    child: const Text('Düzenle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
