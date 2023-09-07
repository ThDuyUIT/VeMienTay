import 'package:booking_transition_flutter/core/component/drawer/appbar.dart';
import 'package:booking_transition_flutter/feature/models/city_point.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/choose_route.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/find_route.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/steps_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/component/drawer/app_drawer.dart';
import '../../../../core/utils/colors.dart';

class Search extends StatefulWidget {
  Search({super.key});

  @override
  State<StatefulWidget> createState() {
    return StateSearch();
  }
}

class StateSearch extends State<Search> {
  static CityPoint? startCity;
  static CityPoint? endCity;
  static String? departureDate;
  static int currentStep = 0;
  int typePoint = 0;
  static String title = 'Search your route';

  static choosedCity(CityPoint choosedCity, int typePoint) {
    if (typePoint == 1) {
      startCity = choosedCity;
    } else {
      endCity = choosedCity;
    }
  }

  @override
  Widget build(BuildContext context) {
    StateFindRoute.startCity = startCity;
    StateFindRoute.endCity = endCity;
    departureDate = StateFindRoute.departureDate;
    void _showDatePicker() {
      showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2025));
    }

    setState(() {
      if (currentStep == 0) {
        title = 'Search your route';
      } else {
        if (currentStep == 1) {
          title = 'Booking your ticket';
        }
      }
    });

    // if (currentStep == 0) {
    //   title = 'Search your route';
    // } else {
    //   title = 'Booking your ticket';
    // }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(),
        drawer: AppDrawer(),
        body: Container(
          //color: ,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, top: 30),
                child:
                    (startCity == null && endCity == null) || currentStep != 0
                        ? Text(
                            title,
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Roboto bold',
                                color: AppColor.mainColor),
                          ).animate().slideX(duration: 500.ms, begin: -5)
                        : Text(
                            title,
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Roboto bold',
                                color: AppColor.mainColor),
                          ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: const Text(
                  'Guarantee 150% refund if transport service is not provided',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                  child: Container(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                          color: AppColor.mainColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(40))),
                      child: ChooseRoute.routes.isEmpty
                          ? FindRoute()
                          : StepsBooking())),
            ],
          ),
        ),
        // )
      ),
    );
  }
}
