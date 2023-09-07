import 'package:booking_transition_flutter/feature/controller/cities_controller.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/list_item_route.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Tickets/list_item_ticket.dart';
import 'package:booking_transition_flutter/feature/services/get_data_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/ticket.dart';

class DetailTicketController {
  late Ticket ticket;
  late List<String> seats;
  ListItemTicket itemTicket = ListItemTicket.non_para();
  //late ListItemRoute itemRoute;
  Future getInfoTicket(String idTicket) async {
    ticket = await GetDataService.fetchATicket(idTicket);

    print(ticket.idTransition);
  }

  Future getSeat(String idTicket) async {
    seats = await GetDataService.fetchSeats(idTicket);
    return seats;
  }

  Future getInfoRoute(String idRoute) async {
    itemTicket = await GetDataService.fetchInfoRoute(idRoute);
    final _citiesController = Get.find<CitiesController>();
    await _citiesController.setListCities();

    _citiesController.cities.forEach((element) {
      if (element.idCity == itemTicket.from) {
        itemTicket.from = element.nameCity;
      } else {
        if (element.idCity == itemTicket.where) {
          itemTicket.where = element.nameCity;
        }
      }
    });

    print(itemTicket.from);
  }

  // Future<void> searchInGoogleMaps(String query) async {
  //   Position userLocation = await getCurrentLocation();
  //   String destination = Uri.encodeComponent(query);
  //   // final url =
  //   //     'https://www.google.com/maps/search/?api=1&destination=$destination';
  //   final url = 'https://www.google.com/maps/dir/?api=1'
  //       '&origin=${userLocation.latitude},${userLocation.longitude}'
  //       '&destination=$destination'
  //       '&travelmode=transit';

  //   Uri ggUrl = Uri.parse(url);
  //   if (await canLaunchUrl(ggUrl)) {
  //     await launchUrl(ggUrl);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> searchInGoogleMaps(String query) async {
    // Request location permissions
    var locationPermission = await Permission.location.request();

    if (locationPermission.isGranted) {
      // Location permission is granted, proceed to get the user's location
      Position userLocation = await getCurrentLocation();
      String destination = Uri.encodeComponent(query);

      final url = 'https://www.google.com/maps/dir/?api=1'
          '&origin=${userLocation.latitude},${userLocation.longitude}'
          '&destination=$destination'
          '&travelmode=transit';

      Uri ggUrl = Uri.parse(url);
      if (await canLaunchUrl(ggUrl)) {
        await launchUrl(ggUrl);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      // Handle the case where the user denied location permissions
      // You can show a message or take appropriate action here
      print('Location permission denied.');
    }
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }
}
