import 'package:get/get.dart';
import 'package:portfolio_website/app/routes/app_routes.dart';
import 'package:portfolio_website/modules/home/bindings/home_binding.dart';
import 'package:portfolio_website/modules/home/views/home_screen.dart';

class HomeModule {
  HomeModule._();

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
