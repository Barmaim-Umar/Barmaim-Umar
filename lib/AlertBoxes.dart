import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlertBoxes {

  static toastMessage(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
    );
  }

  static snackBar(BuildContext context, String message){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message),
          backgroundColor: Colors.cyanAccent,
        )
    );
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        maxWidth: 350,
        message: message,
        backgroundColor: const Color(0xffFF0000),
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.error,color: Colors.white,),
        borderRadius: BorderRadius.circular(5),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        // backgroundGradient: LinearGradient(colors: [
        //   Colors.pinkAccent,Colors.green,Colors.yellow,Colors.red,Colors.lightBlueAccent,
        // ]),
        borderColor: Colors.white,
        borderWidth: 2,
      )..show(context),
    );
  }

  static void flushBarSuccessMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        maxWidth: 350,
        message: message,
        backgroundColor: Colors.green,
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check,color: Colors.white,),
        borderRadius: BorderRadius.circular(5),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        // backgroundGradient: LinearGradient(colors: [
        //   Colors.pinkAccent,Colors.green,Colors.yellow,Colors.red,Colors.lightBlueAccent,
        // ]),
        borderColor: Colors.white,
        borderWidth: 2,
      )..show(context),
    );
  }

  static void flushBar(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        maxWidth: 700,
        message: message,
        backgroundColor: Colors.blueGrey,
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        duration: const Duration(seconds: 1),
        borderRadius: BorderRadius.circular(20),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        // backgroundGradient: LinearGradient(colors: [
        //   Colors.pinkAccent,Colors.green,Colors.yellow,Colors.red,Colors.lightBlueAccent,
        // ]),
        borderColor: Colors.white,
        borderWidth: 2,
      )..show(context),
    );
  }
}