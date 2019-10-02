import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:techtatva19/main.dart";
import "../main.dart";
import 'dart:async';
import 'package:techtatva19/pages/Login.dart';
import 'package:techtatva19/models/ScheduleModel.dart';
import 'package:techtatva19/models/CategoryModel.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> with TickerProviderStateMixin {
  bool isFABTapped = false;

  SharedPreferences _preferences;
  _buildFAB() {
    return FloatingActionButton(
      backgroundColor: Colors.greenAccent,
      child: Icon(
        Icons.search,
        color: Colors.black,
      ),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: _buildFAB(),
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBarDelegate.buildSliverAppBar(
                    "Schedule", "assets/Schedule.jpg"),
                SliverPersistentHeader(
                  delegate: SliverAppBarDelegate(
                    TabBar(
                      tabs: [
                        _buildTab("Day 1", "09-10-2019"),
                        _buildTab("Day 2", "10-10-2019"),
                        _buildTab("Day 3", "11-10-2019"),
                        _buildTab("Day 4", "12-10-2019"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: Container(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                children: <Widget>[
                  _buildCard(scheduleForDay(allSchedule, 'Wednesday'), context),
                  _buildCard(scheduleForDay(allSchedule, 'Thursday'), context),
                  _buildCard(scheduleForDay(allSchedule, 'Friday'), context),
                  _buildCard(scheduleForDay(allSchedule, 'Saturday'), context),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildTab(String day, String date) => Tab(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                day,
                style: TextStyle(fontSize: 18.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    size: 9.0,
                    color: Colors.white54,
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 9.0,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _registerForEvent(int eventId, context) async {
    print("tapped");
    print(eventId);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    var cookieJar = PersistCookieJar(
        dir: tempPath, ignoreExpires: true, persistSession: true);

    dio.interceptors.add(CookieManager(cookieJar));
    print("efefefef");
    var response = await dio.post("/createteam", data: {"eventid": eventId});

    print(response.statusCode);
    print(response.data);

    if (response.statusCode == 200 && response.data['success'] == true) {
      print("object");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Success!"),
            content: Text(
                "You have successfully registered for ${getEventNameFromID(eventId)}. Your team ID is ${response.data['data']}"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 200 &&
        response.data['msg'] == "User already registered for event") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Oops!"),
            content: Text(
                "It seems like you have already registered for ${getEventNameFromID(eventId)}. Check your registered events in the User Section."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 200 &&
        response.data['msg'] == "Card for event not bought") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Oops!"),
            content: Text(
                "It seems like you have not bought the Delegate Card required for ${getEventNameFromID(eventId)}."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Oops!"),
            content: Text(
                "Whoopsie there seems to be some error. Please check your connecting and try"),
            actions: <Widget>[
              new FlatButton(
                child: new Text(""),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  getEventNameFromID(int id) {
    print(allEvents.length);

    for (var event in allEvents) {
      if (id == event.id) return event.name;
    }
  }

  getCanRegister(int id) {

    print(allEvents.length);

    for (var event in allEvents) {
      print(event.canRegister);
      if (event.id == id) {
        return event.canRegister;
      }
    }
  }

  _showBottomModalSheet(BuildContext context, ScheduleData schedule) {
    TabController _controller = TabController(length: 2, vsync: this);

    CategoryData scheduleCategory;

    for (var i in allCategories) {
      if (schedule.categoryId == i.id)
        scheduleCategory = CategoryData(
          id: i.id,
          eventIds: i.eventIds,
          name: i.name,
          description: i.description,
          type: i.type,
          cc1Name: i.cc1Name,
          cc2Name: i.cc2Name,
          cc1Contact: i.cc1Contact,
          cc2Contact: i.cc2Contact,
        );
    }

    print(schedule.name);
    print(getCanRegister(schedule.eventId));

    showModalBottomSheet(
        backgroundColor: Colors.black,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: fromHome
                  ? MediaQuery.of(context).size.height * 0.73
                  : MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20.0),
                    alignment: Alignment.center,
                    child: Text(
                      schedule.name,
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: getCanRegister(schedule.eventId) == 1
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.1, 0.3, 0.7, 0.9],
                                  colors: [
                                    Colors.greenAccent.withOpacity(0.9),
                                    Colors.greenAccent.withOpacity(0.7),
                                    Colors.teal.withOpacity(0.8),
                                    Colors.teal.withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4.0)),
                            height: MediaQuery.of(context).size.height * 0.055,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: MaterialButton(
                              onPressed: () {
                                !isLoggedIn
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: new Text("Oops!"),
                                            content: Text(
                                                "It seems like you are not logged in, please login first in our user section."),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text("Close"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : _registerForEvent(
                                        schedule.eventId, context);
                              },
                              splashColor: Colors.greenAccent,
                              child: Container(
                                width: 300.0,
                                alignment: Alignment.center,
                                child: Text(
                                  "Register Now",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Registerations for this event are closed.",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                  ),
                  TabBar(
                    controller: _controller,
                    tabs: <Widget>[
                      Tab(
                        text: "Event",
                      ),
                      Tab(
                        text: "Description",
                      )
                    ],
                  ),
                  Container(
                    height: fromHome
                        ? MediaQuery.of(context).size.height * 0.48
                        : MediaQuery.of(context).size.height * 0.5,
                    //color: Colors.black,
                    child: TabBarView(
                      controller: _controller,
                      children: <Widget>[
                        ListView(
                          children: <Widget>[
                            _buildEventListTileInfo(Icon(Icons.assessment),
                                "Round:", schedule.round.toString()),
                            _buildEventListTileInfo(Icon(Icons.category),
                                "Category:", scheduleCategory.name),
                            _buildEventListTileInfo(
                                Icon(Icons.calendar_today),
                                "Date:",
                                '${schedule.startTime.day.toString()}-${schedule.startTime.month.toString()}-${schedule.startTime.year.toString()}'),
                            _buildEventListTileInfo(
                                Icon(Icons.timer), "Time:", getTime(schedule)),
                            _buildEventListTileInfo(Icon(Icons.location_on),
                                "Venue:", schedule.location),
                            _buildEventListTileInfo(
                                Icon(Icons.credit_card),
                                "Delegate Card",
                                getDelCardNameFromEventID(schedule.eventId) ??
                                    "unavailable"),
                            _buildEventListTileInfo(Icon(Icons.people),
                                "Team Size:", getTeamSize(schedule)),
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                              height: 0.5,
                              width: 100.0,
                              color: Colors.greenAccent,
                            ),
                            _buildEventListTileInfo(
                                Icon(Icons.phone), "Contact:", ""),
                            _buildEventListTileInfo(
                                null,
                                "${scheduleCategory.cc1Name}",
                                "+91${scheduleCategory.cc1Contact}"),
                            _buildEventListTileInfo(
                                null,
                                "${scheduleCategory.cc2Name}",
                                "+91${scheduleCategory.cc2Contact}")
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            leading: Icon(Icons.subject),
                            title: Text(
                              getEventDescription(schedule),
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  getEventDescription(ScheduleData scheduleData) {
    for (var i in allEvents) {
      if (i.id == scheduleData.eventId) {
        return i.description;
      }
    }
  }

  getTeamSize(ScheduleData scheduleData) {
    for (var i in allEvents) {
      if (i.id == scheduleData.eventId) {
        print("MATCHED");
        return (i.maxTeamSize == i.minTeamSize)
            ? i.maxTeamSize.toString()
            : '${i.minTeamSize} - ${i.maxTeamSize}';
      }
    }
  }

  Widget _buildEventListTileInfo(Icon icon, String title, String value) {
    return Material(
      color: Colors.black,
      child: ListTile(
        onTap: () {},
        leading: icon,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                ),
              ),
              Container(
                width: 180.0,
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getVisibleFrom(int id) {
    for (var event in allEvents) {
      if (event.id == id) {
        return event.visible;
      }
    }
  }

  Widget _buildCard(List<ScheduleData> allSchedule, BuildContext context) =>
      Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.fromLTRB(2.0, fromHome ? 0.0 : 15, 2, 2),
          height: fromHome
              ? MediaQuery.of(context).size.height * 0.8
              : MediaQuery.of(context).size.height * 0.74,
          child: ListView.builder(
            itemCount: allSchedule.length,
            itemBuilder: (BuildContext context, int index) {
              if (getVisibleFrom(allSchedule[index].eventId) == 0) {
                print("NOPEEE");
                return null;
              }

              return Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Card(
                  color: Colors.white10,
                  child: InkWell(
                    onTap: () {
                      _showBottomModalSheet(context, allSchedule[index]);
                      print(allSchedule[index].eventId);
                    },
                    child: ListTile(
                      title: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                  allSchedule[index].name ?? "error in name",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                  )),
                            ),
                            Container(
                              color: Colors.tealAccent,
                              width: 500.0,
                              height: 1.0,
                              margin: EdgeInsets.all(10.0),
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(
                                          Icons.schedule,
                                          size: 12.0,
                                          color: Colors.greenAccent,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 2.0),
                                          child: Text(
                                            getTime(allSchedule[index]),
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          size: 12.0,
                                          color: Colors.greenAccent,
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3.0),
                                          child: Text(
                                            allSchedule[index].location ??
                                                "hhhh",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(7.0)),
                            Container(
                              padding: EdgeInsets.only(left: 5.0),
                              width: MediaQuery.of(context).size.width,
                              //  color: Colors.red,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 80.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(
                                          Icons.assessment,
                                          size: 15.0,
                                        ),
                                        Text(
                                          "Round ${allSchedule[index].round}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 20.0,
                                      color: Colors.greenAccent,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  getDelCardNameFromEventID(int eventId) {
    int delId;
    for (var event in allEvents) {
      if (event.id == eventId) delId = event.delCardType;
    }

    for (var card in allCards) {
      if (card.id == delId) return card.name;
    }
  }
}
