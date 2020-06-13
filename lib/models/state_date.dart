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

class GraphDistrictData {
  final String district;
  final int cases;
  final int deaths;
  final int recovered;

  GraphDistrictData({
    @required this.district,
    @required this.cases,
    @required this.deaths,
    @required this.recovered,
  });

  factory GraphDistrictData.fromJson(Map<String, dynamic> json) {
    return GraphDistrictData(
      district: json['district'] as String,
      cases: json['cases'] as int,
      deaths: json['deaths'] as int,
      recovered: json['recovered'] as int,
    );
  }
}

class GraphStateData {
  final String state;
  final int cases;
  final int deaths;
  final int recovered;
  final int updated;
  List<GraphDistrictData> districts;

  GraphStateData(
      {@required this.state,
        @required this.cases,
        @required this.deaths,
        @required this.recovered,
        @required this.updated,
        @required this.districts});

  factory GraphStateData.fromJson(Map<String, dynamic> json) {
    if (json['districts'] == null) {
      // print(json['state']);
      return GraphStateData(
          state: json['state'] as String,
          cases: json['cases'] as int,
          deaths: json['deaths'] as int,
          recovered: json['recovered'] as int,
          updated: json['updated'] as int,
          districts: []);
    }
    return GraphStateData(
        state: json['state'] as String,
        cases: json['cases'] as int,
        deaths: json['deaths'] as int,
        recovered: json['recovered'] as int,
        updated: json['updated'] as int,
        districts: json['districts']
            .map<GraphDistrictData>(
                (dynamic item) => GraphDistrictData.fromJson(item))
            .toList() as List<GraphDistrictData>);
  }
}

class GraphCountryData {
  final String country;
  final int cases;
  final int deaths;
  final int recovered;
  final int updated;
  List<GraphStateData> states;

  GraphCountryData(
      {@required this.country,
        @required this.cases,
        @required this.deaths,
        @required this.recovered,
        @required this.updated,
        @required this.states});

  factory GraphCountryData.fromJson(Map<String, dynamic> json) {
    if (json['states'] == null) {
      return GraphCountryData(
          country: json['country'] as String,
          cases: json['cases'] as int,
          deaths: json['deaths'] as int,
          recovered: json['recovered'] as int,
          updated: json['updated'] as int,
          states: []);
    }
    return GraphCountryData(
        country: json['country'] as String,
        cases: json['cases'] as int,
        deaths: json['deaths'] as int,
        recovered: json['recovered'] as int,
        updated: json['updated'] as int,
        states: json['states']
            .map<GraphStateData>(
                (dynamic item) => GraphStateData.fromJson(item))
            .toList() as List<GraphStateData>);
  }
}