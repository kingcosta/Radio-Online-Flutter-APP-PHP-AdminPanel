import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import 'Helper/Constant.dart';

class AboutUS extends StatefulWidget {
  @override
  _aboutState createState() => _aboutState();
}

class _aboutState extends State<AboutUS> {
  late String _privacy;
  String _loading = 'true';
  InterstitialAd? interstitialAd;
  bool adStatus = false;
  late final WebViewController _controller;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value){
      _createInterstitialAd();
      // #docregion platform_features
      late final PlatformWebViewControllerCreationParams params;
      params = const PlatformWebViewControllerCreationParams();
      _controller = WebViewController.fromPlatformCreationParams(params);
      _controller.loadHtmlString(_privacy);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadLocalHTML(),
      builder: (context, snapshot) {
        if (_loading.compareTo('true') == 0) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Privacy Policy',
              ),
              centerTitle: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'Privacy Policy',
                ),
                centerTitle: true,
              ),
              body: WebViewWidget(
                controller: _controller,
              ),
            ),
          );
        }
      },
    );
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: getInterstitialAdUnitId()!,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            setState(() {
              interstitialAd = ad;
              adStatus = true;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            print(error);
          },
        ));
  }

  Future<bool> _onWillPop() async {
    if (adStatus)
      interstitialAd!.show();
    else
      Navigator.pop(context, true);
    return false;
  }

  Future _loadLocalHTML() async {
    var data = {
      'access_key': '6808',
    };
    var response = await http.post(about_api, body: data);
    var getdata = json.decode(response.body);
    var error = getdata['error'].toString();
    if (error.compareTo('false') == 0) {
      setState(() {
        _privacy = getdata['data'].toString();
        print(">>>>>>>> $_privacy");
        _loading = 'false';
      });
    }
  }
}