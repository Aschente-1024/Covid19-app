import 'dart:convert';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hello_flutter/widgets/state_list.dart';
import 'models/graphql_client.dart';
import 'models/state_date.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      darkTheme: ThemeData.dark(),
      // home: RandomWords()
      home: Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        // body: Test(),
        body: TestGraphApi(),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup name Generator"),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        // The itemBuilder callback is called once per suggested
        // word pairing, and places each suggestion into a ListTile
        // row. For even rows, the function adds a ListTile row for
        // the word pairing. For odd rows, the function adds a
        // Divider widget to visually separate the entries. Note that
        // the divider may be difficult to see on smaller devices.
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider widget before each row
          // in the ListView.
          if (i.isOdd) {
            return Divider();
          }

          // The syntax "i ~/ 2" divides i by 2 and returns an
          // integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings
          // in the ListView,minus the divider widgets.
          final int index = i ~/ 2;
          // If you've reached the end of the available word
          // pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the
            // suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  var result;

  @override
  void initState() {
    super.initState();
    result = _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: result,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return stateListBuilder(snapshot);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<StateData>> _getData() async {
    // var url = 'https://jsonplaceholder.typicode.com/posts';
    var url = "https://api.covid19india.org/data.json";
    var response = await get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['statewise'];
      List<StateData> stateWiseData =
          body.map((dynamic item) => StateData.fromJson(item)).toList();
      // print(stateData);
      for (var i in stateWiseData) {
        print(i.state);
      }
      return stateWiseData;
    }

    // print(json.decode(response.body)['statewise']);

    // return json.decode(response.body)['statewise'];
    return null;
  }
}
