import 'package:booking_transition_flutter/feature/controller/account_controller.dart';
import 'package:booking_transition_flutter/feature/controller/choose_route_controller.dart';
import 'package:booking_transition_flutter/feature/models/account_information.dart';
import 'package:booking_transition_flutter/feature/models/city_point.dart';
import 'package:booking_transition_flutter/feature/models/ticket.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/find_route.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/list_item_route.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/search.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/seat_item.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Tickets/list_item_ticket.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/cities_controller.dart';

// class GetDataService {
//   Future<AccountInformation> fetchAccountInformation(String id) async {
//     DatabaseReference userRef =
//         FirebaseDatabase.instance.ref().child('KHACHHANG').child(id);
//     late AccountInformation accountInformation;

//     userRef.once().then((DataSnapshot dataSnapshot) {
//       if (dataSnapshot.value != null) {
//         Map<dynamic, dynamic> userData = snapshot.value;

//         accountInformation = AccountInformation(
//             fullName: userData['hoTen'],
//             gender: userData['gioiTinh'],
//             mail: userData['tenTk'],
//             phoneNumbers: userData['sdt'],
//             avatarUrl: userData['anhDaiDien']);
//       }
//       return accountInformation;
//     });
//   }
// }

class GetDataService {
  static Future<AccountInformation> fetchAccountInformation(String id) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref('KHACHHANG/KH$id');
    AccountInformation accountInformation = AccountInformation.non_para();
    DatabaseEvent event = await userRef.once();

    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> userData =
          event.snapshot.value as Map<dynamic, dynamic>;

      accountInformation = AccountInformation(
        fullName: userData['fullname'],
        gender: userData['gender'],
        mail: userData['username'],
        phoneNumbers: userData['phonenums'],
        avatarUrl: userData['avatar'],
      );

      //print(accountInformation.mail);

      //return accountInformation;
    } else {
      accountInformation.fullName = '';
    }
    return accountInformation;
  }

  static Future fetchCityPoints() async {
    try {
      final List<CityPoint> cities = [];
      DatabaseReference cityRef =
          FirebaseDatabase.instance.ref().child('DIADIEM');
      DatabaseEvent event = await cityRef.once();

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> citiesData =
            event.snapshot.value as Map<dynamic, dynamic>;

        citiesData.forEach((key, value) {
          CityPoint city = CityPoint(
              idCity: key,
              nameCity: value['namecity'],
              urlImage: value['imgcity']);
          cities.add(city);
        });

        return cities;
      }
    } catch (e) {
      print('fail fetch data DIADIEM');
    }
  }

  static Future fetchRoutes() async {
    List<ListItemTicket> routes = [];

    DatabaseReference routesRef =
        FirebaseDatabase.instance.ref().child('CHUYENXE');
    DatabaseEvent event = await routesRef.once();

    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> routesData =
          event.snapshot.value as Map<dynamic, dynamic>;

      for (var entry in routesData.entries) {
        var keyRoute = entry.key;
        var valueRoute = entry.value;

        if (StateFindRoute.startCity!.idCity == valueRoute['startpoint'] &&
            StateFindRoute.endCity!.idCity == valueRoute['endpoint'] &&
            StateFindRoute.departureDate == valueRoute['departuredate']) {
          DatabaseReference vehicleRef =
              FirebaseDatabase.instance.ref().child('XE');
          DatabaseEvent vehicleEvent = await vehicleRef.once();

          if (vehicleEvent.snapshot.value != null) {
            Map<dynamic, dynamic> vehicleData =
                vehicleEvent.snapshot.value as Map<dynamic, dynamic>;

            for (var vehicleEntry in vehicleData.entries) {
              var keyVehicle = vehicleEntry.key;
              var valueVehicle = vehicleEntry.value;

              if (valueRoute['idvehicle'] == keyVehicle) {
                ListItemTicket itemTicket = ListItemTicket(
                    nameTicket: valueVehicle['namevehicle'],
                    departureDate: valueRoute['departuredate'],
                    departureTime: valueRoute['departuretime'],
                    pricesTicket: valueRoute['priceticket'],
                    imageVehicle: valueVehicle['imgvehicle'],
                    numberCar: keyVehicle,
                    idRoute: keyRoute,
                    capacity: valueVehicle['capacity']);

                routes.add(itemTicket);
              }
            }
          }
        }
      }

      print(routes.length);
      return routes; // This line should be outside the for loop
    }
  }

  static Future fetchATicket(String idTicket) async {
    late Ticket ticket;
    DatabaseReference ticketRef = FirebaseDatabase.instance.ref().child('VE');
    DatabaseReference keyTicketRef = ticketRef.child(idTicket);
    DatabaseEvent event = await keyTicketRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot != null) {
      Map<dynamic, dynamic> ticketData =
          snapshot.value as Map<dynamic, dynamic>;
      ticket = Ticket(
          idAccount: ticketData['idaccount'],
          idTransition: ticketData['idtransition'],
          pricesTotal: ticketData['pricestotal'],
          methodPayment: ticketData['methodpayment'],
          statusTicket: ticketData['statusticket'],
          statusPayment: ticketData['statuspayment']);

      return ticket;
      //tick
      //get and return data as ticket
    }
  }

  static Future fetchSeats(String idTicket) async {
    DatabaseReference detailRef = FirebaseDatabase.instance.ref().child('CTVE');
    DatabaseEvent event = await detailRef.once();
    List<String> numSeats = [];
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> detailTicketData =
          event.snapshot.value as Map<dynamic, dynamic>;

      for (var detailEntry in detailTicketData.entries) {
        var keyDetail = detailEntry.key;
        var valueDetail = detailEntry.value;

        if (idTicket == valueDetail['idticket']) {
          numSeats.add(valueDetail['numberseat']);
        }
      }
      print(numSeats.length);
      return numSeats;
    }
  }

  static Future fetchInfoRoute(String idRoute) async {
    late ListItemTicket route = ListItemTicket.non_para();
    DatabaseReference routeRef =
        FirebaseDatabase.instance.ref().child('CHUYENXE');
    DatabaseReference keyRouteRef = routeRef.child(idRoute);
    DatabaseEvent event = await keyRouteRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> routeData =
          event.snapshot.value as Map<dynamic, dynamic>;
      route.from = routeData['startpoint'];
      route.where = routeData['endpoint'];
      route.numberCar = routeData['idvehicle'];
      route.departureDate = routeData['departuredate'];
      route.departureTime = routeData['departuretime'];

      return route;
    }
  }

  static Future fetchBookedTicket(int typeOfTicket) async {
    List<ListItemTicket> bookedTickets = [];
    final _accountController = Get.find<AccountController>();
    String formatedAccountID = 'KH${_accountController.uId}';
    //fetch data from VE branch
    DatabaseReference ticketRef = FirebaseDatabase.instance.ref().child('VE');
    DatabaseEvent event = await ticketRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> bookedTicketData =
          event.snapshot.value as Map<dynamic, dynamic>;

      for (var ticketEntry in bookedTicketData.entries) {
        var keyTicket = ticketEntry.key;
        var valueTicket = ticketEntry.value;

        //print(valueTicket['idAccount']);

        //combine with condition current id account and ticket status
        if (formatedAccountID == valueTicket['idaccount'] &&
            typeOfTicket.toString() == valueTicket['statusticket']) {
          //fetch data from CHUYENXE branch
          DatabaseReference routeRef =
              FirebaseDatabase.instance.ref().child('CHUYENXE');
          DatabaseEvent routeEvent = await routeRef.once();

          if (routeEvent.snapshot.value != null) {
            Map<dynamic, dynamic> routeData =
                routeEvent.snapshot.value as Map<dynamic, dynamic>;

            for (var routeEntry in routeData.entries) {
              var keyRoute = routeEntry.key;
              var valueRoute = routeEntry.value;
              //combine with condition id transition
              if (keyRoute == valueTicket['idtransition']) {
                print(keyRoute);
                DatabaseReference vehicleRef =
                    FirebaseDatabase.instance.ref().child('XE');
                DatabaseEvent vehicleEvent = await vehicleRef.once();

                if (vehicleEvent.snapshot.value != null) {
                  Map<dynamic, dynamic> vehicleData =
                      vehicleEvent.snapshot.value as Map<dynamic, dynamic>;

                  for (var vehicleEntry in vehicleData.entries) {
                    var keyVehicle = vehicleEntry.key;
                    var valueVehicle = vehicleEntry.value;

                    if (keyVehicle == valueRoute['idvehicle']) {
                      print(keyVehicle);
                      ListItemTicket item = ListItemTicket(
                          nameTicket: valueVehicle['namevehicle'],
                          departureDate: valueRoute['departuredate'],
                          departureTime: valueRoute['departuretime'],
                          pricesTicket: valueRoute['priceticket'],
                          imageVehicle: valueVehicle['imgvehicle'],
                          numberCar: keyVehicle,
                          idRoute: keyRoute,
                          capacity: valueVehicle['capacity']);

                      item.idTicket = keyTicket;

                      bookedTickets.add(item);
                    }
                  }
                }
              }
            }
          }
        }
      }
      return bookedTickets;
    }
  }

  static Future fetchBookedSeat() async {
    List<SeatItem> bookedSeat = [];
    final _chooseRouteController = Get.find<ChooseRouteController>();
    DatabaseReference routeRef =
        FirebaseDatabase.instance.ref().child('CHUYENXE');
    DatabaseEvent routeEvent = await routeRef.once();

    if (routeEvent.snapshot.value != null) {
      Map<dynamic, dynamic> routeData =
          routeEvent.snapshot.value as Map<dynamic, dynamic>;

      for (var routeEntry in routeData.entries) {
        var keyRoute = routeEntry.key;
        var valueRoute = routeEntry.value;

        if (_chooseRouteController.item.idRoute == keyRoute) {
          //print(keyRoute);
          DatabaseReference ticketRef =
              FirebaseDatabase.instance.ref().child('VE');
          DatabaseEvent ticketEvent = await ticketRef.once();

          if (ticketEvent.snapshot.value != null) {
            Map<dynamic, dynamic> ticketData =
                ticketEvent.snapshot.value as Map<dynamic, dynamic>;

            for (var ticketEntry in ticketData.entries) {
              var keyTicket = ticketEntry.key;
              var valueTicket = ticketEntry.value;

              if (valueTicket['idtransition'] == keyRoute) {
                DatabaseReference detailTicketRef =
                    FirebaseDatabase.instance.ref().child('CTVE');
                DatabaseEvent detailTikcketEvent = await detailTicketRef.once();

                if (detailTikcketEvent.snapshot.value != null) {
                  Map<dynamic, dynamic> detailTicketData = detailTikcketEvent
                      .snapshot.value as Map<dynamic, dynamic>;

                  for (var detailTicketEntry in detailTicketData.entries) {
                    var keyDetailTicket = detailTicketEntry.key;
                    var valueDetailTicket = detailTicketEntry.value;

                    if (valueDetailTicket['idticket'] == keyTicket) {
                      print(valueDetailTicket['numberseat']);
                      SeatItem item = SeatItem(
                          index: valueDetailTicket['numberseat'].toString());
                      bookedSeat.add(item);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    //print(object)
    return bookedSeat;
  }

  static Future fetchPopularRoute() async {
    List<ListItemRoute> featuredRoutes = [];
    DatabaseReference featureRoutetRef =
        FirebaseDatabase.instance.ref().child('CHUYENXE');
    DatabaseEvent featureRoutetEvent = await featureRoutetRef.once();

    if (featureRoutetEvent.snapshot.value != null) {
      Map<dynamic, dynamic> featureData =
          featureRoutetEvent.snapshot.value as Map<dynamic, dynamic>;

      for (var featureEntry in featureData.entries) {
        var keyFeature = featureEntry.key;
        var valueFeature = featureEntry.value;

        if (valueFeature['featuredroute'] == '1') {
          ListItemRoute itemRoute = ListItemRoute.non_para();
          itemRoute.prices = valueFeature['priceticket'];

          final _cityPointController = Get.find<CitiesController>();
          await _cityPointController.setListCities();
          _cityPointController.cities.forEach((element) {
            if (element.idCity == valueFeature['startpoint']) {
              itemRoute.startCity = element;
              itemRoute.startPoint = element.nameCity;
            } else {
              if (element.idCity == valueFeature['endpoint']) {
                itemRoute.endCity = element;
                itemRoute.endPoint = element.nameCity;
                itemRoute.imageUrl = element.urlImage;
              }
            }
          });
          featuredRoutes.add(itemRoute);
        }
      }
    }
    print(featuredRoutes.length);
    return featuredRoutes;
  }
}
