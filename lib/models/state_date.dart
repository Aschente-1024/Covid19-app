import 'package:flutter/material.dart';

class StateData {
  final String active;
  final String confirmed;
  final String deaths;
  final String deltaconfirmed;
  final String deltadeaths;
  final String deltarecovered;
  final String lastupdatedtime;
  final String recovered;
  final String state;
  final String statecode;
  final String statenotes;

  StateData(
      {@required this.active,
      @required this.confirmed,
      @required this.deaths,
      @required this.deltaconfirmed,
      @required this.deltadeaths,
      @required this.deltarecovered,
      @required this.lastupdatedtime,
      @required this.recovered,
      @required this.state,
      @required this.statecode,
      @required this.statenotes});

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
        active: json['active'] as String,
        confirmed: json['confirmed'] as String,
        deaths: json['deaths'] as String,
        deltaconfirmed: json['deltaconfirmed'] as String,
        deltadeaths: json['deltadeaths'] as String,
        deltarecovered: json['deltarecovered'] as String,
        lastupdatedtime: json['lastupdatedtime'] as String,
        recovered: json['recovered'] as String,
        state: json['state'] as String,
        statecode: json['statecode'] as String,
        statenotes: json['statenotes'] as String);
  }
}

class GraphStateData {
  final String state;
  final int cases;
  final int deaths;
  final int recovered;

  GraphStateData(
      {
        @required this.state,@required this.cases,
      @required this.deaths,
      @required this.recovered
      });

  factory GraphStateData.fromJson(Map<String, dynamic> json) {
    return GraphStateData(
      state: json['state'] as String,
      cases: json['cases'] as int,
      deaths: json['deaths'] as int,
      recovered: json['recovered'] as int,
    );
  }
}

class GraphCountryData {
  final String country;
  final int cases;
  final int deaths;
  final int recovered;

  GraphCountryData({
    @required this.country,
    @required this.cases,
    @required this.deaths,
    @required this.recovered,
  });

  factory GraphCountryData.fromJson(Map<String, dynamic> json) {
    return GraphCountryData(
      country: json['country'] as String,
      cases: json['cases'] as int,
      deaths: json['deaths'] as int,
      recovered: json['recovered'] as int,
    );
  }
}
