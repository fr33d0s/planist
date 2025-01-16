import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/models/appointment_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class WeeklyView extends GetView<HomeController> {
  const WeeklyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            controller.focusedDay.value = controller.focusedDay.value.subtract(
              const Duration(days: 7),
            );
            controller.update();
          },
        ),
        title: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'HAFTA ${controller.getWeekNumber(controller.focusedDay.value)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              Text(
                DateFormat('MMMM yyyy', 'tr')
                    .format(controller.focusedDay.value),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              controller.focusedDay.value = controller.focusedDay.value.add(
                const Duration(days: 7),
              );
              controller.update();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildWeekCalendar(
            context,
            controller.selectedDay,
            controller.focusedDay,
          ),
          Expanded(
            child: Obx(
              () => _buildAppointmentsList(
                context,
                controller.selectedDay.value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar(
      BuildContext context, Rx<DateTime> selectedDay, Rx<DateTime> focusedDay) {
    return Obx(
      () => TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: focusedDay.value,
        calendarFormat: CalendarFormat.week,
        selectedDayPredicate: (day) => isSameDay(selectedDay.value, day),
        onDaySelected: (selected, focused) {
          selectedDay.value = selected;
          focusedDay.value = focused;
        },
        onPageChanged: (focused) {
          focusedDay.value = focused;
        },
        headerVisible: false,
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          todayDecoration: const BoxDecoration(
            color: Colors.white10,
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          defaultTextStyle: const TextStyle(
            color: Colors.white,
          ),
          weekendTextStyle: const TextStyle(
            color: Color(0xFFEF9A9A),
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          outsideTextStyle: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          weekendStyle: TextStyle(
            color: Color(0xFFEF9A9A),
            fontWeight: FontWeight.w500,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          disabledBuilder: (context, day, focusedDay) {
            return Center(
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(BuildContext context, DateTime selectedDay) {
    final weeklyAppointments = controller.appointments
        .where((appointment) => isSameDay(appointment.dateTime, selectedDay))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (weeklyAppointments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: weeklyAppointments.length,
      itemBuilder: (context, index) {
        return _TimelineAppointmentCard(
          appointment: weeklyAppointments[index],
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
              Icons.event_note_rounded,
              size: 48,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Bu gün için randevu bulunmuyor',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const _TimelineAppointmentCard({
    required this.appointment,
  });

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          DateFormat('HH:mm a').format(appointment.dateTime),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: Get.height * .016,
          ),
        ),
      ],
    );
  }
}
