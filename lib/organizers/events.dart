import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

void main() => runApp(MyApp());

List rendertags = <String>[];
Map eventlist = {};
List renderevents = [];
MediaQueryData deviceinfo;


List filterchips = <Widget>[
  filterChipWidget(
    chipName: 'tag1',
    IsSelected: false,
  ),
  filterChipWidget(
    chipName: 'tag2',
    IsSelected: false,
  ),
  filterChipWidget(
    chipName: 'tag3',
    IsSelected: false,
  ),
  filterChipWidget(
    chipName: 'Fashion',
    IsSelected: false,
  ),
  filterChipWidget(
    chipName: 'Miscelleaneous',
    IsSelected: false,
  ),
];

void getrenderevents() {
  rendertags = [];
  renderevents = [];
  for (int i = 0; i < filterchips.length; i++) {
    if (filterchips[i].IsSelected) rendertags.add(filterchips[i].chipName);
  }
  if (eventlist != null) {
    if (rendertags.length == 0)
      for (int i = 0; i < eventlist['data'].length; i++)
        renderevents.add(eventlist['data'][i]);
    else
      for (int i = 0; i < eventlist['data'].length; i++) {
        for (int j = 0; j < rendertags.length; j++)
          if (eventlist['data'][i]['tags'].contains(rendertags[j])) {
            renderevents.add(eventlist['data'][i]);
          }
      }
    renderevents = renderevents.toSet().toList();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Color.fromARGB(255, 22, 159, 196),
      ),
      home: Sample2(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Sample2 extends StatefulWidget {
  @override
  _Sample2State createState() => _Sample2State();
}

class _Sample2State extends State<Sample2> {
  ScrollController sc = new ScrollController();
  bool done = false;


  Future<Map> fetchEvents() async {
    http.Response response =
        await http.get('https://api.myjson.com/bins/q1x5o');
    setState(() {
      done = true;
    });
    return json.decode(response.body);
  }



  @override
  Widget build(BuildContext context) {
    deviceinfo = MediaQuery.of(context);
    return SafeArea(
        child: Material(
            child: NestedScrollView(controller: sc,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
              return <Widget>[
                SliverAppBar(
                  floating: false,
                  pinned: true,
                  expandedHeight: 250,
                  flexibleSpace: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(43, 42, 42, 0.8),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        overflow: Overflow.visible,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(255, 22, 159, 196),
                                    Colors.black,
                                  ],
                                  stops: [
                                    0.0,
                                    0.95
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Wrap(
                                      spacing: 5.0,
                                      runSpacing: 3.0,
                                      children: filterchips,
                                    )),
                              ),
                              // ),
                            ),
                            // ),
                          ),
                        ],
                      )),),
              ];
                },
              body: Container(
                      child: FutureBuilder(
                          future: fetchEvents(),
                          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                            Map content = snapshot.data;
                            eventlist = content;
                            getrenderevents();
                            return (eventlist!=null)
                                ? Center(
                                child: Container(
                                    width: deviceinfo.size.width,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                    ),
                                    child: ListView.builder(
                                        controller: sc,
                                        itemCount: renderevents.length,
                                        addRepaintBoundaries: true,
                                        //primary: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                              onTap: () {
                                                _newTaskModalBottomSheet(context, renderevents[index]);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(43, 42, 42, 0.8),
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    boxShadow: [
                                                      BoxShadow(color: Colors.black, blurRadius: 5.0,
                                                      ),
                                                    ]),
                                                width: deviceinfo.size.width,
                                                height: 100.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(renderevents[index]['name'],
                                                            style: TextStyle(color: Colors.white, fontSize: 20), overflow: TextOverflow.ellipsis,
                                                          ),
                                                          padding: EdgeInsets.only(left: 5, right: 5),
                                                          width: deviceinfo.size.width * 0.65,
                                                          alignment: Alignment.center,
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(top: 5, bottom: 5),
                                                          height: 2,
                                                          color: Color.fromARGB(255, 22, 159, 196),
                                                          width: MediaQuery.of(context).size.width * 0.5,
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                                                            width: deviceinfo.size.width * 0.65,
                                                            alignment: Alignment.center,
                                                            child: Text(renderevents[index]['category'].toString(),
                                                              style: TextStyle(color: Colors.white,fontSize: 16,), overflow: TextOverflow.fade,
                                                            ))
                                                      ],
                                                    ),
                                                    Container(
                                                      margin:
                                                      EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 20.0),
                                                      child: Icon(Icons.info_outline, color: Color.fromARGB(255, 22, 159, 196),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        })))
                                : Container(
                                decoration: BoxDecoration(color: Colors.black),
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Shimmer.fromColors(
                                        highlightColor:
                                        Color.fromARGB(255, 22, 159, 196),
                                        baseColor: Colors.black,
                                        child: ImageIcon(
                                          AssetImage('RevelsLogo.png'),
                                          size: 300.0,
                                        ))));
                          }))
    )));
  }
}

class filterChipWidget extends StatefulWidget {
  final String chipName;
  var IsSelected = false;
  filterChipWidget({Key key, this.chipName, this.IsSelected}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 22, 159, 196),
          child: Container(
            child: Image.asset('RevelsLogo.png'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.black,
            ),
          )),
      label: Text(widget.chipName),
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      selected: widget.IsSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.black87,
      onSelected: (isSelected) {
        setState(() {
          getrenderevents();
          widget.IsSelected = isSelected;
        });
        getrenderevents();
      },
      selectedColor: Color.fromARGB(255, 22, 159, 196),
    );
  }
}

void _newTaskModalBottomSheet(context, event) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
          color: Color.fromARGB(255, 20, 20, 20),
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: [
              Container(
                  color: Color.fromARGB(255, 20, 20, 20),
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: Text(event['name'],
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.white)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Divider(
                          color: Color.fromARGB(255, 22, 159, 196),
                          thickness: 3.0,
                        ),
                      ),
                      Container(
                        child: Text(event['category'].toString(),
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white)),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: getDetails(context, event),
              ),
            ],
          ),
        );
      });
}

Widget getDetails(context, event) {
  return Container(
    width: MediaQuery.of(context).size.width,
    color: Color.fromARGB(255, 20, 20, 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Text(
            event['delCardType'].toString(),
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Description:',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text(event['longDesc'],
                  style: TextStyle(color: Colors.white70, fontSize: 16.0),
                  textAlign: TextAlign.center),
            )
          ],
        ),
        Container(
            margin: const EdgeInsets.only(top: 10.0),
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child:
                            Text('Team Size: ', style: TextStyle(fontSize: 20,color: Colors.white)),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 30.0 + 20 * event['minTeamSize'] / 4,
                              width: 30.0 + 20 * event['minTeamSize'] / 4,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 22, 159, 196),
                                ),
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 22, 159, 196),
                              )),
                          Container(
                              height: 30.0 + 20 * event['minTeamSize'] / 4,
                              width: 30.0 + 20 * event['minTeamSize'] / 4,
                              child: Center(
                                child: Text(event['minTeamSize'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                      Container(
                        width: 30.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          shape: BoxShape.rectangle,
                          color: Color.fromARGB(255, 22, 159, 196),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 30.0 + 20 * event['maxTeamSize'] / 4,
                              width: 30.0 + 20 * event['maxTeamSize'] / 4,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 22, 159, 196),
                                ),
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 22, 159, 196),
                              )),
                          Container(
                              height: 30.0 + 20 * event['maxTeamSize'] / 4,
                              width: 30.0 + 20 * event['maxTeamSize'] / 4,
                              child: Center(
                                child: Text(event['maxTeamSize'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
        Center(
          child: Container(
            width: 260,
            height: 50,
            child: Container(
                child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              color: Color.fromARGB(255, 22, 159, 196),
              child: Text(
                'Register',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () {},
            )),
          ),
        ),
      ],
    ),
  );
}
