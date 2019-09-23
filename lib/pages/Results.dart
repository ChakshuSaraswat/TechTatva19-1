import 'package:flutter/material.dart';
import 'dart:math';
import '../main.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          child: Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBarDelegate.buildSliverAppBar(
                  "Results", "assets/rr.jpg")
            ];
          },
          body: Container(
            padding: EdgeInsets.only(top: 5.0),
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(100, (index) {
                return  _buildResultCard(context, index);
              }),
            ),
          ),
        ));
  }

  Widget _buildResultCard(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: Container(
          //   color: Colors.white10,
          child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 2.0,
                      height: 0.5,
                    ),
                    Container(
                     // color: Colors.red,
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.29),
                      height: 20.0,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "AdrenalineX",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.24,
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            Icons.assessment,
                            size: 16.0,
                            color: Colors.greenAccent,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.33),
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            child: Text(
                              "Round 2",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13.0, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.greenAccent,
                      height: 0.5,
                      width: 50.0,
                    )
                  ],
                ),
               Container(
                      color: (index % 3 != 2) ? Colors.greenAccent : Colors.transparent,
                      height: 50.0,
                      width: 0.5,
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
