//import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Registration(),
    );
  }
}


Dio dio=new Dio();
class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  bool selected=true;
  double width1=265.0;
  Widget login()
  {
    return Text('Register', style: TextStyle(color: Colors.white,fontSize: 20.0),);
  }
  String name, email, mobile,collname,id;
  bool _autovalidate=false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.grey[900],
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: Image.asset('RevelsLogo.png'),
              alignment: Alignment.topCenter,
            ),
            Form(
              key: _key,
              autovalidate: _autovalidate,
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          validator: validatename,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            icon: Icon(Icons.person,color: Color.fromARGB(255, 247, 176, 124),),
                            hintText: 'Name',
                          ),
                          onChanged: (String val){
                            name=val;
                          },
                        )
                    ),
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          validator: validateemail,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            icon: Icon(Icons.mail_outline,color: Color.fromARGB(255, 247, 176, 124),),
                            hintText: 'Email ID',
                          ),
                          onChanged: (String val){
                            email=val;
                          },
                        )
                    ),
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          validator: validatephone,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            icon: Icon(Icons.phone,color: Color.fromARGB(255, 247, 176, 124),),
                            hintText: 'Phone',
                          ),
                          onChanged: (String val){
                            mobile=val;
                          },
                        )
                    ),
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          validator: validatecollegename,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            icon: Icon(Icons.school,color: Color.fromARGB(255, 247, 176, 124),),
                            hintText: 'College Name',
                          ),
                          onChanged: (String val){
                            collname=val;
                          },
                        )
                    ),
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          validator: validateid,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            icon: Icon(Icons.confirmation_number,color: Color.fromARGB(255, 247, 176, 124),),
                            hintText: 'Reg. No./Faculty ID',
                          ),
                          onChanged: (String val){
                            id=val;
                          },
                        )
                    ),
                    Center(
                      child: AnimatedContainer(duration: Duration(milliseconds: 500),
                        width: width1,
                        height: 60,
                        child: Container(
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              color: Colors.blue,
                              child: login(),
                              onPressed: (){
                                _sendToServer();
                                setState(() {});
                              },
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String validatename(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validatephone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Mobile is Required";
    } else if(value.length != 10){
      return "Mobile number must 10 digits";
    }else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

  String validateemail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if(!regExp.hasMatch(value)){
      return "Invalid Email";
    }else {
      return null;
    }
  }

  String validateid(String value){
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "ID is required is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validatecollegename(String value){
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "College Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      selected=!selected;
      if(selected)
        width1=265;
      else {
        String token = "kr4Ju4ImZ7aPJoQLhepb";
        String type = "invisible";
        var response = await dio.post("https://register.techtatva.in/signup/", data: {
          "name":name,
          "email": email,
          "regno":id,
          "collname":collname,
          "mobile":mobile,
          'g-recaptcha-response': token,
          'type': type
        });
        if(response.data['success'] == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.grey[850],
                title: new Text("Success!",style: TextStyle(fontSize: 20,color: Colors.white),),
                content: new Text(
                    "User Registered Successully",style: TextStyle(fontSize: 18,color: Colors.white),),
                actions: <Widget>[
                  new FlatButton(
                    color: Color.fromARGB(255, 22, 159, 196),
                    child: new Text("OK",style: TextStyle(fontSize: 16,color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

        else if(response.data['success'] == false)
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.grey[850],
                title: new Text("Invalid email or password",style: TextStyle(fontSize: 20,color: Colors.white),),
                content: new Text(
                    "Please check the email or password you have entered",style: TextStyle(fontSize: 18,color: Colors.white),),
                actions: <Widget>[
                  new FlatButton(
                    color: Color.fromARGB(255, 22, 159, 196),
                    child: new Text("Try Again",style: TextStyle(fontSize: 16,color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

        print(response.statusCode);

      }

    } else {

      setState(() {
        _autovalidate = true;
      });
    }
  }
}