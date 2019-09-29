import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:techtatva19/main.dart';
import 'package:techtatva19/pages/Categories.dart';
import 'package:techtatva19/pages/Login.dart';
import 'package:techtatva19/pages/Results.dart';
import 'package:techtatva19/pages/Schedule.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    fromHome = false;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(18.0),
            height: 200.0,
            //color: Colors.red,
            child: CarouselSlider(
              autoPlay: true,
              height: 200.0,
              viewportFraction: 1.1,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 500),
              items: <Widget>[
                Image.asset(
                  'assets/slider1.png',
                  fit: BoxFit.contain,
                ),
                Image.asset('assets/slider2.png'),
                Image.asset('assets/slider3.png'),
                Image.asset('assets/slider4.png'),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(58.0, 28.0, 58.0, 32.0),
            color: Colors.greenAccent,
            height: 0.5,
          ),
          _buildHeaderContainer(
              context, 'Schedule', 'assets/Schedule_crop.jpg'),
          _buildHeaderContainer(
              context, 'Categories', 'assets/Categories_crop.png'),
          _buildHeaderContainer(context, 'Results', 'assets/Results_crop.jpg'),
        ],
      ),
    );
  }

  Container _buildHeaderContainer(
      BuildContext context, String name, String image) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      height: 160.0,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.75), BlendMode.darken),
              fit: BoxFit.cover,
              image: AssetImage(image))),
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 10.0),
              width: MediaQuery.of(context).size.width * 0.86,
              height: 70.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.white.withOpacity(0.9),
                        fontFamily: 'Product-Sans-Regular',
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.01,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.left,
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 30.0,
                      color: Colors.white.withOpacity(1.0),
                    ),
                    onPressed: () {},
                  )
                ],
              )),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (name == 'Schedule') {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    fromHome = true;
                    return new Schedule();
                  }));
                }

                if (name == 'Categories') {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    fromHome = true;
                    return new Categories();
                  }));
                }

                if (name == 'Results') {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    fromHome = true;
                    //return new Schedule();
                    return new Results();
                  }));
                }
              },
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}
