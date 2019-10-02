import 'package:flutter/material.dart';
import 'package:techtatva19/main.dart';

class DelegateCard extends StatefulWidget {
  @override
  _DelegateCardState createState() => _DelegateCardState();
}

class _DelegateCardState extends State<DelegateCard> {
  @override
  Widget build(BuildContext context) {
    print(allCards.length);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Delegate Cards"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: allCards.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white10,
            ),
            margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      allCards[index].name,
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8.0),
                    height: 0.5,
                    width: 200.0,
                    color: Colors.greenAccent,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      allCards[index].desc,
                      style: TextStyle(fontSize: 16.0, color: Colors.white70),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    // color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Mahe Price: ${allCards[index].mahePrice}",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          "Non-Mahe Price: ${allCards[index].nonMahePrice}",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
