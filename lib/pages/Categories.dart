import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techtatva19/models/CategoryModel.dart';
import 'package:techtatva19/models/ScheduleModel.dart';
import 'package:http/http.dart' as http;
import 'package:techtatva19/pages/Schedule.dart';
import 'dart:async';
import 'Login.dart';
import 'Schedule.dart';
import 'dart:convert';
import 'package:flare_flutter/flare_actor.dart';
import '../main.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> with TickerProviderStateMixin {
  bool isBottomSheetTapped = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences _preferences;

  bool isTapped = true;

  _buildFloatingActionButton() {
    return InkWell(
      child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn,
          height: isTapped ? 56.0 : 40.0,
          width: isTapped
              ? 56
              : MediaQuery.of(_scaffoldKey.currentContext).size.width * 0.7,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(100.0)),
          child: isTapped
              ? IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      isTapped = !isTapped;
                    });
                  },
                )
              : Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            isTapped = !isTapped;
                          });
                        },
                      ),
                      Container(
                        width: !isTapped
                            ? MediaQuery.of(context).size.width * 0.5
                            : 10.0,
                        alignment: Alignment.center,
                        child: ClipRect(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "search here...",
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5))),
                            onSubmitted: (str) {
                              setState(() {
                                isTapped = !isTapped;
                              });
                            },
                            //   autofocus: true,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        floatingActionButton: _buildFloatingActionButton(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBarDelegate.buildSliverAppBar(
                  "Categories", "assets/Categories.png")
            ];
          },
          body: Container(
            padding: EdgeInsets.only(top: 10.0),
            child: ListView.builder(
              itemCount: allCategories.length,
              itemBuilder: (BuildContext context, int index) {
                if (allCategories[index].type == "TECHNICAL")
                  return _buildCategoryCard(context, index);
              },
            ),
          ),
        ));
  }

  _showBottomModalSheet(BuildContext context, int index) {
    TabController _controller = TabController(length: 4, vsync: this);
    showModalBottomSheet(
        backgroundColor: Colors.black,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.82,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Text(allCategories[index].name,
                      style: TextStyle(fontSize: 26.0)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 1.0,
                  color: Colors.greenAccent,
                ),
                Container(
                  height: 5.0,
                  width: 200.0,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      _buildBottomSheetContactTile(
                          allCategories[index].cc1Name ?? "unavailable",
                          allCategories[index].cc1Contact ?? "unavailable"),
                      Container(
                        height: 5.0,
                        width: 1.0,
                      ),
                      _buildBottomSheetContactTile(
                          allCategories[index].cc2Name ?? "unavailable",
                          allCategories[index].cc2Contact ?? "unavailable"),
                      Container(
                        height: 10.0,
                      ),
                      TabBar(
                        controller: _controller,
                        tabs: <Widget>[
                          Tab(
                            text: "Day 1",
                          ),
                          Tab(
                            text: "Day 2",
                          ),
                          Tab(
                            text: "Day 3",
                          ),
                          Tab(
                            text: "Day 4",
                          )
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: TabBarView(
                          controller: _controller,
                          children: <Widget>[
                            _buildScheduleCard(
                                scheduleForDay(
                                    _scheduleForCategory(
                                        allSchedule, allCategories[index]),
                                    'Wednesday'),
                                context),
                            _buildScheduleCard(
                                scheduleForDay(
                                    _scheduleForCategory(
                                        allSchedule, allCategories[index]),
                                    'Thursday'),
                                context),
                            _buildScheduleCard(
                                scheduleForDay(
                                    _scheduleForCategory(
                                        allSchedule, allCategories[index]),
                                    'Friday'),
                                context),
                            _buildScheduleCard(
                                scheduleForDay(
                                    _scheduleForCategory(
                                        allSchedule, allCategories[index]),
                                    'Saturday'),
                                context),
                            //  _buildCard(allSchedule, context),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  _scheduleForCategory(
      List<ScheduleData> allSchedule, CategoryData categoryData) {
    List<ScheduleData> temp = [];

    for (var i in allSchedule) {
      if (i.categoryId == categoryData.id) {
        temp.add(i);
      }
    }
    return temp;
  }

  Widget _buildScheduleCard(
      List<ScheduleData> allSchedule, BuildContext context) {
    return allSchedule.length == 0
        ? Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.height * 0.4,
                alignment: Alignment.topCenter,
                child: FlareActor(
                  'assets/NoEvent.flr',
                  animation: 'noEvents',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                child: Text(
                  "No Events Today.",
                  style: TextStyle(color: Colors.white54, fontSize: 18.0),
                ),
              )
            ],
          )
        : Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(2.0),
              height: MediaQuery.of(context).size.height * 0.74,
              child: ListView.builder(
                itemCount: allSchedule.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Card(
                      color: Colors.white10,
                      child: InkWell(
                        onTap: () {
                          _showCategoryScheduleBottomModalSheet(
                              context, allSchedule[index]);
                        },
                        child: ListTile(
                          title: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text(allSchedule[index].name ?? "ee",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22.0,
                                      )),
                                ),
                                Container(
                                  color: Colors.greenAccent,
                                  width: 400.0,
                                  height: 1.0,
                                  margin: EdgeInsets.only(top: 10.0),
                                ),
                                Padding(padding: EdgeInsets.all(5.0)),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
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
                                              padding:
                                                  EdgeInsets.only(left: 2.0),
                                              child: Text(
                                                getTime(allSchedule[index]),
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
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
                                                  maxWidth:
                                                      MediaQuery.of(context)
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
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                ),
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
  }

  Row _buildBottomSheetContactTile(String name, String contact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.person,
              size: 22.0,
              color: Colors.white,
            ),
            Container(
              width: 10.0,
            ),
            Text(
              name,
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              contact,
              style: TextStyle(fontSize: 16.0, color: Colors.white54),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, int index) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Card(
          color: Colors.white.withOpacity(0.1),
          margin: EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              _showBottomModalSheet(context, index);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(60.0, 10, 10, 10),
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      allCategories[index].name,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        height: 0.7,
                        width: 200.0),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(4.0, 4.0, 5.0, 4.0),
                    child: Text(
                      allCategories[index].description,
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.017,
          top: 25.0,
          child: CircleAvatar(
            radius: 45.0,
            child: Image.asset("assets/QI.png"),
          ),
        )
      ],
    );
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

  getEventNameFromID(int id) {
    print(allEvents.length);

    for (var event in allEvents) {
      if (id == event.id) return event.name;
    }
  }

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

  _showCategoryScheduleBottomModalSheet(
      BuildContext context, ScheduleData schedule) {
    TabController _controller = TabController(length: 2, vsync: this);

    print(allCategories.length);

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

    print(scheduleCategory.name);

    showModalBottomSheet(
        backgroundColor: Colors.black,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 600.0,
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
                    height: MediaQuery.of(context).size.height * 0.52,
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
                            _buildEventListTileInfo(Icon(Icons.people),
                                "Team Size:", getTeamSize(schedule)),
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
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.w400, color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
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
}
