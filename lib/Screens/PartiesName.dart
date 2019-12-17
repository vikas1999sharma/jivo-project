import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myproject/Models/PartyDetailmodel.dart';
import 'package:myproject/Models/Partymodel.dart';

class PartiesName extends StatefulWidget {
  @override
  _PartiesNameState createState() => new _PartiesNameState();
}

class _PartiesNameState extends State<PartiesName> {
  Widget appBarTitle = new Text("Search Party");
  Icon actionIcon = new Icon(Icons.search);
  TextEditingController controller = new TextEditingController();

  bool loading = true;

  // Get json result and convert it to model. Then add
  Future<Null> getParties() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(getparties);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map party in responseJson) {
        _party.add(PartyModel.fromJson(party));
        loading = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getParties();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: new Text('Search Party Name'),
        elevation: 0.0,
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),
            ),
          ),
          new Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : _searchResult.length != 0 || controller.text.isNotEmpty
                    ? new ListView.builder(
                        itemCount: _searchResult.length,
                        itemBuilder: (context, i) {
                          return new Card(
                            child: new ListTile(
                              title: new Text(
                                _searchResult[i].cardCode +
                                    '      ' +
                                    _searchResult[i].cardName,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Partydetails(
                                          _searchResult[i].cardCode,
                                        )));
                              },
                            ),
                            margin: const EdgeInsets.all(0.0),
                          );
                        },
                      )
                    : loading
                        ? Center(child: CircularProgressIndicator())
                        : new ListView.builder(
                            itemCount: _party.length,
                            itemBuilder: (context, index) {
                              return new Card(
                                child: new ListTile(
                                  title: new Text(
                                    _party[index].cardCode +
                                        '      ' +
                                        _party[index].cardName,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Partydetails(
                                                  _party[index].cardCode,
                                                ))); /* ffffd */
                                  },
                                ),
                                margin: const EdgeInsets.all(0.0),
                              );
                            },
                          ),
          ), /* Center(child: CircularProgressIndicator()) */
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _party.forEach((_party) {
      if (_party.cardCode.toLowerCase().contains(text) ||
          _party.cardName.toLowerCase().contains(text))
        _searchResult.add(_party);
    });

    setState(() {});
  }

  List<PartyModel> _searchResult = [];
  List<PartyModel> _party = [];
  final String getparties = "http://122.160.78.189:85/api/Web/getParties";
}

PartyDetailmodel partyDetailmodel;
String mCardCode;

class Partydetails extends StatefulWidget {
  Partydetails(data, {List<Widget> children}) {
    mCardCode = data;
  }

  @override
  _PartydetailsState createState() => _PartydetailsState();
}

class _PartydetailsState extends State<Partydetails> {
  BuildContext buildContext;
  bool loading = false;
  final String getoutUrl =
      'http://122.160.78.189:85/api/Web/getCustomerOutstanding';

  final formatter = new NumberFormat("#,###.##");
  int theValue = 1234;

  @override
  void initState() {
    super.initState();
    getCustomerOutstanding(mCardCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: Text('Details of Party'),
          backgroundColor: Colors.indigo[900],
        ),
        body: Container(
            color: Colors.white,
            child: ListView(children: <Widget>[
              Container(
                  margin: EdgeInsets.all(8),
                  color: Colors.white,
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 300,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                    Padding(padding: const EdgeInsets.all(20)),
                    Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                    ),
                                    new Expanded(
                                        child: new Text(
                                      "Customer Outstanding",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    new FutureBuilder<PartyDetailmodel>(
                                        future:
                                            getCustomerOutstanding(mCardCode),
                                        builder: (context, snapShot) {
                                          if (!snapShot.hasData)
                                            return Container();
                                          return new Text(
                                            "\u20B9" +
                                                formatter.format(double.parse(
                                                    snapShot.data
                                                        .currentOutstanding)),
                                            style: TextStyle(fontSize: 16),
                                          );
                                        })
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                ),
                                new Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                    ),
                                    new Expanded(
                                        child: new Text(
                                      "Customer OverDue",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    new FutureBuilder<PartyDetailmodel>(
                                        future:
                                            getCustomerOutstanding(mCardCode),
                                        builder: (context, snapShot) {
                                          if (!snapShot.hasData)
                                            return Container();
                                          return new Text(
                                            "\u20B9" +
                                                formatter.format(double.parse(
                                                    snapShot
                                                        .data.currentOverDue)),
                                            style: TextStyle(fontSize: 16),
                                          );
                                        })
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                ),
                                new Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                    ),
                                    new Expanded(
                                        child: new Text(
                                      "Current Sales Order",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    new FutureBuilder<PartyDetailmodel>(
                                        future:
                                            getCustomerOutstanding(mCardCode),
                                        builder: (context, snapShot) {
                                          if (!snapShot.hasData)
                                            return Container();
                                          return new Text(
                                            "\u20B9" +
                                                formatter.format(double.parse(
                                                    snapShot.data.salesOrder)),
                                            style: TextStyle(fontSize: 16),
                                          );
                                        })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                  ]))
            ])));
  }

  Future<PartyDetailmodel> getCustomerOutstanding(String cardCode) async {
    String getoutUrl2 = getoutUrl + '?CardCode=' + cardCode;
    final response = await http.get(getoutUrl2);
    final responseJson = json.decode(response.body);
    List<PartyDetailmodel> userList = responseJson
        .map<PartyDetailmodel>((json) => new PartyDetailmodel.fromJson(json))
        .toList();

    partyDetailmodel = userList[0];

    return userList[0];
  }
}
