import 'dart:async';

import 'package:screen/models/user.dart';
import 'package:screen/utils/network_util.dart';



class RestData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "";
  static final LOGIN_URL = BASE_URL + "/";

  Future<User> login(String username, String password , String address ,String email , String phonenum) {
    return new Future.value(new User(username, password, address ,email, phonenum));
  }
}
