import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:techtatva19/organizers/events.dart';
import 'package:techtatva19/organizers/proshow.dart';
import '../organizers/events.dart';
import '../organizers/proshow.dart';
import '../organizers/registration.dart';

Widget RevelsDrawer(BuildContext context){
  return Drawer(
          child: Stack(
            children: <Widget>[
            Container(
              color: Colors.black,
              child: FlareActor(
                "assets/revels_drawer_top.flr",animation: 'stars_moving',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            Container(
              color: Colors.transparent,
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                      child: Stack(children: <Widget>[
                        Container(
                          child: Image.asset('assets/ttlogo.png'),
                          alignment: Alignment.center,
                        ),
                      ]
                      )
                  ),
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text('Chakshu Saraswat',style: TextStyle(color: Colors.white,fontSize: 20),overflow: TextOverflow.fade,),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 7),
                    child: Text('chakshu.saraswat@gmail.com',style: TextStyle(color: Colors.white70,fontSize: 16),overflow: TextOverflow.fade,),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.favorite,color: Color.fromARGB(255, 247, 176, 124),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('Events',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                      ],
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Sample2()),
                      );
                    },
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.local_movies,color: Color.fromARGB(255, 247, 176, 124),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('Proshow',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                      ],
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuPage()),
                      );
                    },
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.featured_play_list,color: Color.fromARGB(255, 247, 176, 124),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('Featured',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                      ],
                    ),
                    onPressed: (){},
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.developer_mode,color: Color.fromARGB(255, 247, 176, 124),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('Developers',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                      ],
                    ),
                    onPressed: (){},
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    alignment: Alignment.bottomCenter,
                    child: FlatButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(
                            color: Colors.blue[500]
                        ),
                      ),
                      child: Text('Logout',style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
