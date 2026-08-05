import 'package:get/get.dart';
import 'package:portfolio_website/app/routes/app_routes.dart';
import 'package:portfolio_website/modules/home/home_module.dart';

class AppPages {
  AppPages._();

  static const String initial = Routes.home;

  static final List<GetPage<dynamic>> routes = [...HomeModule.routes];
}
