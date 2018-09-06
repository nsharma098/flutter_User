

import 'package:screen/models/user.dart';

class value{

  User user;

  value(this.user);

  Map toJson(){
    Map map = new Map();
    map["values"] = user;
    return map;
  }
}