import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:math' as math;
import './registerButton.dart';
import 'package:flutter/gestures.dart';
import 'package:stretchy_header/stretchy_header.dart';

// void main() {
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     runApp(new FlutterUI());
//   });
// }

class FlutterUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI Challenge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.black,
          ),
          accentColor: Colors.transparent,
          backgroundColor: Colors.grey,
          fontFamily: 'Cabin'),
      home: MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool booltag;
  @override
  void initState() {
    super.initState();
    booltag = true;
  }

  var currentPage = imagesArtist.length - 1.0;
  @override
  Widget build(BuildContext context) {
    PageController controller =
        PageController(initialPage: imagesArtist.length, keepPage: false);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
            Colors.blue,
            Colors.black,
            Colors.black,
            Colors.black,
          ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              tileMode: TileMode.clamp)),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Proshow',
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 10.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              ),
              Stack(
                children: <Widget>[
                  CardScrollWidget(currentPage, imagesArtist, titleArtist),
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: imagesArtist.length,
                      controller: controller,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              _newTaskModalBottomSheet(context);
                            },
                            child: Container(color: Colors.transparent));
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _newTaskModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        elevation: 30.0,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Scaffold(
            body: StretchyHeader.listView(
              headerData: HeaderData(
                  headerHeight: 350,
                  highlightHeaderAlignment: HighlightHeaderAlignment.center,
                  header: Swiper(
                    duration: 200,
                    autoplay: true,
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(child: artistImage(index));
                    },
                  )),
              children: <Widget>[
                getDetails(context, 2),
                getDetails(context, 0),
                Container(
                  height: 3.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        Colors.blueGrey[800],
                        Colors.blueGrey[700],
                        Colors.blueGrey[600],
                        Colors.blueGrey[400],
                      ],
                    ),
                  ),
                ),
                getDetails(context, 1),
              ],
            ),
          );
        });
  }

  Widget artistImage(i) {
    return i == 0
        ? Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(color: Colors.black),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Image.network(
                        'https://eventimages.insider.in/image/main/t5hGb84iT4GLZ6oXUHOQ_Atul_Khatri.jpg',
                        color: Colors.black26,
                        colorBlendMode: BlendMode.darken,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text('Atul Khatri',
                        style: TextStyle(color: Colors.white, fontSize: 40.0))),
              )
            ],
          )
        : Stack(children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(color: Colors.black),
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: Image.network(
                        'https://direct.rhapsody.com/imageserver/images/alb.365170472/500x500.jpg',
                        color: Colors.black26,
                        colorBlendMode: BlendMode.darken,
                        fit: BoxFit.cover),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Prateek Kuhad',
                      style: TextStyle(color: Colors.white, fontSize: 40.0))),
            )
          ]);
  }

  Widget getDetails(context, i) {
    return i == 0
        ? Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'General',
                    style: TextStyle(
                        fontFamily: 'Cabin',
                        color: Colors.white,
                        fontSize: 30.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.only(top: 10.0),
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            height: 150.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                  width: 2.0,
                                  color: Colors.white,
                                )),
                            child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 20.0),
                              height:
                                  MediaQuery.of(context).size.height * 0.35 -
                                      150.0,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    '2nd March, 2020',
                                    style: headStyle(20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5.0,
                                    ),
                                  ),
                                  Text(
                                    '6 PM',
                                    style: headStyle(20),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.35 -
                                        180.0,
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                                      0.35 -
                                                  180.0) /
                                              3,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0)),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text('Academic Block 1',
                                          style: headStyle(20.0)),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          )
        : i == 1
            ? (Container(
                height: 600.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Rules and Regulations',
                        style: TextStyle(
                            fontFamily: 'Cabin',
                            color: Colors.white,
                            fontSize: 30.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, index) {
                          return ruleItem(
                              'Doors will be stricty closed after 10 PM',
                              context);
                        },
                      ),
                    )
                  ],
                ),
              ))
            : Container(
                child: SliderButton(
                    backgroundColor: Colors.black,
                    buttonColor: Colors.greenAccent,
                    radius: 10.0,
                    buttonSize: 80.0,
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    alignLabel: Alignment.centerRight,
                    dismissible: false,
                    action: () {
                      print('Tapped');
                      setState(() {
                        booltag = !booltag;
                      });
                    },
                    label: Text("Swipe Right to Pay",
                        style: TextStyle(color: Colors.black.withOpacity(0.4))),
                    icon: Text('Buy Tickets Now')));
  }
  

  TextStyle headStyle(double fs) {
    return TextStyle(
      color: Colors.white,
      fontSize: fs,
    );
  }
}

var cardAspectRatio = 12.0 / 20.0;
var widgetAspectRatio = cardAspectRatio * 1.25;

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;

  List<String> images;
  List<String> title;

  CardScrollWidget(this.currentPage, this.images, this.title);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var primaryCardLeft = 50.0;
        var horizontalInset = primaryCardLeft;

        List<Widget> cardList = new List();
        for (var i = 0; i < images.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              math.max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 20 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * math.max(-delta, 0.0),
            bottom: padding + verticalInset * math.max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(30.0)),
                  border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(3.0, 6.0),
                        blurRadius: 10.0)
                  ]),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(30.0))),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(30.0)),
                        child: Image.network('https://upload.wikimedia.org/wikipedia/commons/a/a0/Prateek_Kuhad_New.jpg', fit: BoxFit.cover),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 3.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.4),
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.4),
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.4),
                                          ],
                                          tileMode: TileMode.clamp)),
                                  child: Text(title[i],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                      )),
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 12.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black, blurRadius: 2.0)
                                    ],
                                    color: Colors.grey[850],
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text("Day 0",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
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
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}

Widget ruleItem(String rule, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 10.0, left: 20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10.0, top: 10.0),
          height: 5.0,
          width: 5.0,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(
                width: 2.0,
                color: Colors.white,
              )),
        ),
        Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            rule,
            style: headStyle(18.0),
            softWrap: true,
          ),
        )
      ],
    ),
  );
}

List<String> imagesArtist = [
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
];

List<String> titleArtist = [
  'Prateek Kuhad',
  'Prateek Kuhad',
  'Prateek Kuhad',
  'Prateek Kuhad',
];

TextStyle headStyle(double fs) {
  return TextStyle(
    color: Colors.white,
    fontSize: fs,
  );
}
