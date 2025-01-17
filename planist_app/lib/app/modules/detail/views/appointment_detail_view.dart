import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:planist_app/app/modules/detail/controllers/appointment_detail_view_controller.dart';

class AppointmentDetailPage extends StatelessWidget {
  const AppointmentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentDetailViewController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            DateFormat('dd MMMM yyyy, HH:mm', 'tr')
                .format(controller.updatedAppointment.value.dateTime),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Obx(
                () => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(controller.updatedAppointment.value.color),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Text(
                controller.updatedAppointment.value.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                controller.updatedAppointment.value.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.deleteAppointment();
                  },
                  style: ElevatedButton.styleFrom(),
                  child: const Text('Sil'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    controller.editAppointment();
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
  }
}
