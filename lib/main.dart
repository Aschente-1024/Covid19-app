import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/models/location_info.dart';
import 'models/graphql_client.dart';
import 'package:geolocator/geolocator.dart';

// const String testDevice = '6D1A81BDBC70F2BCE9829F4EB321E17B';
const String testDevice = 'test device';

void main() => runApp(MyApp());
// void main() => runApp(MyGeolocator());

// class MyGeolocator extends StatefulWidget {
//   @override
//   _MyGeolocatorState createState() => _MyGeolocatorState();
// }

// class _MyGeolocatorState extends State<MyGeolocator> {

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: BuildLocationInfo()
//       ),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      testDevices: testDevice != null ? <String>[testDevice] : null,
      nonPersonalizedAds: true,
      keywords: [
        'Game',
        'health',
        'world health organization',
        'epidemiology',
        'digital healthcare',
        'private healthcare insurance',
        'medical insurance for parents',
        'healthy snacks',
        'nutrition',
        'disease',
        'healthy food'
      ]);
  BannerAd _bannerAd;
  BannerAd createBannerAd() {
    return BannerAd(
        // BannerAd.testAdUnitId
        // "ca-app-pub-9324487811367904/3821156590"
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          // print("BannerAd $event");
        });
  }

  @override
  void initState() {
    // "ca-app-pub-9324487811367904~9265943017"
    // FirebaseAdMob.testAppId
    FirebaseAdMob.instance
        .initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      theme: ThemeData(fontFamily: 'Poppins'),
      // home: RandomWords()
      home: TestGraphApi(),
    );
  }
}
