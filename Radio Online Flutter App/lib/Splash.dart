import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Helper/Constant.dart';
import 'main.dart';

///splash screen of app
class Splash extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<Splash> {
  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ));
  }

  @override
  void initState() {
    super.initState();
    try {
      FirebaseMessaging.instance.getToken().then((token) async {
        await _registerToken(token).then((value) {
          getcityMode();

          startTime();
        });
      });
    } catch (ignore) {}
  }

  Future<void> _registerToken(String? token) async {
    var data = {'access_key': '6808', 'token': token};

    await http.post(
      token_api,
      body: data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/back.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/image/logo.png',
                width: 250,
                height: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getcityMode() async {
    var data = {'access_key': '6808'};
    var response = await http.post(city_mode, body: data);

    var getdata = json.decode(response.body);

    var error = getdata['error'].toString();
    if (!mounted) return null;

    if (error == 'false') {
      var city = getdata['data'];

      if (city == "1") {
        cityMode = true;
      } else {
        cityMode = false;
      }
    } else {
      cityMode = false;
    }
  }
}
