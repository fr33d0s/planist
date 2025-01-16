// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import '../modules/detail/views/appointment_detail_view.dart';
import '../modules/home/bindings/home_bindings.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.detail,
      page: () => const AppointmentDetailPage(),
      binding: HomeBinding(),
    ),
  ];
}
