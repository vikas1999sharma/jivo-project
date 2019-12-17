import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/Models/Loginmodel.dart';
import 'HomeScreen.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  BuildContext buildContext;
  String email, password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final String loginUrl = 'http://122.160.78.189:85/api/Web';

  bool loading;

  bool checkValue = false;

  SharedPreferences sharedPreferences;

  bool _validate = false;

  @override
  void initState() {
    super.initState();
    getCredential();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: new Scaffold(
          body: Stack(fit: StackFit.expand, children: <Widget>[
            new Image(
              image: AssetImage("assets/b.png"),
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
            ),
            Form(
                key: _formKey,
                autovalidate: _validate,
                child: new Container(
                    margin: EdgeInsets.all(10.0),
                    child: Center(
                        child: SingleChildScrollView(
                            child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: const EdgeInsets.all(8.0)),
                        new Image.asset(
                          "assets/jivologo.png",
                          width: 400.0,
                          height: 120.0,
                          fit: BoxFit.contain,
                        ),
                        Padding(padding: const EdgeInsets.all(15.0)),
                        TextFormField(
                          controller: userTextController,
                          autofocus: false,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide user name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'USER NAME',
                            filled: true,
                            labelStyle: TextStyle(),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => email = input,
                        ),
                        new SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                        ),
                        TextFormField(
                            controller: passwordTextController,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Provide password please';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.security),
                              filled: true,
                              labelStyle: TextStyle(),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            onSaved: (input) => password = input,
                            obscureText: true,
                            keyboardType: TextInputType.text),
                        new SizedBox(height: 20.0),
                        new CheckboxListTile(
                          value: checkValue,
                          onChanged: _onChanged,
                          title: new Text("Remember me"),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        new Container(
                          width: 180.0,
                          height: 40,
                          child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              child: Text('LOGIN'),
                              onPressed: () async {
                                // _formKey.currentState.save();
                                if (_formKey.currentState.validate()) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      });
                                  _formKey.currentState.save();
                                  email = userTextController.text;
                                  password = passwordTextController.text;
                                  await doLogin(email, password);
                                  //Navigator.pop(context);
                                } else {
                                  setState(() {
                                    _validate = true;
                                  });
                                }
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(25.0))),
                        ),
                        new SizedBox(height: 20.0),
                      ],
                    ))))),
          ]),
        ));
  }

  _onChanged(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      sharedPreferences.setBool("check", checkValue);
      sharedPreferences.setString(
          "emailTextController", userTextController.text);
      sharedPreferences.setString(
          "passwordTextController", passwordTextController.text);
      // sharedPreferences.commit();
      getCredential();
    });
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          userTextController.text =
              sharedPreferences.getString("emailTextController");
          passwordTextController.text =
              sharedPreferences.getString("passwordTextController");
        } else {
          userTextController.clear();
          passwordTextController.clear();
          sharedPreferences.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }

  @override
  void dispose() {
    userTextController.dispose();
    passwordTextController.dispose();

    super.dispose();
    setState(() {
      loading = false;
    });
  }

  Future<void> doLogin(String email, String password) async {
    final loginurl = loginUrl + '?name=' + email + '&pwd=' + password;

    final response = await http.get(loginurl);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      List<Loginmodel> userList = responseJson
          .map<Loginmodel>((json) => new Loginmodel.fromJson(json))
          .toList();
      if (userList[0].userid != "0") {
        prefs.setString('email', userList[0].name);
        prefs.setString('id', userList[0].userid);
        Navigator.push(
          buildContext,
          MaterialPageRoute(
              builder: (context) => HomeScreen(data: userList[0].name)),
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Input is Wrong ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
