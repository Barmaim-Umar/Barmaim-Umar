import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pfc/View/Login/LoginScreen.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class Logout extends StatefulWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Hive.close();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Logout"),
      body: Center(
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(ThemeColors.primary),
            minimumSize: const MaterialStatePropertyAll(Size(110, 45))
          ),
          onPressed: () {
            Hive.close();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
            );
          },
          child: const Text(
            "Logout",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500 , color: Colors.white),
          ),
        ),
      ),
    );
  }
}
