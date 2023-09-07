import 'package:booking_transition_flutter/core/utils/colors.dart';
import 'package:booking_transition_flutter/feature/controller/choose_route_controller.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/list_16_seats.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/search.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Tickets/list_item_ticket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/get_data_service.dart';
import '../Tickets/list_item_ticket_widget.dart';
import 'find_route.dart';
import 'list_29_seat.dart';

class ChooseRoute extends StatelessWidget {
  static List<ListItemTicket> routes = [];
  late TabController tabController;
  ChooseRoute({super.key, required this.tabController});

  // ChooseRoute.not_exist({super.key});

  void CleanSearchRoute() {
    StateSearch.currentStep = 0;
    StateSearch.startCity = null;
    StateSearch.endCity = null;
    StateFindRoute.departureDate = null;
  }

  @override
  Widget build(BuildContext context) {
    StateSearch.currentStep = 1;
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.place_rounded,
                        color: Colors.red,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'From: ${StateFindRoute.startCity?.nameCity}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_rounded,
                        color: Colors.red,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('To: ${StateFindRoute.endCity?.nameCity}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16))
                    ],
                  )
                ],
              )),
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                width: 2,
                height: 80,
                color: Colors.white,
              ),
              Expanded(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.date_range_rounded,
                        color: Colors.yellowAccent,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('Date: ${StateFindRoute.departureDate}',
                          style: TextStyle(fontSize: 16, color: Colors.white))
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        routes = [];
                        CleanSearchRoute();
                        Get.offAll(Search());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.white),
                      child: const Text(
                        'Search agains',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto bold',
                        ),
                      ))
                ],
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: routes.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  ListItemTicket item = routes[index];

                  return GestureDetector(
                      onTap: () async {
                        final _chooseRouteController =
                            Get.find<ChooseRouteController>();
                        _chooseRouteController.selectedRoute(item);
                        if (_chooseRouteController.item.capacity == 16) {
                          StateList16Seats.bookedSeat =
                              await GetDataService.fetchBookedSeat();
                        } else {
                          StateList29Seats.bookedSeat =
                              await GetDataService.fetchBookedSeat();
                        }

                        tabController.animateTo(1);
                      },
                      child: ListItemTicketWidget(item: item));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
