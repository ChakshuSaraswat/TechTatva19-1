import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import "package:techtatva19/main.dart";
import "../main.dart";
import 'dart:async';
import 'package:techtatva19/DataModel.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

//List<ScheduleData> allSchedule = [];

class _ScheduleState extends State<Schedule> with TickerProviderStateMixin {
  bool isFABTapped = false;

  SharedPreferences _preferences;

//  allSchedule = [];

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
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                children: <Widget>[
                  _buildCard(scheduleForDay(allSchedule, 'Wednesday'), context),
                  _buildCard(scheduleForDay(allSchedule, 'Thursday'), context),
                  _buildCard(scheduleForDay(allSchedule, 'Friday'), context),
                  _buildCard(scheduleForDay(allSchedule, 'Saturday'), context),
                ],
              ),
            )
            ),
      ),
    );
  }

  Widget _buildTab(String day, String date) => Tab(
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
      );

  _showBottomModalSheet(BuildContext context, ScheduleData schedule) {
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
              height: MediaQuery.of(context).size.height * 0.75,
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
                  FlatButton(
                    onPressed: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        color: Colors.greenAccent.shade400.withOpacity(0.7),
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
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

  Widget _buildCard(List<ScheduleData> allSchedule, BuildContext context) =>
      Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black,
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
}
