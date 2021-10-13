import 'package:get/get.dart';

import 'package:spacesignal/app/modules/home/bindings/home_binding.dart';
import 'package:spacesignal/app/modules/home/views/onboarding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => OnbordingScreen(),
      binding: HomeBinding(),
    ),
  ];
}
