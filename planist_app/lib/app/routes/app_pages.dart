import 'package:get/get.dart';
import 'package:planist_app/app/modules/appointment/views/add_appointment_dialog.dart';
import 'package:planist_app/app/modules/daily/bindings/daily_view_bindings.dart';
import 'package:planist_app/app/modules/daily/views/daily_view.dart';
import 'package:planist_app/app/modules/detail/bindings/appointment_detail_view_binding.dart';
import '../modules/appointment/bindings/add_appointment_view_inding.dart';
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
      binding: AppointmentDetailViewBinding(),
    ),
    GetPage(
      name: Routes.add,
      page: () => const AddAppointmentView(),
      binding: AddAppointmentViewInding(),
    ),
    GetPage(
      name: Routes.daily,
      page: () => const DailyView(),
      binding: DailyViewBindings(),
    ),
  ];
}
