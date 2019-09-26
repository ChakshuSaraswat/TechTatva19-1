import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techtatva19/pages/Home.dart';
import 'package:techtatva19/pages/Schedule.dart';
import 'package:techtatva19/pages/Categories.dart';
import 'package:techtatva19/pages/Results.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DataModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      title: 'TechTatva',
      theme: ThemeData(
        fontFamily: 'Product-Sans',
        brightness: Brightness.dark,
      ),
      home: MyHomePage(),
    );
  }
}

TextStyle headingStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400);
SharedPreferences _preferences;
List<ScheduleData> allSchedule = [];
List<CategoryData> allCategories = [];
List<EventData> allEvents = [];
List<ResultData> allResults = [];

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    _startupCache();
    loadCategories();
    loadSchedule();
    loadEvents();
    loadResults();
  }

  _startupCache() async {
    _preferences = await SharedPreferences.getInstance();
    _cacheSchedule();
    _cacheCategories();
    _cacheEvents();
    _cacheResults();
  }

  void _cacheSchedule() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/schedule"));
      _preferences.setString('Schedule', json.encode(response.body));
    } catch (e) {
      print(e);
    }
  }

  void _cacheCategories() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/categories"));
      _preferences.setString('Categories', json.encode(response.body));
    } catch (e) {
      print(e);
      print("CAT ERRP");
    }
  }

  void _cacheEvents() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/events"));
      _preferences.setString('Events', json.encode(response.body));
    } catch (e) {
      print(e);
      print("error in fetching events");
    }
  }

  void _cacheResults() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.mitrevels.in/results"));
      _preferences.setString('Results', json.encode(response.body));
    } catch (e) {
      print(e);
      print("Error in fetching results");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 1), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  getPage(_pageController) {
    return _pageController.position;
  }

  _buildBottomNavBarItem(String title, Icon icon) {
    return BottomNavigationBarItem(
        backgroundColor: Colors.black,
        activeIcon: icon,
        title: Text(title),
        icon: icon);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Home(),
            Schedule(),
            //Container(),
            //Container(),
            Categories(),
            Results(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          onTap: navigationTapped,
          selectedItemColor: Colors.cyan,
          items: [
            _buildBottomNavBarItem("Home", Icon(Icons.home)),
            _buildBottomNavBarItem("Schedule", Icon(Icons.schedule)),
            _buildBottomNavBarItem("Categories", Icon(Icons.category)),
            _buildBottomNavBarItem("Results", Icon(Icons.assessment)),
          ],
        ),
      ),
    );
  }
}

_fetchEvents() async {
  List<EventData> events = [];

  _preferences = await SharedPreferences.getInstance();

  var jsonData;

  var isCon;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isCon = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    isCon = false;
  }

  try {
    String data = _preferences.getString('Events') ?? null;

    if (data != null && !isCon) {
      jsonData = jsonDecode(jsonDecode(data));
    } else {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/events"));

      if (response.statusCode == 200) jsonData = json.decode(response.body);
    }

    for (var json in jsonData['data']) {
      try {
        var id = json['id'];
        var categoryId = json['category'];
        var name = json['name'];
        var free = json['free'];
        var description = json['shortDesc'];
        var minTeamSize = json['minTeamSize'];
        var maxTeamSize = json['maxTeamSize'];
        var delCardType = json['delCardType'];

        EventData temp = EventData(
            id: id,
            categoryId: categoryId,
            name: name,
            free: free,
            description: description,
            minTeamSize: minTeamSize,
            maxTeamSize: maxTeamSize,
            delCardType: delCardType);

        events.add(temp);
        // print(temp.description);
      } catch (e) {
        print(e);
        print("Error in parsing and fetching events");
      }
    }
  } catch (e) {
    print(e);
  }
  return events;
}

Future<String> loadEvents() async {
  allEvents = await _fetchEvents();
  print(allEvents.length);
  print("WE GOT IT");
  return "success";
}

Future<String> loadResults() async {
  allResults = await _fetchResults();
  print(allResults.length);
  print("GOT THEM RESULTS BOI");
  return "success";
}

_fetchResults() async {
  List<ResultData> results = [];

  _preferences = await SharedPreferences.getInstance();

  var jsonData;

  var isCon;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isCon = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    isCon = false;
  }

  try {
    String data = _preferences.getString('Results') ?? null;

    if (data != null && !isCon) {
      jsonData = jsonDecode(jsonDecode(data));
    } else {
      final response =
          await http.get(Uri.encodeFull("https://api.mitrevels.in/results"));

      if (response.statusCode == 200) jsonData = json.decode(response.body);
    }

    for (var json in jsonData['data']) {
      try {
        var eventId = json['event'];
        var teamId = json['teamid'];
        var position = json['position'];
        var round = json['round'];

        ResultData temp = ResultData(
          eventId: eventId,
          teamId: teamId,
          position: position,
          round: round,
        );

        results.add(temp);
      } catch (e) {
        print(e);
        print("error in parsing results");
      }
    }
  } catch (e) {
    print(e);
  }
  return results;
}

_fetchCategories() async {
  List<CategoryData> category = [];

  _preferences = await SharedPreferences.getInstance();

  var jsonData;

  var isCon;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isCon = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    isCon = false;
  }

  try {
    String data = _preferences.getString('Categories') ?? null;

    if (data != null && !isCon) {
      jsonData = jsonDecode(jsonDecode(data));
    } else {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/categories"));

      if (response.statusCode == 200) jsonData = json.decode(response.body);
    }

    for (var json in jsonData['data']) {
      try {
        var id = json['id'];
        var name = json['name'];
        var description = json['description'];
        var type = json['type'];
        var cc1Name = json['cc1Name'];
        var cc1Contact = json['cc1Contact'];
        var cc2Name = json['cc2Name'];
        var cc2Contact = json['cc2Contact'];

        // add more with changes to API

        CategoryData temp = CategoryData(
            id: id,
            name: name,
            description: description,
            type: type,
            cc1Contact: cc1Contact,
            cc1Name: cc1Name,
            cc2Contact: cc2Contact,
            cc2Name: cc2Name);

        category.add(temp);
      } catch (e) {
        print("error categories");
      }
    }
  } catch (e) {
    print(e);
  }
  return category;
}

Future<String> loadCategories() async {
  List<CategoryData> temp = await _fetchCategories();
  allCategories.clear();
  try {
    for (var item in temp) {
      if (item.type == "TECHNICAL") {
        allCategories.add(item);
      }
    }
  } catch (e) {
    print(e);
    print("lol ho gaya");
    return "success";
  }
  print(allCategories.length);
  return "success";
}

_fetchSchedule() async {
  List<ScheduleData> schedule = [];

  _preferences = await SharedPreferences.getInstance();

  String data = _preferences.getString('Schedule') ?? null;

  var jsonData;

  var isCon;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isCon = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    isCon = false;
  }

  try {
    if (data == null && !isCon) {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/schedule"));

      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
      }
    } else {
      print("CACHEDDDDD");
      jsonData = jsonDecode(jsonDecode(data));
    }

    for (var json in jsonData['data']) {
      try {
        var id = json['id'];
        var eventId = json['eventId'];
        var round = json['round'] ?? 3;
        var name = json['eventName'];
        var categoryId = json['categoryId'];
        var location = json['location'];
        var startTime = DateTime.parse(json['start']);
        var endTime = DateTime.parse(json['end']);

        ScheduleData temp = ScheduleData(
          id: id,
          eventId: eventId,
          round: round,
          name: name,
          categoryId: categoryId,
          startTime: startTime,
          endTime: endTime,
          location: location,
        );

        schedule.add(temp);
      } catch (e) {
        print("CANT DO IT");
        print(e);
      }
    }
  } catch (e) {
    print(e);
  }
  return schedule;
}

Future<String> loadSchedule() async {
  allSchedule = await _fetchSchedule();
  return "success";
}

List<ScheduleData> scheduleForDay(List<ScheduleData> allSchedule, String day) {
  List<ScheduleData> temp = [];

  switch (day) {
    case 'Wednesday':
      for (var i in allSchedule) {
        if (i.startTime.day == 9) temp.add(i);
      }
      break;

    case 'Thursday':
      for (var i in allSchedule) {
        if (i.startTime.day == 10) temp.add(i);
      }
      break;

    case 'Friday':
      for (var i in allSchedule) {
        if (i.startTime.day == 11) temp.add(i);
      }
      break;

    case 'Saturday':
      for (var i in allSchedule) {
        if (i.startTime.day == 12) temp.add(i);
      }
      break;

    default:
      print("ERROR IN DAY WISE PARSINGG");
      break;
  }

  return temp;
}

String getTime(ScheduleData schedule) {
  return '${schedule.startTime.hour.toString()}:${schedule.startTime.minute.toString() == '0' ? '00' : schedule.startTime.minute.toString()} - ${schedule.endTime.hour.toString()}:${schedule.endTime.minute.toString() == '0' ? '00' : schedule.endTime.minute.toString()}';
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }

  static buildSliverAppBar(String name, String image) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(name, style: headingStyle),
          background: Image.asset(image,
              color: Colors.black.withOpacity(0.55),
              colorBlendMode: BlendMode.darken,
              fit: BoxFit.cover)),
      actions: <Widget>[
        Container(
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.satellite),
          ),
        )
      ],
    );
  }
}
