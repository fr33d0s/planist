import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/models/appointment_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class MonthlyView extends GetView<HomeController> {
  const MonthlyView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDay = DateTime.now().obs;

    return Scaffold(
      appBar: _buildLuxuryAppBar(context, selectedDay),
      body: _buildBody(context, selectedDay),
    );
  }

  PreferredSizeWidget _buildLuxuryAppBar(
      BuildContext context, Rx<DateTime> selectedDay) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () {
          selectedDay.value = DateTime(
            selectedDay.value.year,
            selectedDay.value.month - 1,
          );
        },
      ),
      title: Obx(() => Column(
            children: [
              Text(
                'AY ${DateFormat('M', 'tr').format(selectedDay.value)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              Text(
                DateFormat('MMMM yyyy', 'tr').format(selectedDay.value),
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
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            selectedDay.value = DateTime(
              selectedDay.value.year,
              selectedDay.value.month + 1,
            );
          },
        ),
      ],
    );
  }

  Column _buildBody(BuildContext context, Rx<DateTime> selectedDay) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Eğer gün seçilmediyse varsayılan olarak bugüne veya en yakın tarihe ayarla
      if (controller.appointments.isNotEmpty) {
        final today = DateTime.now();
        final todaysAppointments = controller.appointments
            .where((appointment) => isSameDay(appointment.dateTime, today))
            .toList();

        if (todaysAppointments.isNotEmpty) {
          selectedDay.value = today;
        } else {
          // Bugün yoksa en yakın tarihi bul
          final upcomingAppointments = controller.appointments
              .where((appointment) => appointment.dateTime.isAfter(today))
              .toList()
            ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

          if (upcomingAppointments.isNotEmpty) {
            selectedDay.value = upcomingAppointments.first.dateTime;
          } else {
            // Hiçbir randevu yoksa mevcut ayın ilk günü
            selectedDay.value = DateTime(today.year, today.month, 1);
          }
        }
      }
    });

    return Column(
      children: [
        const SizedBox(height: 10),
        _buildExpandedCalendar(context, selectedDay),
        Expanded(
          child: Obx(
            () => _buildMonthlyAppointmentsList(context, selectedDay.value),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyAppointmentsList(
      BuildContext context, DateTime selectedDay) {
    final dailyAppointments = controller.appointments
        .where((appointment) => isSameDay(appointment.dateTime, selectedDay))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (dailyAppointments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: dailyAppointments.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return _AppointmentCard(
          appointment: dailyAppointments[index],
        );
      },
    );
  }

  Widget _buildExpandedCalendar(
      BuildContext context, Rx<DateTime> selectedDay) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: selectedDay.value,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(selectedDay.value, day),
        onDaySelected: (selected, focused) {
          selectedDay.value = selected;
        },
        onPageChanged: (focused) {
          final firstOfMonth = DateTime(focused.year, focused.month, 1);
          final lastOfMonth = DateTime(focused.year, focused.month + 1, 0);

          final appointmentsInMonth = controller.appointments
              .where((appointment) =>
                  appointment.dateTime.isAfter(
                      firstOfMonth.subtract(const Duration(days: 1))) &&
                  appointment.dateTime
                      .isBefore(lastOfMonth.add(const Duration(days: 1))))
              .toList();

          if (appointmentsInMonth.isNotEmpty) {
            final today = DateTime.now();
            final todaysAppointments = appointmentsInMonth
                .where((appointment) => isSameDay(appointment.dateTime, today))
                .toList();

            if (todaysAppointments.isNotEmpty) {
              selectedDay.value = today;
            } else {
              appointmentsInMonth
                  .sort((a, b) => a.dateTime.compareTo(b.dateTime));
              selectedDay.value = appointmentsInMonth.first.dateTime;
            }
          } else {
            selectedDay.value = firstOfMonth;
          }
        },
        eventLoader: (day) {
          return controller.appointments
              .where((appointment) => isSameDay(appointment.dateTime, day))
              .toList();
        },
        headerVisible: false,
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: Colors.white10,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(
            color: Colors.red[300],
          ),
          defaultTextStyle: const TextStyle(),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: const TextStyle(
            color: Color(0xFF6E7191),
            fontWeight: FontWeight.w500,
          ),
          weekendStyle: TextStyle(
            color: Colors.red[300],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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
              Icons.calendar_today_rounded,
              size: 48,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Bu ay için randevu bulunmuyor',
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

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const _AppointmentCard({
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
