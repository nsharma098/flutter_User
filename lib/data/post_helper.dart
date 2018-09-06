



import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:screen/models/user.dart';
import 'package:screen/models/value.dart';


class post_helper{

  postit(User user ) async {

    value v = new value(user);
    print(v.toString());

    String obj = json.encode(v.toJson());

    print(obj);


    var url ="http://45.55.53.57:3000/data/signup";

    final response = http.post(url,body: obj)
        .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });


  }

}