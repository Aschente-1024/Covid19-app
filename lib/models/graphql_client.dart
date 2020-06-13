import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hello_flutter/info_screen.dart';
import 'package:hello_flutter/models/location_info.dart';
import 'package:hello_flutter/widgets/counter.dart';
import 'package:hello_flutter/constant.dart';
import 'package:intl/intl.dart';
import 'state_date.dart';

class TestGraphApi extends StatefulWidget {
  @override
  _TestGraphApiState createState() => _TestGraphApiState();
}

class _TestGraphApiState extends State<TestGraphApi> {
  final controller = ScrollController();
  double offset = 0;
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(uri: "https://covidstat.info/graphql");
    final ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
        link: httpLink,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject)));

    return GraphQLProvider(client: client, child: GraphQLChild());
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }
}

class GraphQLChild extends StatefulWidget {
  @override
  _GraphQLChildState createState() => _GraphQLChildState();
}

class _GraphQLChildState extends State<GraphQLChild> {
  double offset = 0;
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
            updated
            states{
              state
            }
          }
          countries {
            country
            cases
            deaths
            recovered
            updated
            states {
              state
              cases
              deaths
              recovered
              updated
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
        updated: 0,
        states: []);
    selectedState = GraphStateData(
      state: "Select Choice",
      cases: 0,
      deaths: 0,
      recovered: 0,
      updated: 0,
      districts: [],
    );
    selectedDistrict =
        GraphDistrictData(district: "Null", cases: 0, deaths: 0, recovered: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Mdrcorona.svg",
              image2: "assets/images/steth.png",
              textTop: "Stay Home",
              textBottom: "Stay Safe.",
              textHash: "#JeetJayegaIndia",
              offset: offset,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Query(
                      options:
                          QueryOptions(documentNode: gql(_queryMasterList)),
                      builder: (QueryResult result,
                          {VoidCallback refetch, FetchMore fetchMore}) {
                        if (result.data == null) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[CircularProgressIndicator()],
                          );
                        }

                        GraphCountryData world = [result.data['all']]
                            .map<GraphCountryData>((dynamic item) =>
                                GraphCountryData.fromJson(item))
                            .toList()[0];

                        List<GraphCountryData> graphCountryData = [
                          selectedCountry
                        ];
                        graphCountryData += result.data['countries']
                            .map<GraphCountryData>((dynamic item) =>
                                GraphCountryData.fromJson(item))
                            .toList();
                        if (selectedCountry.country == "Select Choice") {
                          selectedCountry = graphCountryData.firstWhere(
                              (element) => element.country == 'India');
                          selectedState = selectedCountry.states[0];
                        }

                        return Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Case Update",
                                    style: kTitleTextstyle,

                                    /*text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Case Update\n",
                                      style: kTitleTextstyle,
                                    ),
                                    TextSpan(
                                      //new DateFormat.yMMMd().format(new DateTime.now())
                                      text:"Newest Update on " + DateFormat.yMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(world.updated)).toString() , //DateTime.now().toString(),//,
                                      style: TextStyle(
                                        color: kTextLightColor,
                                      ),

                                    ),
                                  ],
                                ),*/
                                  ),
                                  Spacer(),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Latest Update on\n",
                                          style: TextStyle(
                                            color: kTextLightColor,
                                          ),
                                        ),
                                        TextSpan(
                                          //new DateFormat.yMMMd().format(new DateTime.now())
                                          text: DateFormat.yMMMd()
                                              .add_jm()
                                              .format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      world.updated))
                                              .toString(), //DateTime.now().toString(),//,
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  /* Text(
                                "Refresh",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),*/
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 4),
                                      blurRadius: 30,
                                      color: kShadowColor,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      world.country,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Counter(
                                          color: kInfectedColor,
                                          number: world.cases.toString(),
                                          title: "Infected",
                                        ),
                                        Counter(
                                          color: kDeathColor,
                                          number: world.deaths.toString(),
                                          title: "Deceased",
                                        ),
                                        Counter(
                                          color: kRecovercolor,
                                          number: world.recovered.toString(),
                                          title: "Recovered",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Color(0xFFE5E5E5),
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                        "assets/icons/maps-and-flags.svg"),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: DropdownButton<GraphCountryData>(
                                          isExpanded: true,
                                          underline: SizedBox(),
                                          icon: SvgPicture.asset(
                                              "assets/icons/dropdown.svg"),
                                          value: selectedCountry,
                                          items: graphCountryData.map<
                                                  DropdownMenuItem<
                                                      GraphCountryData>>(
                                              (var value) {
                                            return DropdownMenuItem<
                                                GraphCountryData>(
                                              child: Text(value.country),
                                              value: value,
                                            );
                                          }).toList(),
                                          onChanged:
                                              (GraphCountryData newValue) {
                                            setState(() {
                                              selectedCountry = newValue;
                                              if (selectedCountry
                                                      .states.length !=
                                                  0)
                                                selectedState =
                                                    selectedCountry.states[0];
                                              else
                                                selectedState = GraphStateData(
                                                  state: "Select Choice",
                                                  cases: 0,
                                                  deaths: 0,
                                                  recovered: 0,
                                                  updated: 0,
                                                  districts: [],
                                                );
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 4),
                                      blurRadius: 30,
                                      color: kShadowColor,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      selectedCountry.country,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Counter(
                                          color: kInfectedColor,
                                          number:
                                              selectedCountry.cases.toString(),
                                          title: "Infected",
                                        ),
                                        Counter(
                                          color: kDeathColor,
                                          number:
                                              selectedCountry.deaths.toString(),
                                          title: "Deceased",
                                        ),
                                        Counter(
                                          color: kRecovercolor,
                                          number: selectedCountry.recovered
                                              .toString(),
                                          title: "Recovered",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              selectedCountry.states.length > 0
                                  ? Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 0),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              border: Border.all(
                                                color: Color(0xFFE5E5E5),
                                              ),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                    "assets/icons/maps-and-flags.svg"),
                                                SizedBox(width: 20),
                                                Expanded(
                                                  child: DropdownButton<
                                                          GraphStateData>(
                                                      isExpanded: true,
                                                      underline: SizedBox(),
                                                      icon: SvgPicture.asset(
                                                          "assets/icons/dropdown.svg"),
                                                      value: selectedState,
                                                      items: selectedCountry
                                                          .states
                                                          .map<
                                                                  DropdownMenuItem<
                                                                      GraphStateData>>(
                                                              (var value) {
                                                        return DropdownMenuItem<
                                                            GraphStateData>(
                                                          child:
                                                              Text(value.state),
                                                          value: value,
                                                        );
                                                      }).toList(),
                                                      onChanged: (GraphStateData
                                                          newValue) {
                                                        setState(() {
                                                          selectedState =
                                                              newValue;
                                                          selectedDistrict =
                                                              selectedState
                                                                  .districts[0];
                                                        });
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0, 4),
                                                  blurRadius: 30,
                                                  color: kShadowColor,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  selectedState.state,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Counter(
                                                      color: kInfectedColor,
                                                      number: selectedState
                                                          .cases
                                                          .toString(),
                                                      title: "Infected",
                                                    ),
                                                    Counter(
                                                      color: kDeathColor,
                                                      number: selectedState
                                                          .deaths
                                                          .toString(),
                                                      title: "Deceased",
                                                    ),
                                                    Counter(
                                                      color: kRecovercolor,
                                                      number: selectedState
                                                          .recovered
                                                          .toString(),
                                                      title: "Recovered",
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          selectedState.state == "Total"
                                              ? SizedBox(height: 60)
                                              : SizedBox(height: 20),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              selectedState.districts.length > 0
                                  ? Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 0),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              border: Border.all(
                                                color: Color(0xFFE5E5E5),
                                              ),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                    "assets/icons/maps-and-flags.svg"),
                                                SizedBox(width: 20),
                                                Expanded(
                                                  child: DropdownButton<
                                                          GraphDistrictData>(
                                                      isExpanded: true,
                                                      underline: SizedBox(),
                                                      icon: SvgPicture.asset(
                                                          "assets/icons/dropdown.svg"),
                                                      value: selectedDistrict,
                                                      items: selectedState
                                                          .districts
                                                          .map<
                                                                  DropdownMenuItem<
                                                                      GraphDistrictData>>(
                                                              (var value) {
                                                        return DropdownMenuItem<
                                                            GraphDistrictData>(
                                                          child: Text(
                                                              value.district),
                                                          value: value,
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (GraphDistrictData
                                                              newValue) {
                                                        setState(() {
                                                          selectedDistrict =
                                                              newValue;
                                                        });
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0, 4),
                                                  blurRadius: 30,
                                                  color: kShadowColor,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  selectedDistrict.district,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Counter(
                                                      color: kInfectedColor,
                                                      number: selectedDistrict
                                                          .cases
                                                          .toString(),
                                                      title: "Infected",
                                                    ),
                                                    Counter(
                                                      color: kDeathColor,
                                                      number: selectedDistrict
                                                          .deaths
                                                          .toString(),
                                                      title: "Deceased",
                                                    ),
                                                    Counter(
                                                      color: kRecovercolor,
                                                      number: selectedDistrict
                                                          .recovered
                                                          .toString(),
                                                      title: "Recovered",
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 60),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHeader extends StatefulWidget {
  final String image;
  final String image2;
  final String textTop;
  final String textBottom;
  final String textHash;
  final double offset;
  const MyHeader(
      {Key key,
      this.image,
      this.image2,
      this.textTop,
      this.textBottom,
      this.textHash,
      this.offset})
      : super(key: key);

  @override
  _MyHeaderState createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(left: 40, top: 50, right: 20),
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFFF7800),
              Color(0xFFFF7800),
              Color(0xFFffffff),
              Color(0xFF4FC100),
              Color(0xFF4FC100),
            ],
          ),
          /*image: DecorationImage(
            image: AssetImage("assets/images/virus.png"),
          ),*/
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            /*GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return InfoScreen();
                    },
                  ),
                );
              },
              child: Image.asset(widget.image2,height: 40,),
            ),*/

            Material(
              elevation: 10.0,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: Ink.image(
                image: AssetImage('assets/images/steth.png'),
                fit: BoxFit.cover,
                width: 40,
                height: 40,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return InfoScreen();
                          // return buildLocationInfo();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 0),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: (widget.offset < 0) ? 0 : widget.offset,
                    left: -40,
                    child: SvgPicture.asset(
                      widget.image,
                      width: 230,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Positioned(
                    top: 20 - widget.offset / 2,
                    left: 150,
                    child: Text(
                      "${widget.textTop} \n${widget.textBottom}",
                      style: kHeadingTextStyle.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100 - widget.offset / 2,
                    left: 150,
                    child: Text(
                      "${widget.textHash}",
                      style: kHashTextStyle.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(), // I dont know why it can't work without container
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
