import 'package:booking_transition_flutter/feature/controller/account_controller.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Account/myaccount.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Authentication/login.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/choose_seat.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/search.dart';
import 'package:booking_transition_flutter/feature/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../feature/presentation/page/Tickets/myticket.dart';

class ListDrawer extends StatelessWidget {
  @override
  Widget build(Object context) {
    final accountControler = Get.find<AccountController>();
    return Column(
      children: [
        ItemDrawer(
            text: 'Search',
            icon: Icons.search,
            onTap: () {
              navigate(0);
              StateChooseSeat.selectedSeats.clear();
            }),
        ItemDrawer(
          text: 'My Ticket',
          icon: Icons.receipt,
          onTap: () => navigate(1),
        ),
        ItemDrawer(
          text: 'My Account',
          icon: Icons.account_circle,
          onTap: () {
            if (accountControler.accountInformation != null) {
              navigate(2);
            } else {
              Get.to(Login());
            }
          },
        ),
        //ItemDrawer(text: 'My Accout', icon: Icons.account_circle)
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget ItemDrawer({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25,
      ),
      title: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: onTap,
    );
  }

  navigate(int index) {
    if (index == 0) {
      Get.off(Search());
    } else if (index == 1) {
      Get.off(MyTicket());
    }
    if (index == 2) {
      Get.off(MyAccount());
    }
  }
}
