import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hello_flutter/models/state_date.dart';

class TestGraphApi extends StatefulWidget {
  @override
  _TestGraphApiState createState() => _TestGraphApiState();
}

class _TestGraphApiState extends State<TestGraphApi> {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(uri: "https://covidstat.info/graphql");
    final ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
        link: httpLink,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject)));

    return GraphQLProvider(client: client, child: GraphQLChild());
  }
}

class GraphQLChild extends StatefulWidget {
  @override
  _GraphQLChildState createState() => _GraphQLChildState();
}

class _GraphQLChildState extends State<GraphQLChild> {
  static GraphCountryData selectedCountry;
  static GraphStateData selectedState;
  static GraphDistrictData selectedDistrict;

  final _queryMasterList = '''
        query queryMasterList{
          all{
            country
            cases
            deaths
            recovered
            states{
              state
            }
          }
          countries {
            country
            cases
            deaths
            recovered
            states {
              state
              cases
              deaths
              recovered
              districts {
                district
                cases
                deaths
                recovered
              }
            }
          }
        }

      ''';

  @override
  void initState() {
    super.initState();
    selectedCountry = GraphCountryData(
        country: "Select Choice",
        cases: 0,
        deaths: 0,
        recovered: 0,
        states: []);
    selectedState = GraphStateData(
      state: "Select Choice",
      cases: 0,
      deaths: 0,
      recovered: 0,
      districts: [],
    );
    selectedDistrict =
        GraphDistrictData(district: "Null", cases: 0, deaths: 0, recovered: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Query(
            options: QueryOptions(documentNode: gql(_queryMasterList)),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.data == null) {
                return Center(child: CircularProgressIndicator());
              }

              GraphCountryData world = [result.data['all']]
                  .map<GraphCountryData>(
                      (dynamic item) => GraphCountryData.fromJson(item))
                  .toList()[0];

              List<GraphCountryData> graphCountryData = [selectedCountry ,world];
              graphCountryData += result.data['countries']
                  .map<GraphCountryData>(
                      (dynamic item) => GraphCountryData.fromJson(item))
                  .toList();

              return Container(
                child: Column(
                  children: <Widget>[
                    DropdownButton<GraphCountryData>(
                        value: selectedCountry,
                        items: graphCountryData
                            .map<DropdownMenuItem<GraphCountryData>>(
                                (var value) {
                          return DropdownMenuItem<GraphCountryData>(
                            child: Text(value.country),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (GraphCountryData newValue) {
                          setState(() {
                            selectedCountry = newValue;
                            if (selectedCountry.states.length != 0)
                              selectedState = selectedCountry.states[0];
                            else
                              selectedState = GraphStateData(
                                state: "Select Choice",
                                cases: 0,
                                deaths: 0,
                                recovered: 0,
                                districts: [],
                              );
                          });
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(selectedCountry.country),
                        Text(selectedCountry.cases.toString()),
                        Text(selectedCountry.deaths.toString()),
                        Text(selectedCountry.recovered.toString()),
                      ],
                    ),
                    selectedCountry.states.length > 0
                        ? Container(
                            child: Column(
                              children: <Widget>[
                                DropdownButton<GraphStateData>(
                                    value: selectedState,
                                    items: selectedCountry.states
                                        .map<DropdownMenuItem<GraphStateData>>(
                                            (var value) {
                                      return DropdownMenuItem<GraphStateData>(
                                        child: Text(value.state),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (GraphStateData newValue) {
                                      setState(() {
                                        selectedState = newValue;
                                        selectedDistrict =
                                            selectedState.districts[0];
                                      });
                                    }),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(selectedState.state),
                                    Text(selectedState.cases.toString()),
                                    Text(selectedState.deaths.toString()),
                                    Text(selectedState.recovered.toString()),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    selectedState.districts.length > 0
                        ? Container(
                            child: Column(
                              children: <Widget>[
                                DropdownButton<GraphDistrictData>(
                                    value: selectedDistrict,
                                    items: selectedState.districts.map<
                                        DropdownMenuItem<
                                            GraphDistrictData>>((var value) {
                                      return DropdownMenuItem<
                                          GraphDistrictData>(
                                        child: Text(value.district),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (GraphDistrictData newValue) {
                                      setState(() {
                                        selectedDistrict = newValue;
                                      });
                                    }),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(selectedDistrict.district),
                                    Text(selectedDistrict.cases.toString()),
                                    Text(selectedDistrict.deaths.toString()),
                                    Text(selectedDistrict.recovered.toString()),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
