import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:planist_app/app/modules/daily/controllers/daily_view_controller.dart';

import '../../../data/models/appointment_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class DailyView extends GetView<DailyViewController> {
  const DailyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildLuxuryAppBar(),
      body: Obx(() => _buildBody()),
    );
  }

  PreferredSizeWidget _buildLuxuryAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () => controller.previousDay(),
      ),
      title: Obx(() => Column(
            children: [
              Text(
                DateFormat('EEEE', 'tr')
                    .format(controller.selectedDate.value)
                    .toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              Text(
                DateFormat('dd MMMM yyyy', 'tr')
                    .format(controller.selectedDate.value),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          )),
      actions: [
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: () => controller.nextDay(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    final dailyAppointments = controller.appointments
        .where((appointment) => DateUtils.isSameDay(
            appointment.dateTime, controller.selectedDate.value))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (dailyAppointments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: dailyAppointments.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return _LuxuryAppointmentCard(
          appointment: dailyAppointments[index],
          controller: Get.find<HomeController>(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: const Icon(
              Icons.event_available_rounded,
              size: 48,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Bugün için randevu bulunmuyor',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LuxuryAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  final HomeController controller;

  const _LuxuryAppointmentCard({
    required this.appointment,
    required this.controller,
  });

  String _getRemainingDays() {
    final now = DateTime.now();
    final appointmentDay = appointment.dateTime.day;
    final difference = appointmentDay - now.day;

    if (difference > 0) {
      return '$difference gün kaldı';
    } else {
      return '${difference.abs()} gün önce';
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Color(appointment.color);

    return GestureDetector(
      onTap: () {
        Get.find<HomeController>().selectAppointment(appointment);
        Get.toNamed(Routes.detail, arguments: appointment);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 20),
        child: Stack(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.event_note,
                      color: selectedColor,
                    ),
                    SizedBox(height: Get.height * .01),
                    _buildTimeChip(selectedColor),
                  ],
                ),
                SizedBox(width: Get.height * .04),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: Get.height * .14,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: selectedColor,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.height * .02,
                          vertical: Get.height * .01,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    appointment.title,
                                    style: TextStyle(
                                      fontSize: Get.height * .018,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                appointment.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: Get.height * .016,
                                ),
                              ),
                            ),
                            _buildFooter(selectedColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(Color color) {
    return Text(
      DateFormat('HH:mm a').format(appointment.dateTime),
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: Get.height * .016,
      ),
    );
  }

  Widget _buildFooter(Color color) {
    final now = DateTime.now();
    final appointmentDay = appointment.dateTime.day;
    final difference = appointmentDay - now.day;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (difference > 0)
          Text(
            _getRemainingDays(),
            style: TextStyle(
              fontSize: Get.height * .014,
            ),
          ),
      ],
    );
  }
}
