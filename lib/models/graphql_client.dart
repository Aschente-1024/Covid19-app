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

  final _queryCountryList = '''
        query queryCountryList{
          countries{
            country
            cases
            deaths
            recovered
          }
        }
      ''';

  String _queryStateList() {
    String country = selectedCountry.country;
    return '''
            query queryStateList{
              states(countryName:"$country"){
                state
                cases
                deaths
                recovered
              }
            }
          ''';
  }

  @override
  void initState() {
    super.initState();
    selectedCountry = GraphCountryData(
        country: "Select Choice", cases: 0, deaths: 0, recovered: 0);
    selectedState = GraphStateData(
        state: "Select Choice", cases: 0, deaths: 0, recovered: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Query(
            options: QueryOptions(documentNode: gql(_queryCountryList)),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.data == null) {
                return Center(child: CircularProgressIndicator());
              }

              List graphCountryData = [selectedCountry];
              graphCountryData += result.data['countries']
                  .map((dynamic item) => GraphCountryData.fromJson(item))
                  .toList();

              print(graphCountryData.length);

              return DropdownButton<GraphCountryData>(
                  value: selectedCountry,
                  items: graphCountryData
                      .map<DropdownMenuItem<GraphCountryData>>((var value) {
                    return DropdownMenuItem<GraphCountryData>(
                      child: Text(value.country),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (GraphCountryData newValue) {
                    setState(() {
                      selectedCountry = newValue;
                    });
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
        selectedCountry.country == 'Select Choice'
            ? Text("Select Country")
            : Query(
                options: QueryOptions(documentNode: gql(_queryStateList())),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                      // print(_queryStateList());
                  if (result.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List graphStateData = [selectedState];
                  graphStateData += result.data['states']
                      .map((dynamic item) => GraphStateData.fromJson(item))
                      .toList();

                  print(graphStateData.length);

                  return DropdownButton<GraphStateData>(
                      value: selectedState,
                      items: graphStateData
                          .map<DropdownMenuItem<GraphStateData>>((var value) {
                        return DropdownMenuItem<GraphStateData>(
                          child: Text(value.state),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (GraphStateData newValue) {
                        setState(() {
                          selectedState = newValue;
                        });
                      });
                }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(selectedState.state),
            Text(selectedState.cases.toString()),
            Text(selectedState.deaths.toString()),
            Text(selectedState.recovered.toString()),
          ],
        ),
      ],
    );
  }
}
