import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myproject/SalesOrderModel/PrimaryOrder.dart';
import 'package:myproject/UpdateSaleItems/Details.dart';
import 'SalesOrder.dart';

class SalesDashboard extends StatefulWidget {
  @override
  _SalesDashboardState createState() => _SalesDashboardState();
}

class _SalesDashboardState extends State<SalesDashboard> {
  List<PrimaryOrder> _searchResult = [];
  List<PrimaryOrder> _primaryOrder = [];
  Widget appBarTitle =
      new Text("Search Party", style: TextStyle(color: Colors.purple));
  Icon actionIcon = new Icon(Icons.search);
  TextEditingController controller = new TextEditingController();

  bool loading = true;
  final formatter = new DateFormat("yyyy-MM-dd");

  final String primaryOrdersurl =
      'http://122.160.78.189:85/api/Sap/getPrimaryOrders';

  Future<Null> getPrimaryOrder() async {
    setState(() => loading = true);
    final response = await http.get(primaryOrdersurl);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map party in responseJson) {
        _primaryOrder.add(PrimaryOrder.fromJson(party));
        loading = false;
         }
    });
  }

  @override
  void initState() {
    super.initState();

    getPrimaryOrder();
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
      ),
      body: Card(
        child: new Column(
          children: <Widget>[
            loading
                ? Center(child: CircularProgressIndicator())
                : new Container(
                    color: Theme.of(context).buttonColor,
                    child: new Padding(
                      padding: const EdgeInsets.all(2.0),
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
              child: Container(
                child: _searchResult.length != 0 || controller.text.isNotEmpty
                        ? new ListView.builder(
                            itemCount: _searchResult.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Details(_searchResult[i])));
                                  },
                                  child: new Card(
                                    child: new ListTile(
                                      title: new Text(
                                        _searchResult[i].docEntry +
                                            '      ' +
                                            _searchResult[i].cardCode,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    margin: const EdgeInsets.all(0.0),
                                  ));
                            },
                          )
                        : new ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _primaryOrder.length,
                            itemBuilder: (BuildContext context, int index) {
                              
                              return new GestureDetector(
                                  onTap: () {
                                   
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Details(_primaryOrder[index])));
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: new Card(
                                            shape: BeveledRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Row(
                                                      children: <Widget>[
                                                        Text(
                                                          _primaryOrder[index]
                                                              .cardName,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                    ),
                                                    new Row(children: <Widget>[
                                                      Text(
                                                        'DocEntry : ${_primaryOrder[index].docEntry}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ]),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                    ),
                                                    new Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Order Date : ${formatter.format(DateTime.parse(_primaryOrder[index].docDate))}',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                    ),
                                                    new Row(children: <Widget>[
                                                      Text(
                                                        'Delivery Date: ${formatter.format(DateTime.parse(_primaryOrder[index].delDate))}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ]),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                    ),
                                                    new Row(children: <Widget>[
                                                      Text(
                                                        'Time : ${_primaryOrder[index].prefTime}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ]),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                    ),
                                                    new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            'Payment Term :${_primaryOrder[index].paymentTerms}',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          new Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Text(
                                                                'Status :${_primaryOrder[index].status}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ])
                                                  ]),
                                            )),
                                      ),
                                    ),
                                  ));
                            }),
              ),
            ),
            Divider(
              color: Colors.black87,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SalesOrderPage()),
          );
        },
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _primaryOrder.forEach((_primaryOrder) {
      if (_primaryOrder.docEntry.toLowerCase().contains(text) ||
          _primaryOrder.cardCode.toLowerCase().contains(text) ||
          _primaryOrder.cardName.toLowerCase().contains(text))
        _searchResult.add(_primaryOrder);
    });

    setState(() {});
  }
}
