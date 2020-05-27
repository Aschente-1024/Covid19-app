import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectdIndex = 0;
  final List<String> categories = ['Message', 'Online', 'Groups', 'Requests'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectdIndex = index;
              });
            },
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Text(
                  categories[index],
                  style: TextStyle(
                      color:
                          index == selectdIndex ? Colors.white : Colors.white60,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0),
                )),
          );
        },
      ),
    );
  }
}
