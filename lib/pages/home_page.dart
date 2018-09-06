import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Logged In Users"),
      ),
      body: PhotoList(),
    );
  }
}



class PhotoList extends StatefulWidget {
  @override
  PhotoListState createState() => PhotoListState();
}

class PhotoListState extends State<PhotoList> {


  //List list;

  Future<List<allUser>> fetchPost() async {
    final response =
        await http.get('http://45.55.53.57:3000/data/user');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      print("okDone");
      var jsonData =jsonDecode(response.body);
      List<allUser> users = [];
      for(var u in jsonData){
        allUser a = allUser(u["user"], u["email"], u["address"], u["phone_no"]);
        users.add(a);
      }
      return users;

    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: fetchPost(),
            builder: (BuildContext context ,AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("loading....."),
                  ),
                );
              }if (snapshot.hasError) { print(snapshot.error.toString()); }
              else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(snapshot.data.length);

                      return Container(

                        width: double.infinity,
                        child: Card(
                          elevation: 2.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(side: BorderSide(style: BorderStyle.none)),
                          child: Column(
                            children: <Widget>[
//                          RichText(
//                          text: TextSpan(text: "* " +snapshot.data[index].user,
//                          style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 24.0,
//                            letterSpacing: 2.0,
//
//                          ))),
                          RichText(
                              text: TextSpan(text: "Email : " +snapshot.data[index].email,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    letterSpacing: 2.0,

                                  ))),
                          RichText(
                              text: TextSpan(text: "Address : " +snapshot.data[index].address,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    letterSpacing: 2.0,

                                  ))),
                          RichText(
                              text: TextSpan(text: "Mobile : " +snapshot.data[index].phone_no,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    letterSpacing: 2.0,

                                  ))),
                            ],



                          ),
                        )
                      );
                    });
              }
            })

      ),
    );
  }




  }


class allUser {
  final String user;
  final String email;
  final String address;
  final String phone_no;

  allUser(
      this.user,
      this.email,
      this.address,
      this.phone_no
      );

  allUser.fromJsonMap(Map map)
      : user = map['user'],
        email = map['email'],
        address =map['address'],
        phone_no = map['phone_no'];
}
