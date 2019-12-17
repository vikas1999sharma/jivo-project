import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myproject/Models/JivoOutput.dart';
import 'package:myproject/SalesOrderPages/SalesDashboard.dart';
import 'CustomerLimit.dart';
import 'ExpenseReport.dart';
import 'LoginPage.dart';
import 'package:intl/intl.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:http/http.dart' as http;
import 'LimitUpdation.dart';
import 'PartiesName.dart';
import 'SapDashboard.dart';

JivoOutput jivoOutput;
const String userId = '';
class HomeScreen extends StatefulWidget {
  final String data;

  HomeScreen({this.data});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext buildContext;
  String username;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final formatter = new NumberFormat("#,####");

  @override
  void initState() {
    super.initState();
    getCustomerTotalOutstanding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellowAccent,
        resizeToAvoidBottomPadding: false,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  widget.data,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.purple,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  'Jivo Accounts',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(
                      Icons.account_circle,
                    ),
                  ),
                ),
                decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/ddd.jpg"), fit: BoxFit.cover),
                  color: Colors.purple,
                ),
              ),
              ListTile(
                title: Text(
                  'Customer Outstanding',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PartiesName()),
                  );
                },
              ),
              ListTile(
                title: Text('Add Customer Limit',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchCustLimit()),
                  );
                },
              ),
              ListTile(
                title: Text('Check Limit Changes',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LimitUpdation()),
                  );
                },
              ),
              ListTile(
                title: Text('SAP Back Date Rights',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                trailing: Icon(Icons.arrow_forward_ios),
                //leading: const Icon(Icons.navigate_next),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SapDashboard()),
                  );
                },
              ),
             /*  ListTile(
                title: Text('Reports ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                trailing: Icon(Icons.arrow_forward_ios),
                //leading: const Icon(Icons.navigate_next),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RealiseReport()),
                  );
                },
              ), */
              ListTile(
                title: Text('Sales Order ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                trailing: Icon(Icons.arrow_forward_ios),
                //leading: const Icon(Icons.navigate_next),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalesDashboard()),
                  );
                },
              ),
              ListTile(
                title: Text('Expense Report',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                trailing: Icon(Icons.arrow_forward_ios),
                //leading: const Icon(Icons.navigate_next),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExpenseReport()),
                  );
                },
              ),
              ListTile(
                title: Text('Log Out',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                trailing: Icon(Icons.exit_to_app),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('email');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'DASHBOARD',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(10),
              //margin: EdgeInsets.all(10.0),
              color: Colors.white,
              child: ListView(children: <Widget>[
                new Container(
                  margin: EdgeInsets.all(5),
                  child: new Row(
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.all(2.0)),
                      Expanded(
                        child: new Image.asset(
                          "assets/logo.png",
                          width: 550.0,
                          height: 300.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(17),
                ),
                new Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: new Column(children: <Widget>[
                          new Card(
                              child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                              ),
                              new Expanded(
                                  child: new Text(
                                "Customer Outstanding ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Padding(padding: const EdgeInsets.all(2)),
                              new FutureBuilder<JivoOutput>(
                                  future: getCustomerTotalOutstanding(),
                                  builder: (context, snapShot) {
                                    return (snapShot.connectionState ==
                                            ConnectionState.done)
                                        ? snapShot.hasData
                                            ? new Text(
                                                "\u20B9" +
                                                    formatter.format(
                                                      double.parse(snapShot.data
                                                          .currentOutstanding),
                                                    ),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ))
                                            : InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      32.0),
                                                  child: Text(
                                                      "ERROR,Tap to Retry !"),
                                                ),
                                                onTap: () => setState(() {}))
                                        : CircularProgressIndicator();
                                  }) 
                            ],
                          )),
                          Padding(
                            padding: const EdgeInsets.all(5),
                          ),
                          new Card(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                ),
                                new Expanded(
                                    child: new Text(
                                  "Customer OverDue ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                Padding(padding: const EdgeInsets.all(2)),
                               new FutureBuilder<JivoOutput>(
                                    future: getCustomerTotalOutstanding(),
                                    builder: (context, snapShot) {
                                      return (snapShot.connectionState ==
                                              ConnectionState.done)
                                          ? snapShot.hasData
                                              ? new Text(
                                                  "\u20B9" +
                                                      formatter.format(
                                                          double.parse(snapShot
                                                              .data
                                                              .currentOverDue)),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    /* fontWeight: FontWeight.bold */
                                                  ))
                                              : InkWell(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            32.0),
                                                    child: Text(
                                                        "ERROR OCCURRED, Tap to retry !"),
                                                  ),
                                                  onTap: () => setState(() {}))
                                          : CircularProgressIndicator();
                                    }) 
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                          ),
                          new Card(
                            child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                  ),
                                  new Expanded(
                                      child: new Text(
                                    "Current Sales Order ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                  ),
                                   new FutureBuilder<JivoOutput>(
                                      future: getCustomerTotalOutstanding(),
                                      builder: (context, snapShot) {
                                        return (snapShot.connectionState ==
                                                ConnectionState.done)
                                            ? snapShot.hasData
                                                ? new Text(
                                                    "\u20B9" +
                                                        formatter.format(double
                                                            .parse(snapShot.data
                                                                .salesOrder)),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      /* fontWeight: FontWeight.bold */
                                                    ))
                                                : InkWell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              32.0),
                                                      child: Text(
                                                          "ERROR OCCURRED, Tap to retry !"),
                                                    ),
                                                    onTap: () =>
                                                        setState(() {}))
                                            : CircularProgressIndicator();
                                      }) 
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                          ),
                          new Card(
                            child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                  ),
                                  new Expanded(
                                      child: new Text(
                                    "Current Limit ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                  ),
                                  new FutureBuilder<JivoOutput>(
                                      future: getCustomerTotalOutstanding(),
                                      builder: (context, snapShot) {
                                        return (snapShot.connectionState ==
                                                ConnectionState.done)
                                            ? snapShot.hasData
                                                ? new Text(
                                                    "\u20B9" +
                                                        formatter.format(double
                                                            .parse(snapShot.data
                                                                .currentLimit)),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  )
                                                : InkWell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              32.0),
                                                      child: Text(
                                                          "ERROR OCCURRED, Tap to retry !"),
                                                    ),
                                                    onTap: () =>
                                                        setState(() {}))
                                            : CircularProgressIndicator();
                                      }), 
                                ]),
                          )
                        ])))
              ])),
        ));
  }

  final String getoutUrl =
      'http://122.160.78.189:85/api/Web/getTotalOutstanding';

  Future<JivoOutput> getCustomerTotalOutstanding() async {
    String getoutUrl2 = getoutUrl;
    final response = await http.get(getoutUrl2);
    final responseJson = json.decode(response.body);
    List<JivoOutput> userList = responseJson
        .map<JivoOutput>((json) => new JivoOutput.fromJson(json))
        .toList();
    jivoOutput = userList[0];
    return userList[0];
  }
}
