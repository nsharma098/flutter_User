import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

class User {
   String _name;
   String _address;
   String _email;


   String _phoneNum;
   String _password;

  User(
     this._name,
      this._password,
      this._address,
      this._email,
      this._phoneNum,
  );

    String get name => _name;
   String get password => _password;
   String get address => _address;
   String get email => _email;
   String get phonenum => _phoneNum;



   User.map(dynamic obj) {
     this._name = obj['name'];
     this._password = obj['password'];
     this._address = obj['address'];
     this._email = obj['email'];
     this._phoneNum = obj['phonenum'];
   }



   Map<String, dynamic> toMap() {
     var map = new Map<String, dynamic>();
     map["name"] = _name;
     map["password"] = _password;
     map["address"] = _address;
     map["email"] = _email;
     map["phonenum"] = _phoneNum;

     return map;
   }

   Map toJson() {
     Map map = new Map();
     map["name"] = _name;
     map["address"] = _address;
     map["email"] = _email;
     map["phone_no"] = _phoneNum;
     map["password"] = _password;
     return map;
   }

}



