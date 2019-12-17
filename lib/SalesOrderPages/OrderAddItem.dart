import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:myproject/Models/SchemeItemList.dart';
import 'package:myproject/SalesOrderModel/OrderItem.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class OrderAddItems extends StatefulWidget {
  final String lineNum;
  OrderAddItems(this.lineNum);
  @override
  _OrderAddItemsState createState() => _OrderAddItemsState(lineNum);
}

class _OrderAddItemsState extends State<OrderAddItems> {
  String lineNum;
  _OrderAddItemsState(this.lineNum);
  int createdBy;

  @override
  void initState() {
    super.initState();
    getSchemItemList();
  }

  final TextEditingController myPieces = new TextEditingController();
  final TextEditingController myBoxes = new TextEditingController();
  final List<String> retailerSchemeSelection = ['1.0', '2.0', '3.0', '4.0'];
  String selectedScheme;
  SchemeItemList selectedSchemeList;
  final myController = TextEditingController();
  AutoCompleteTextField searchTextField1;
  GlobalKey<AutoCompleteTextFieldState<SchemeItemList>> key = new GlobalKey();
  static List<SchemeItemList> _schemeItem = new List<SchemeItemList>();
  bool loading = true;

  void getSchemItemList() async {
    try {
      final response =
          await http.get("http://122.160.78.189:85/api/Sap/GetSchemeItemList");
      if (response.statusCode == 200) {
        _schemeItem = loadUsers(response.body);
        print('SchemeItemList: ${_schemeItem.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting _schemeItem.");
      }
    } catch (e) {
      print("Error getting _schemeItem.");
    }
  }

  List<SchemeItemList> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed
        .map<SchemeItemList>((json) => SchemeItemList.fromJson(json))
        .toList();
  }

  Widget row(SchemeItemList schemeSearch) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            schemeSearch.itemname,
            style: TextStyle(fontSize: 12.0),
          ),
        ),
        Expanded(
          child: Text(
            schemeSearch.itemcode,
          ),
        )
      ],
    );
  }

  bool visibilityPieces = false;
  bool visibilityBoxes = false;

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "pieces") {
        visibilityPieces = visibility;
      }
      if (field == "boxes") {
        visibilityBoxes = visibility;
      }
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _radioValue;
  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'Pieces':
          visibilityBoxes = false;
          visibilityPieces = true;
          break;
        case 'Boxes':
          visibilityBoxes = true;
          visibilityPieces = false;
          break;
      }
    });
  }

  _onClear() {
    setState(() {
      searchTextField1.textField.controller.text = "";
    });
  }

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: Text(
            'Order Items',
            style: TextStyle(fontSize: 18),
          ),
        ),
        resizeToAvoidBottomPadding: false,
        body: Padding(
            padding: const EdgeInsets.all(2),
            child: ListView(padding: EdgeInsets.all(2), children: <Widget>[
              Card(
                child: Form(
                    key: _formKey,
                    autovalidate: _validate,
                    child: SingleChildScrollView(
                        child: Container(
                            child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.all(2),
                                    child: loading
                                        ? CircularProgressIndicator()
                                        : searchTextField1 =
                                            AutoCompleteTextField<
                                                SchemeItemList>(
                                            key: key,
                                            clearOnSubmit: false,
                                            suggestions: _schemeItem,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0),
                                            decoration: InputDecoration(
                                              suffix: IconButton(
                                                icon: Icon(Icons.cancel),
                                                onPressed: _onClear,
                                              ),
                                              labelText: 'Search Sku',
                                              filled: true,
                                              labelStyle: TextStyle(),
                                              border: new OutlineInputBorder(
                                                borderSide: new BorderSide(),
                                              ),
                                            ),
                                            controller: TextEditingController()
                                              ..text,
                                            itemFilter: (item, query) {
                                              return item.itemname
                                                      .toLowerCase()
                                                      .startsWith(query
                                                          .toLowerCase()) ||
                                                  item.itemcode
                                                      .toUpperCase()
                                                      .startsWith(
                                                          query.toLowerCase());
                                            },
                                            itemSorter: (a, b) {
                                              return a.itemname
                                                  .compareTo(b.itemname);
                                            },
                                            itemSubmitted: (item) {
                                              selectedSchemeList = item;
                                              setState(() {
                                                searchTextField1
                                                    .textField
                                                    .controller
                                                    .text = item.itemcode;
                                              });
                                            },
                                            itemBuilder: (context, item) {
                                              return Card(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: row(item)),
                                              );
                                            },
                                          ),
                                  ),
                                ),
                              ]),
                          Divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.all(2),
                                    child: TextFormField(
                                      controller: myController,
                                      autofocus: false,
                                      obscureText: false,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Comment',
                                        filled: true,
                                        labelStyle: TextStyle(),
                                        border: new OutlineInputBorder(
                                          borderSide: new BorderSide(),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                          Divider(),
                          Container(
                            padding: const EdgeInsets.all(4),
                            child: new Column(
                              children: <Widget>[
                                visibilityBoxes
                                    ? new Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          new Expanded(
                                            child: Container(
                                              height: 45,
                                              child: new TextFormField(
                                                controller: myBoxes,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Please enter Quantity';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  suffix: IconButton(
                                                    icon: Icon(Icons.cancel),
                                                    onPressed: _onClear,
                                                  ),
                                                  labelText: 'Boxes',
                                                  //  icon: Icon(Icons.search),
                                                  filled: true,
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Expanded(
                                            child: new IconButton(
                                              color: Colors.red[400],
                                              icon: const Icon(
                                                Icons.cancel,
                                                size: 13.0,
                                              ),
                                              onPressed: () {
                                                _changed(false, "boxes");
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : new Container(),
                                visibilityBoxes
                                    ? new Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          new Expanded(
                                            //  flex: 2,
                                            child: Container(
                                              height: 45,
                                              child: new TextFormField(
                                                controller: myPieces,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Please enter Pieces';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  suffix: IconButton(
                                                    icon: Icon(Icons.cancel),
                                                    onPressed: _onClear,
                                                  ),
                                                  labelText: 'Pieces',
                                                  //  icon: Icon(Icons.search),
                                                  filled: true,
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Expanded(
                                            child: new IconButton(
                                              color: Colors.red[400],
                                              icon: const Icon(
                                                Icons.cancel,
                                                size: 13.0,
                                              ),
                                              onPressed: () {
                                                _changed(false, "boxes");
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : new Container(),
                                visibilityPieces
                                    ? new Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          new Expanded(
                                            child: Container(
                                              height: 45,
                                              child: new TextFormField(
                                                controller: myPieces,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title,
                                                decoration: InputDecoration(
                                                  suffix: IconButton(
                                                    icon: Icon(Icons.cancel),
                                                    onPressed: _onClear,
                                                  ),
                                                  labelText: 'Pieces',
                                                  filled: true,
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Expanded(
                                            child: new IconButton(
                                              color: Colors.red[400],
                                              icon: const Icon(
                                                Icons.cancel,
                                                size: 13.0,
                                              ),
                                              onPressed: () {
                                                _changed(true, "boxes");
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : new Container(),
                              ],
                            ),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    'Order Quantity',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )),
                              new InkWell(
                                onTap: () {},
                                child: new Container(
                                  child: new Column(
                                    children: <Widget>[
                                      Radio(
                                        value: 'Boxes',
                                        groupValue: _radioValue,
                                        onChanged: radioButtonChanges,
                                      ),
                                      Text(
                                        "Boxes",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              new InkWell(
                                  onTap: () {},
                                  child: new Container(
                                    child: new Column(
                                      children: <Widget>[
                                        Radio(
                                          value: 'Pieces',
                                          groupValue: _radioValue,
                                          onChanged: radioButtonChanges,
                                        ),
                                        Text("Pieces",
                                            style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      'Ret.Scheme(Per Box)',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField<String>(
                                        items: retailerSchemeSelection
                                            .map((String dropDownStringItem) {
                                          return DropdownMenuItem<String>(
                                            value: dropDownStringItem,
                                            child: Text(dropDownStringItem),
                                          );
                                        }).toList(),
                                        onChanged: (String newValueSelected) {
                                          setState(() {
                                            this.selectedScheme =
                                                newValueSelected;
                                          });
                                        },
                                        validator: (String value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please choose Retail Quantity';
                                          }
                                          return null;
                                        },
                                        value: selectedScheme,
                                        hint: Text(
                                          'Select ',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                          Divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      createdBy =
                                          int.parse(prefs.getString("id"));
                                      if (_formKey.currentState.validate()) {
                                        var currentDate = new DateTime.now();
                                        OrderItem item = new OrderItem();

                                        item.itemCode = searchTextField1
                                            .textField.controller.text;

                                        item.docEntry = "0";
                                        item.id = "0";
                                        item.canceled = "";
                                        item.lineNum = lineNum;
                                        item.status = "s";
                                        item.canceledDate =
                                            "1979-09-01 00:00:00";
                                        item.itmRemarks = myController.text;
                                        item.createdOn = DateFormat.yMd()
                                            .format(currentDate);

                                        item.uOM = "";
                                        item.updateDate = DateFormat.yMd()
                                            .format(currentDate);

                                        item.retSchemeQty =
                                            selectedScheme.toString();
                                        item.itemName =
                                            selectedSchemeList.itemname;
                                        item.createdBy = createdBy.toString();
                                        item.quantity = myPieces.text;
                                        item.boxQty = visibilityPieces == true
                                            ? "0"
                                            : myBoxes.text;
                                        Navigator.pop(context, item);
                                      }
                                    },
                                    textColor: Colors.white,
                                    color: Colors.indigo[900],
                                    child: Text(
                                      "SAVE",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                          Divider(),
                        ])))),
              )
            ])));
  }
}
