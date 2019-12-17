import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myproject/SapModel/SearchSapRights.dart';

import 'SapBackRight.dart';

class SapDashboard extends StatefulWidget {
  @override
  _SapDashboardState createState() => _SapDashboardState();
}

class _SapDashboardState extends State<SapDashboard> {
  //  List<SearchSapRights> searchsapright = new List<SearchSapRights>();
  bool loading;
  List<SearchSapRights> _searchsaprights = [];
  final formatter = new DateFormat("yyyy-MM-dd");
  final formatter1 = new DateFormat("yyyy-MM-dd To HH:mm:ss");

  final userinputTextController = TextEditingController();
  @override
  void initState() {
    super.initState();

    searchsaprights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: Text(
            'Create SAP Rights',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        body: new SafeArea(
          child: new Column(
            //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: new FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SapBackRight()),
                            );
                          },
                          child: Text('CLICK TO ADD NEW',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          color: Colors.indigo[900],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Text(
                    'CURRENT ACTIVE RIGHTS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: new Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: _searchsaprights.isEmpty
                      ? Column(
                          children: <Widget>[
                            Text('No Active Rights added yet !',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        )
                      : loading
                          ? Center(child: CircularProgressIndicator())
                          : new ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _searchsaprights.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    child: new Card(
                                        child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      child: new Text(
                                        "User Id: " +
                                            _searchsaprights[index].userid,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                    
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      child: new Text(
                                          "Transaction Type  : " +
                                              _searchsaprights[index]
                                                  .transTypeStr,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.left),
                                    ),
                                   
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      child: new Text(
                                          "From Date: " +
                                              formatter.format(DateTime.parse(
                                                  _searchsaprights[index]
                                                      .fromDate)),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.left),
                                    ),
                                  
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      child: new Text(
                                        "To Date: " +
                                            formatter.format(DateTime.parse(
                                                _searchsaprights[index]
                                                    .toDate)),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                  
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      child: new Text(
                                        "Time Limit: " +
                                            formatter1.format(DateTime.parse(
                                                _searchsaprights[index]
                                                    .timeLimit)),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                   
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      child: new Text(
                                        "Rights: " +
                                            _searchsaprights[index].rights,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                     Divider(),
                                  ],
                                )),);
                              }),
                ),
              ),
            ],
          ),
        ));
  }

  final String searchSapRightsUrl =
      'http://122.160.78.189:85/api/Sap/searchSapRights';

  Future<Null> searchsaprights() async {
    setState(() => loading = true);
    final response = await http.get(searchSapRightsUrl);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map party in responseJson) {
        _searchsaprights.add(SearchSapRights.fromJson(party));
        loading = false;
      }
    });
  }
}
