import 'package:flutter/material.dart';

stateListBuilder(var snapshot) {
  return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.teal[100],
                  border: Border.all(color: Colors.redAccent, width: 2)),
              child: Column(
                children: <Widget>[
                  Text(snapshot.data[index].state,
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 20.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(snapshot.data[index].confirmed),
                      SizedBox(
                        width: 10,
                      ),
                      Text(snapshot.data[index].active),
                      SizedBox(
                        width: 10,
                      ),
                      Text(snapshot.data[index].deaths),
                      SizedBox(
                        width: 10,
                      ),
                      Text(snapshot.data[index].recovered),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        );
      });
}
