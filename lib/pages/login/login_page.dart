import 'package:flutter/material.dart';
import 'package:screen/data/database_helper.dart';
import 'package:screen/data/post_helper.dart';
import 'package:screen/models/user.dart';
import 'package:screen/pages/login/login_presenter.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'dart:convert';




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract {
  BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  List<User> user = List();
  bool hasLoaded = false;

  final PublishSubject subject = PublishSubject<String>();

  @override
  void dispose(){
    subject.close();
    super.dispose();
  }





  void resetUser(){
    setState(() => user.clear());
  }
  String _username, _password,_email,_address,_phonenum ;

  LoginPagePresenter _presenter;

  _LoginPageState() {
    _presenter = new LoginPagePresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _presenter.doLogin(_username, _password ,_address,_email,_phonenum);
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    bool btn = false;
    bool _autoValidate = false;
    _ctx = context;
    var loginBtn = Container(
      width:120.0 ,
      child: new FlatButton(
        onPressed: _submit,

        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text("Login"),
            ),
            new Icon(Icons.subdirectory_arrow_right)
          ],
        ),
        color: Colors.teal,
        splashColor: Colors.white30,
        shape: RoundedRectangleBorder( side: BorderSide(style: BorderStyle.none)),
        disabledColor: Colors.black38,



      ),
    );
    var loginForm = SingleChildScrollView(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            "Sign Up here",
            textScaleFactor: 2.0,
          ),
          new Form(
            key: formKey,
            autovalidate: _autoValidate,
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 36.0,right: 36.0),
                  child: new TextFormField(
                    autovalidate: _autoValidate ,
                    onSaved: (val) => (_username = val),
                    decoration: new InputDecoration(labelText: "Username",prefixIcon: Icon(Icons.supervisor_account)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter UserName';
                      }else if(value.length < 4){
                        return 'Please enter upto 4Chars';
                      }
                    },


                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 36.0,right: 36.0),
                  child: new TextFormField(
                      autovalidate: _autoValidate ,
                    onSaved: (val) => _password = val,
                    decoration: new InputDecoration(labelText: "Password" ,prefixIcon:Icon(Icons.lock_open) ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter UserName';
                        }else if(value.length < 4){
                          return 'Please enter upto 4Chars';
                        }
                      }
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 36.0,right: 36.0),
                  child: new TextFormField(
                      autovalidate: _autoValidate ,
                    onSaved: (val) => (_email = val),
                    decoration: new InputDecoration(labelText: "email",prefixIcon: Icon(Icons.email)),
                      validator: (value) {

                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value))
                          return 'Enter Valid Email';
                        else
                          return null;
                      }
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 36.0,right: 36.0),
                  child: new TextFormField(
                      autovalidate: _autoValidate ,
                    onSaved: (val) => (_phonenum = val),
                    decoration: new InputDecoration(labelText: "Phone Number",prefixIcon: Icon(Icons.phone)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Number';
                        }else if(value.length < 10){
                          return 'Please enter the correct number';
                        }else if(value.length > 10){
                          return 'Please enter the correct number';
                        }
                      }
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 36.0,right: 36.0),
                  child: new TextFormField(
                      autovalidate: _autoValidate,
                    onSaved: (val) => _address = val,
                    decoration: new InputDecoration(labelText: "Address",prefixIcon: Icon(Icons.book)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the Address';
                        }else if(value.length < 10){
                          return 'Please enter upto more Chars';
                        }else{
                          return null;
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
          loginBtn
        ],
      ),
    );

    return new Scaffold(

      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: loginForm,
        ),
      ),
    );
  }

  @override
  void onLoginError(String error) {
    // TODO: implement onLoginError
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(User user) async {
    // TODO: implement onLoginSuccess
    _showSnackBar(user.toString());
    setState(() {
      _isLoading = false;
    });
    var db = new DatabaseHelper();
    var po = new post_helper();

    await po.postit(user);
    await db.saveUser(user);

    Navigator.of(context).pushNamed("/home");
  }
}
