import 'dart:io';

import 'package:booking_transition_flutter/feature/models/account_information.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/choose_seat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/ticket.dart';

class InsertDataService {
  static Future<bool> insertAccountInformation(
      AccountInformation newAcc, String uid) async {
    try {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('KHACHHANG');
      DatabaseReference uidRef = userRef.child('KH$uid');

      // Push the account information under the specified UID node.
      await uidRef.set({
        'avatar': newAcc.avatarUrl,
        'gender': newAcc.gender,
        'fullname': newAcc.fullName,
        'phonenums': newAcc.phoneNumbers,
        'username': newAcc.mail,
      });

      // Return true to indicate success.
      return true;
    } catch (error) {
      // Return false if there's an error during the write operation.
      print('Error inserting account information: $error');
      return false;
    }
  }

  static Future updateAccountAvatart(File? image, String id) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('Avatar');

      final uploadTask =
          await ref.child('img$id').putFile(image!).whenComplete(() {});

      final urlDownload = await uploadTask.ref.getDownloadURL();
      return urlDownload;
    } catch (e) {
      print('fail upload');
    }
  }

  static Future insertNewTicket(Ticket ticket) async {
    DatabaseReference ticketRef = FirebaseDatabase.instance.ref().child('VE');

    String idTicket = 'VE${DateTime.now().millisecondsSinceEpoch}';

    DatabaseReference idTicketRef = ticketRef.child(idTicket);

    try {
      await idTicketRef.set({
        'idaccount': 'KH${ticket.idAccount}',
        'idtransition': ticket.idTransition,
        'pricestotal': ticket.pricesTotal,
        'methodpayment': ticket.methodPayment,
        'statuspayment': ticket.statusPayment,
        'statusticket': ticket.statusTicket
      });
      return idTicket;
    } catch (e) {
      print('Booking fail');
    }
  }

  static Future inserDetailTicket(String idTicket) async {
    DatabaseReference detailRef = FirebaseDatabase.instance.ref().child('CTVE');
    late DatabaseReference idDetailRef;

    late String keyChild;
    StateChooseSeat.selectedSeats.forEach((element) async {
      keyChild = 'CT${DateTime.now().millisecondsSinceEpoch}';
      idDetailRef = detailRef.child(keyChild);

      try {
        await idDetailRef.set({'idticket': idTicket, 'numberseat': element});

        //return idDetailRef;
        print('Booking sucessful');
      } catch (e) {
        print('Booking fail');
        return;
      }
    });
  }
}
