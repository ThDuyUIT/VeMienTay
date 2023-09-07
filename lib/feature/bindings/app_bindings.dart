// import 'package:booking_transition_flutter/feature/controller.dart/account_controller.dart';
import 'package:booking_transition_flutter/feature/controller/choose_route_controller.dart';
import 'package:booking_transition_flutter/feature/controller/cities_controller.dart';
import 'package:booking_transition_flutter/feature/controller/detailticket_controller.dart';
import 'package:booking_transition_flutter/feature/controller/feature_routes_controller.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Tickets/detail_ticket.dart';
import 'package:get/get.dart';

import '../controller/account_controller.dart';
import '../controller/bookedticket_controller.dart';

class AppBinding {
  Future<void> dependencies() async {
    Get.put(AccountController());
    Get.put(CitiesController());
    Get.put(BookedTicketController());
    Get.put(ChooseRouteController());
    Get.put(FeatureRouteController());
    Get.put(DetailTicketController());
  }
}
