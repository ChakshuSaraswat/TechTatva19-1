import 'package:flutter/material.dart';
import 'package:techtatva19/DataModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../main.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

List<EventData> eventsWithResults;

class _ResultsState extends State<Results> with TickerProviderStateMixin {
  @override
  void initState() {
    _resultsForEvents();
    // TODO: implement initState
    super.initState();
  }

  _resultsForEvents() {
    eventsWithResults = [];
    for (var result in allResults) {
      for (var event in allEvents) {
        if (result.eventId == event.id) {
          eventsWithResults.add(event);
        }
      }
    }

    eventsWithResults = eventsWithResults.toSet().toList();
    return eventsWithResults;
  }

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
              SliverAppBarDelegate.buildSliverAppBar("Results", "assets/rr.jpg")
            ];
          },
          body: FutureBuilder(
            future: loadResults(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                  height: 300.0,
                  width: 300.0,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              else {
                return Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(eventsWithResults.length, (index) {
                      return _buildResultCard(context, index);
                    }),
                  ),
                );
              }
            },
          ),
        ));
  }

  String _findNameOfEvent(int eventId) {
    for (var event in allEvents) {
      if (event.id == eventId) return event.name;
    }
  }

  Widget _buildResultCard(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: Container(
          child: InkWell(
            onTap: () {
              _showResultsSheet(context, index);
            },
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
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.29),
                      child: Container(
                          height: 80.0,
                          alignment: Alignment.center,
                          child: Text(
                            eventsWithResults[index].name ?? "EEEEEEEE",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          )),
                    ),
                    Container(
                      color: Colors.greenAccent,
                      height: 0.5,
                      width: 50.0,
                    )
                  ],
                ),
                Container(
                  color: (index % 3 != 2)
                      ? Colors.greenAccent
                      : Colors.transparent,
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

  _showResultsSheet(context, index) {
    TabController _controller = TabController(length: 3, vsync: this);

    List<ResultData> roundOneResults = [];
    List<ResultData> roundTwoResults = [];
    List<ResultData> roundThreeResults = [];

    for (var result in allResults) {
      if (result.eventId == eventsWithResults[index].id && result.round == 1)
        roundOneResults.add(result);

      if (result.eventId == eventsWithResults[index].id && result.round == 2)
        roundTwoResults.add(result);

      if (result.eventId == eventsWithResults[index].id && result.round == 3)
        roundThreeResults.add(result);
    }

    roundOneResults.sort((a, b) {
      return a.position.compareTo(b.position);
    });

    roundTwoResults.sort((a, b) {
      return a.position.compareTo(b.position);
    });

    roundThreeResults.sort((a, b) {
      return a.position.compareTo(b.position);
    });

    showModalBottomSheet(
        backgroundColor: Colors.black,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Text(
                    eventsWithResults[index].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26.0),
                  ),
                ),
                TabBar(
                  controller: _controller,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(
                        Icons.assessment,
                        color: Colors.white,
                      ),
                      text: "Round 1",
                    ),
                    Tab(
                      icon: Icon(
                        Icons.assessment,
                        color: Colors.white,
                      ),
                      text: "Round 2",
                    ),
                    Tab(
                      icon: Icon(
                        Icons.assessment,
                        color: Colors.white,
                      ),
                      text: "Round 3",
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: ListView.builder(
                          itemCount: roundOneResults.length,
                          itemBuilder: (context, resultsIndex) {
                            return Container(
                              child: ListTile(
                                  leading: Container(
                                    width: 50.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.ribbon,
                                          size: 18,
                                          color: getColorFromPosition(
                                              roundOneResults[resultsIndex]
                                                  .position),
                                        ),
                                        Text(
                                          roundOneResults[resultsIndex]
                                              .position
                                              .toString(),
                                          style: TextStyle(fontSize: 22.0),
                                        )
                                      ],
                                    ),
                                  ),
                                  title: Text(
                                    "Team ID:",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white70),
                                  ),
                                  trailing: Text(
                                    roundOneResults[resultsIndex]
                                        .teamId
                                        .toString(),
                                    style: TextStyle(fontSize: 20.0),
                                  )),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: roundTwoResults.length == 0
                            ? Column(
                                children: <Widget>[
                                  Container(
                                    height: 270.0,
                                    width: 270.0,
                                    alignment: Alignment.topCenter,
                                    child: FlareActor(
                                      'assets/NoEvent.flr',
                                      animation: 'noEvents',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "No Results for this Round.",
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 18.0),
                                    ),
                                  )
                                ],
                              )
                            : ListView.builder(
                                itemCount: roundTwoResults.length,
                                itemBuilder: (context, resultsIndex) {
                                  return Container(
                                    child: ListTile(
                                        leading: Container(
                                          width: 50.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.ribbon,
                                                size: 18,
                                                color: getColorFromPosition(
                                                    roundTwoResults[
                                                            resultsIndex]
                                                        .position),
                                              ),
                                              Text(
                                                roundTwoResults[resultsIndex]
                                                    .position
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 22.0),
                                              )
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                          "Team ID:",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white70),
                                        ),
                                        trailing: Text(
                                          roundTwoResults[resultsIndex]
                                              .teamId
                                              .toString(),
                                          style: TextStyle(fontSize: 20.0),
                                        )),
                                  );
                                },
                              ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: roundThreeResults.length == 0
                            ? Column(
                                children: <Widget>[
                                  Container(
                                    height: 270.0,
                                    width: 270.0,
                                    alignment: Alignment.topCenter,
                                    child: FlareActor(
                                      'assets/NoEvent.flr',
                                      animation: 'noEvents',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "No Results for this Round.",
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 18.0),
                                    ),
                                  )
                                ],
                              )
                            : ListView.builder(
                                itemCount: roundThreeResults.length,
                                itemBuilder: (context, resultsIndex) {
                                  return Container(
                                    child: ListTile(
                                        leading: Container(
                                          width: 50.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.ribbon,
                                                size: 18,
                                                color: getColorFromPosition(
                                                    roundThreeResults[
                                                            resultsIndex]
                                                        .position),
                                              ),
                                              Text(
                                                roundThreeResults[resultsIndex]
                                                    .position
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 22.0),
                                              )
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                          "Team ID:",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white70),
                                        ),
                                        trailing: Text(
                                          roundThreeResults[resultsIndex]
                                              .teamId
                                              .toString(),
                                          style: TextStyle(fontSize: 20.0),
                                        )),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  getColorFromPosition(int pos) {
    if (pos == 1)
      return Colors.amberAccent;
    else if (pos == 2)
      return Color.fromRGBO(192, 192, 192, 1);
    else if (pos == 3)
      return Color.fromRGBO(205, 127, 50, 1);
    else
      return Colors.white;
  }
}
