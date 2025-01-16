import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../daily/views/daily_view.dart';
import '../../monthly/views/monthly_view.dart';
import '../../weekly/views/weekly_view.dart';
import '../controllers/home_controller.dart';
import '../../appointment/views/add_appointment_dialog.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
          title: const Text(
            "PLANIST",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.blueGrey,
            onTap: (index) => controller.currentIndex.value = index,
            tabs: const [
              Tab(text: 'Günlük'),
              Tab(text: 'Haftalık'),
              Tab(text: 'Aylık'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DailyView(),
            WeeklyView(),
            MonthlyView(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF81C784),
          onPressed: () => Get.dialog(const AddAppointmentView()),
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
