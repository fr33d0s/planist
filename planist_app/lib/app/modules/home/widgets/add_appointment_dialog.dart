import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../../companents/general_snackbar.dart';
import '../../../data/models/appointment_model.dart';
import '../controllers/home_controller.dart';

class AddAppointmentDialog extends StatelessWidget {
  final AppointmentModel? initialAppointment;

  const AddAppointmentDialog({super.key, this.initialAppointment});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr_TR', null);

    final titleController = TextEditingController(
      text: initialAppointment?.title ?? '',
    );
    final descriptionController = TextEditingController(
      text: initialAppointment?.description ?? '',
    );
    final selectedDate = (initialAppointment?.dateTime ?? DateTime.now()).obs;
    final selectedTime = TimeOfDay.fromDateTime(
      initialAppointment?.dateTime ?? DateTime.now(),
    ).obs;
    final selectedColor =
        (initialAppointment?.color ?? Colors.blueGrey.value).obs;

    final colorOptions = [
      const Color(0xFFEF9A9A).value,
      const Color(0xFF81D4FA).value,
      const Color(0xFF81C784).value,
      const Color(0xFFFFCC80).value,
      const Color(0xFFCE93D8).value,
    ];

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            initialAppointment == null ? 'Yeni Randevu' : 'Randevuyu Düzenle',
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
                  controller: titleController,
                  decoration: _buildInputDecoration(
                    'Başlık',
                    'Randevu başlığını girin',
                    Icons.short_text_rounded,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: _buildInputDecoration(
                    'Açıklama',
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
                                  .format(selectedDate.value),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate.value,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) selectedDate.value = date;
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
                              selectedTime.value.format(context),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime.value,
                          );
                          if (time != null) selectedTime.value = time;
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
                      colorOptions.length,
                      (index) => GestureDetector(
                        onTap: () => selectedColor.value = colorOptions[index],
                        child: CircleAvatar(
                          backgroundColor: Color(colorOptions[index]),
                          radius: 20,
                          child: selectedColor.value == colorOptions[index]
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
              if (titleController.text.isEmpty) {
                showGeneralSnackbar(
                  title: 'Uyarı',
                  message: 'Lütfen randevu başlığını girin',
                );

                return;
              }

              final dateTime = DateTime(
                selectedDate.value.year,
                selectedDate.value.month,
                selectedDate.value.day,
                selectedTime.value.hour,
                selectedTime.value.minute,
              );

              final appointment = AppointmentModel(
                id: initialAppointment?.id ??
                    DateTime.now().millisecondsSinceEpoch,
                title: titleController.text,
                description: descriptionController.text,
                dateTime: dateTime,
                color: selectedColor.value,
                type: initialAppointment?.type ?? 'daily',
              );

              if (initialAppointment == null) {
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
              initialAppointment == null ? 'Kaydet' : 'Güncelle',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String label,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      prefixIcon: Icon(icon, size: 20),
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
