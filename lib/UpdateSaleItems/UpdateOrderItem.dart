import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:myproject/Models/SchemeItemList.dart';
import 'package:myproject/SalesOrderModel/CreateOrderRequest.dart';
import 'package:myproject/SalesOrderModel/OrderItem.dart';



class UpdateOrderItem extends StatefulWidget {
  final OrderItem itemLIst;
  UpdateOrderItem(this.itemLIst);
  @override
  _UpdateOrderItemState createState() => _UpdateOrderItemState(itemLIst);
}

class _UpdateOrderItemState extends State<UpdateOrderItem> {
  _UpdateOrderItemState(this.itemLIst);
  int createdBy;

  @override
  void initState() {
    //itemLIst.retSchemeQty=selectedScheme;
    setState(() {
      radioValue = itemLIst.boxQty;
      radioValue = itemLIst.quantity;
    });
    TextEditingController()..text = itemLIst.itemCode;
    myController..text = itemLIst.itmRemarks;
    selectedScheme = itemLIst.retSchemeQty;
    myPieces..text = itemLIst.quantity;
    myBoxes..text = itemLIst.boxQty;

    super.initState();
    getSchemItemList();
  }

  TextEditingController itemsTextController = TextEditingController();
  TextEditingController myPieces = new TextEditingController();
  TextEditingController myBoxes = new TextEditingController();

  final List<String> retailerSchemeSelection = ["1.0", "2.0", "3.0", "4.0"];
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

  static List<SchemeItemList> loadUsers(String jsonString) {
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

  String radioValue;
  void radioButtonChanges(String value) {
    setState(() {
      radioValue = value;

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

  CreateOrderRequest createOrderRequest;
  final String primaryUpdateurl =
      'http://122.160.78.189:85/api/Sap/updatePrimaryOrder';

  Future<http.Response> updateOrder(Map<String, dynamic> postJsonData) async {
    // showToast("inside createSapRightsfunc");
    var body = json.encode(postJsonData);
    var response = await http.post(primaryUpdateurl,
        headers: {"Content-Type": "application/json"}, body: body);

    return response;
  }

  OrderItem itemLIst;
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
                            // padding: const EdgeInsets.all(1),
                            child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                          //  Padding(padding: const EdgeInsets.all(2))
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
                                              //  icon: Icon(Icons.search),
                                              filled: true,
                                              labelStyle: TextStyle(),
                                              border: new OutlineInputBorder(
                                                // borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            ),
                                            controller: TextEditingController()
                                              ..text = itemLIst.itemCode,
                                            textSubmitted: (text) {
                                              itemLIst.itemCode = text;
                                            },
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
                                    child: TextField(
                                      controller: myController,
                                      onChanged: (text) {
                                        itemLIst.itmRemarks = text;
                                      },
                                      autofocus: false,
                                      obscureText: false,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Comment',
                                        //  icon: Icon(Icons.search),
                                        filled: true,
                                        labelStyle: TextStyle(),
                                        border: new OutlineInputBorder(
                                          // borderRadius: new BorderRadius.circular(25.0),
                                          borderSide: new BorderSide(),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ]),

//Padding(padding: const EdgeInsets.all(4),),
                          Divider(),
                          Container(
                            // height: 45,
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
                                              child: new TextField(
                                                controller: myBoxes,
                                                onChanged: (text) {
                                                  itemLIst.boxQty = text;
                                                },
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title,
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
                                                    // borderRadius: new BorderRadius.circular(25.0),
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
                                              child: new TextField(
                                                controller: myPieces,
                                                onChanged: (text) {
                                                  itemLIst.quantity = text;
                                                },
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
                                                  //  icon: Icon(Icons.search),
                                                  filled: true,
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                  border:
                                                      new OutlineInputBorder(
                                                    // borderRadius: new BorderRadius.circular(25.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Expanded(
                                            //flex: 0,
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
                                              child: new TextField(
                                                controller: myPieces,
                                                onChanged: (text) {
                                                  itemLIst.quantity = text;
                                                },
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
                                                  //  icon: Icon(Icons.search),
                                                  filled: true,
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                  border:
                                                      new OutlineInputBorder(
                                                    // borderRadius: new BorderRadius.circular(25.0),
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
                                                _changed(
                                                  true,
                                                  "boxes",
                                                );
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
                                        groupValue: radioValue,
                                        onChanged: radioButtonChanges,
                                      ),

                                      Text(
                                        "Boxes",
                                        style: TextStyle(fontSize: 12),
                                      ),

                                      //     ),new SizedBox(width: 24.0),
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
                                          groupValue: radioValue,
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
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      'Rtl Scme(per box)',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(
                                      items: retailerSchemeSelection
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(
                                            dropDownStringItem,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String newValueSelected) {
                                        selectedScheme = newValueSelected;
                                        setState(() {
                                          itemLIst.retSchemeQty =
                                              newValueSelected;
                                        });
                                      },
                                      value: selectedScheme =
                                          itemLIst.retSchemeQty,
                                      hint: Text(
                                        'Select ',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                          Divider(),
                          Row(children: <Widget>[
                            new RaisedButton(
                                child: Text('SUBMIT'),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ]),
                          Divider(),
                        ])))),
              )
            ])));
  }
}
