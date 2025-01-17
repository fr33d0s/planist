import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:planist_app/app/modules/appointment/controllers/add_appointment_view_controller.dart';
import '../../../companents/general_snackbar.dart';
import '../../../data/models/appointment_model.dart';
import '../../home/controllers/home_controller.dart';

class AddAppointmentView extends GetView<AddAppointmentViewController> {
  const AddAppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          controller.initialAppointment == null
              ? 'Yeni Randevu'
              : 'Randevuyu Düzenle',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Randevu Bilgileri'),
              const SizedBox(height: 16),
              TextField(
                controller: controller.titleController,
                decoration: _buildInputDecoration(
                  'Randevu başlığını girin',
                  Icons.short_text_rounded,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.descriptionController,
                maxLines: 2,
                decoration: _buildInputDecoration(
                  'Randevu detaylarını girin',
                  Icons.notes_rounded,
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Tarih ve Saat'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDateTimeContainer(
                      context,
                      'Tarih',
                      Icons.calendar_today_rounded,
                      Obx(() => Text(
                            DateFormat('d MMM yyyy', 'tr_TR')
                                .format(controller.selectedDate.value),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) controller.selectedDate.value = date;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateTimeContainer(
                      context,
                      'Saat',
                      Icons.access_time_rounded,
                      Obx(() => Text(
                            controller.selectedTime.value.format(context),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: controller.selectedTime.value,
                        );
                        if (time != null) controller.selectedTime.value = time;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Kart Rengi Seçimi'),
              const SizedBox(height: 16),
              Obx(() {
                return Wrap(
                  spacing: 12,
                  children: List.generate(
                    controller.colorOptions.length,
                    (index) => GestureDetector(
                      onTap: () => controller.selectedColor.value =
                          controller.colorOptions[index],
                      child: CircleAvatar(
                        backgroundColor: Color(controller.colorOptions[index]),
                        radius: 20,
                        child: controller.selectedColor.value ==
                                controller.colorOptions[index]
                            ? const Icon(Icons.check)
                            : null,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            if (controller.titleController.text.isEmpty) {
              showGeneralSnackbar(
                title: 'Uyarı',
                message: 'Lütfen randevu başlığını girin',
              );

              return;
            }

            final dateTime = DateTime(
              controller.selectedDate.value.year,
              controller.selectedDate.value.month,
              controller.selectedDate.value.day,
              controller.selectedTime.value.hour,
              controller.selectedTime.value.minute,
            );

            final appointment = AppointmentModel(
              id: controller.initialAppointment?.id ??
                  DateTime.now().millisecondsSinceEpoch,
              title: controller.titleController.text,
              description: controller.descriptionController.text,
              dateTime: dateTime,
              color: controller.selectedColor.value,
              type: controller.initialAppointment?.type ?? 'daily',
            );

            if (controller.initialAppointment == null) {
              Get.find<HomeController>().addAppointment(appointment);
            } else {
              Get.find<HomeController>().updateAppointment(appointment);
            }

            Get.back();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            controller.initialAppointment == null ? 'Kaydet' : 'Güncelle',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.grey.shade900,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.blueGrey.shade700,
          width: 1,
        ),
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.grey.shade400,
      ),
      prefixIconColor: Colors.grey.shade400,
    );
  }

  Widget _buildDateTimeContainer(
    BuildContext context,
    String label,
    IconData icon,
    Widget child,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            child,
          ],
        ),
      ),
    );
  }
}
