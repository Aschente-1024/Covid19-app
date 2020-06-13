import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

const String apiKey =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtYWlsSWRlbnRpdHkiOiJyYWdodXZpcmJvaGFyYUBnbWFpbC5jb20ifQ.KzZ5XRgw-MGgfBHAWDgp2xa5PJYxCg-C_ZKFGVp0GTg";

class NearByZones {
  final List containmentZoneNames;
  final bool containmentsAvailability;
  final int numberOfNearbyZones;
  final int status;

  NearByZones({
    @required this.containmentZoneNames,
    @required this.containmentsAvailability,
    @required this.numberOfNearbyZones,
    @required this.status,
  });

  factory NearByZones.fromJson(Map<String, dynamic> json) {
    return NearByZones(
        containmentZoneNames: json['containmentZoneNames'] as List,
        containmentsAvailability: json['containmentsAvailability'] as bool,
        numberOfNearbyZones: json['numberOfNearbyZones'] as int,
        status: json['status'] as int);
  }
}

class PinCodeCheck {
  final int status;
  final PinCodeCheckData data;

  PinCodeCheck({@required this.status, @required this.data});

  factory PinCodeCheck.fromJson(Map<String, dynamic> json) {
    return PinCodeCheck(
        status: json['status'] as int,
        data: PinCodeCheckData.fromJson(json['data']));
  }
}

class PinCodeCheckData {
  final String district;
  final String districtZoneType;
  final bool containmentsAvailability;
  final int numContainmentZones;
  final bool hasContainmentZone;

  PinCodeCheckData({
    @required this.district,
    @required this.districtZoneType,
    @required this.containmentsAvailability,
    @required this.numContainmentZones,
    @required this.hasContainmentZone,
  });

  factory PinCodeCheckData.fromJson(Map<String, dynamic> json) {
    return PinCodeCheckData(
      district: json['district'] as String,
      districtZoneType: json['districtZoneType'] as String,
      containmentsAvailability: json['containmentsAvailability'] as bool,
      numContainmentZones: json['numContainmentZones'] as int,
      hasContainmentZone: json['hasContainmentZone'] as bool,
    );
  }
}

Future getNearbyZones(radius) async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print(position);

  final String url = 'https://data.geoiq.io/dataapis/v1.0/covid/nearbyzones';
  var body = {
    'key': apiKey,
    'lng': position.longitude,
    'lat': position.latitude,
    'radius': 3000
  };
  var response = await post(url, body: json.encode(body));
  print(response.body);
  NearByZones nearByZones = NearByZones.fromJson(json.decode(response.body));
  // print(nearByZones.containmentZoneNames);

  return nearByZones;
}

Future checkPinCode(String pincode) async {
  final String url = 'https://data.geoiq.io/dataapis/v1.0/covid/pincodecheck';
  var body = {'key': apiKey, 'pincode': pincode ?? '411057'};

  var response = await post(url, body: json.encode(body));
  PinCodeCheck pinCodeCheck = PinCodeCheck.fromJson(json.decode(response.body));
  print(pinCodeCheck.data.district);

  return pinCodeCheck;
}

class BuildLocationInfo extends StatefulWidget {
  @override
  _BuildLocationInfoState createState() => _BuildLocationInfoState();
}

class _BuildLocationInfoState extends State<BuildLocationInfo> {
  var nearbyZones;
  bool serviceStatus;
  @override
  void initState() {
    super.initState();
    this.nearbyZones = getNearbyZones(3000);
    this.serviceStatus = false;
  }

  checkLocationServiceStatus() async {
    var _serviceStatus = await Geolocator().isLocationServiceEnabled();
    setState(() {
      serviceStatus = _serviceStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    checkLocationServiceStatus();
    return FutureBuilder(
        future: nearbyZones,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  !serviceStatus
                      ? Text("Enable Location Service")
                      : Text("Waiting To Fetch Information"),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
          return SafeArea(
            child: ListView.builder(
              itemCount: snapshot.data.numberOfNearbyZones,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: Text(snapshot.data.containmentZoneNames[index]));
              },
            ),
          );
        },
      );
  }
}
