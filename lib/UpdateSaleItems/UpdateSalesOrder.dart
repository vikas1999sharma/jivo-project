import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myproject/Models/Partymodel.dart';
import 'package:myproject/SalesOrderModel/CreateOrderRequest.dart';
import 'package:myproject/SalesOrderModel/OrderItem.dart';
import 'package:myproject/SalesOrderPages/SalesDashboard.dart';

import 'UpdateOrderItem.dart';

const double _kPickerSheetHeight = 216.0;

class UpdateSalesOrder extends StatefulWidget {
  final CreateOrderRequest createOrderRequest;

  UpdateSalesOrder(this.createOrderRequest);

  @override
  _UpdateSalesOrderState createState() =>
      _UpdateSalesOrderState(createOrderRequest);
}

class _UpdateSalesOrderState extends State<UpdateSalesOrder> {
  _UpdateSalesOrderState(this.createOrderRequest);
  final formatter = new DateFormat("yyyy-MM-dd");
  _onClear() {
    setState(() {
      searchTextField.textField.controller.text = "";
    });
  }

  // final _text = TextEditingController();
  final List<String> timeSelection = [
    "Early Morning",
    "Before Morning",
    "After Lunch",
    "Evening",
    "Late Night"
  ];
  final List<String> paymentMode = [
    "Advance Payment",
    "On Delivery",
    "On Credit",
    "Cash",
  ];

  void deleteOrder(index) {
    createOrderRequest.items.removeAt(index);
  }

  var cardcode = "";
  String selectedtime;
  String selectedpayment;
  PartyModel selectedPartyItem;

  var createdBy;
  CreateOrderRequest createOrderRequest;
  TextEditingController remarksTextController = TextEditingController();
  TextEditingController partyTextController = TextEditingController();

  AutoCompleteTextField searchTextField;
  Widget buildDelete(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmation'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text('Are you sure you want to delete this?')],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('yes'),
          onPressed: () {},
        ),
        new FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  GlobalKey<AutoCompleteTextFieldState<PartyModel>> key = new GlobalKey();
  final GlobalKey<FormState> getValue = GlobalKey<FormState>();
  static List<PartyModel> _party = new List<PartyModel>();
  bool loading = true;

  void getParties() async {
    try {
      final response =
          await http.get("http://122.160.78.189:85/api/Web/getParties");
      if (response.statusCode == 200) {
        _party = loadUsers(response.body);
        print('PartyModel: ${_party.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  static List<PartyModel> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<PartyModel>((json) => PartyModel.fromJson(json)).toList();
  }

  // List<OrderItem> orderItem = [];
  List<OrderItem> itemData = [];
  @override
  void initState() {
    getParties();
    remarksTextController..text = createOrderRequest.remarks;
    partyTextController..text = createOrderRequest.cardCode;
    createOrderRequest.canceled = "c";
    createOrderRequest.canceledDate = "";
    createOrderRequest.createdOn = "";

    selectedtime = createOrderRequest.prefTime;
    selectedpayment = createOrderRequest.paymentTerms;

    super.initState();
  }

  Widget row(PartyModel partyModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          partyModel.cardName,
          style: TextStyle(fontSize: 10.0),
        ),
        Text(
          partyModel.cardCode,
        ),
      ],
    );
  }

  DateTime todate = DateTime.now();
  DateTime date = DateTime.now();

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      // color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.red,
          fontSize: 15.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  bool _isVisible = true;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  Widget _buildFromDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
              CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.parse(createOrderRequest.docDate),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() =>
                      createOrderRequest.docDate = newDateTime.toString());
                },
              ),
            );
          },
        );
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Text(
                  'Order Date',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Text(
                  formatter.format(DateTime.parse(createOrderRequest.docDate)),
                  style: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.double,
                      color: Colors.black),
                ),
              ),
            )
          ]),
    );
  }

  Widget _buildtoDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
              CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.parse(createOrderRequest.delDate),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() =>
                      createOrderRequest.delDate = newDateTime.toString());
                },
              ),
            );
          },
        );
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Text(
                  'Del Date',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Text(
                  //DateFormat.yMd().format(todate),
                  formatter.format(DateTime.parse(createOrderRequest.delDate)),
                  //       createOrderRequest.delDate
                  style: const TextStyle(
                      fontSize: 12.0,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.double,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            )
          ]),
    );
  }

  // List<OrderItem> item = [];
  final String deleteItemUrl =
      "http://122.160.78.189:85/api/Sap/deletePrimaryOrderItem";
  final String primaryUpdateurl =
      'http://122.160.78.189:85/api/Sap/updatePrimaryOrder';

  Future<http.Response> createPrimaryUpdateOrder(
      Map<String, dynamic> postJsonData) async {
    // showToast("inside createSapRightsfunc");
    var body = json.encode(postJsonData);
    var response = await http.post(primaryUpdateurl,
        headers: {"Content-Type": "application/json"}, body: body);

    return response;
  }

  Future<void> _ackAlert(BuildContext context, int index) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ITEMS'),
          content: const Text('Do you want to cancel the Items'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                var item = createOrderRequest.items[index];
                deletePrimaryOrderItem(index, item);
              },
            ),
          ],
        );
      },
    );
  }

  BuildContext buildContext;
  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: Text(
            'Update Details',
            style: TextStyle(fontSize: 22),
          ),
        ),
        //backgroundColor: Colors.white54,
        resizeToAvoidBottomPadding: false,
        body: Padding(
            padding: const EdgeInsets.all(0),
            child: ListView(padding: EdgeInsets.all(1), children: <Widget>[
              Card(
                  child: Form(
                      //   key: _formKey,
                      //  autovalidate: _validate,
                      child: SingleChildScrollView(
                child: Container(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 50,
                          padding: const EdgeInsets.all(4),
                          child: loading
                              ? CircularProgressIndicator()
                              : searchTextField =
                                  AutoCompleteTextField<PartyModel>(
                                  key: key,
                                  clearOnSubmit: false,
                                  suggestions: _party,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                  decoration: InputDecoration(
                                    hintText: "Enter Party",
                                    hintStyle: TextStyle(fontSize: 15),
                                    suffix: IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: _onClear,
                                    ),
                                    border: new OutlineInputBorder(
                                      // borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  itemFilter: (item, query) {
                                    return item.cardName
                                            .toLowerCase()
                                            .startsWith(query.toLowerCase()) ||
                                        item.cardCode
                                            .toLowerCase()
                                            .startsWith(query.toLowerCase());
                                  },
                                  itemSorter: (a, b) {
                                    return a.cardName.compareTo(b.cardName);
                                  },

                                  controller: TextEditingController()
                                    ..text = createOrderRequest.cardCode,

                                  // controller:partyTextController ,
                                  itemSubmitted: (item) {
                                    selectedPartyItem = item;

                                    setState(
                                      () {
                                        searchTextField.textField.controller
                                            .text = item.cardCode;
                                      },
                                    );
                                  },
                                  itemBuilder: (context, item) {
                                    // ui for the autocompelete row
                                    return Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: row(item)),
                                    );
                                  },
                                ),
                        ),
                        Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                Flexible(
                                    child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: _buildFromDatePicker(context),
                                )),
                                Padding(padding: const EdgeInsets.all(2)),
                                Flexible(
                                    child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: _buildtoDatePicker(context),
                                )),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.all(4),
                                  child: TextField(
                                    controller: remarksTextController,
                                    onChanged: (text) {
                                      createOrderRequest.remarks = text;
                                    },
                                    autofocus: false,
                                    obscureText: false,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    /*   validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter some text';
                                                    }
                                                    return null;
                                                  }, */
                                    decoration: InputDecoration(
                                      labelText: "Comments",
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    'Payment Term',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              //Padding(padding: const EdgeInsets.all(20),),
                              Flexible(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                    items: paymentMode
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
                                      setState(() {
                                        createOrderRequest.paymentTerms =
                                            newValueSelected;
                                      });
                                    },
                                    validator: (String value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please Choose Payments Mode';
                                      }
                                      return null;
                                    },
                                    value: selectedpayment =
                                        createOrderRequest.paymentTerms,
                                    hint: Text(
                                      'Select',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    'Choose Time',
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
                                    items: timeSelection
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
                                      setState(() {
                                        createOrderRequest.prefTime =
                                            newValueSelected;
                                      });
                                    },
                                    validator: (String value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please Choose Time';
                                      }
                                      return null;
                                    },
                                    value: selectedtime =
                                        createOrderRequest.prefTime,
                                    hint: Text(
                                      'Select ',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        Divider(),
                        Row(children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4),
                            child: new RaisedButton(
                                child: Text(
                                  'SUBMIT,',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue[900],
                                onPressed: () async {
                                  Map<String, dynamic> createOrderRequestMap =
                                      createOrderRequest.toJson();
                                  createPrimaryUpdateOrder(
                                          createOrderRequestMap)
                                      .then((response) {
                                    if (response.body.contains("Done")) {
                                      loading = false;
                                      Fluttertoast.showToast(
                                        msg: "Update Data Successfully",
                                        textColor: Colors.white,
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIos: 3,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.indigo,
                                      );
                                      debugPrint(response.body);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SalesDashboard()),
                                      );
                                    }
                                  });
                                }),
                          )
                        ]),
                        Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  
                                  padding: const EdgeInsets.all(0),
                                  child: createOrderRequest == null
                                      ? new Container()
                                      : ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount:
                                              createOrderRequest.items.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var itemList =
                                                createOrderRequest.items[index];
                                            return Card(
                                                margin: EdgeInsets.all(0),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(1),
                                                    child: new Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                          ),
                                                          new Row(
                                                            children: <Widget>[
                                                              Text(
                                                                itemList
                                                                    .itemName,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                          Divider(
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          new Row(
                                                            children: <Widget>[
                                                              Text(
                                                                createOrderRequest.items[index].itemCode +
                                                                    "       " +
                                                                    "(LineNum ):" +
                                                                    createOrderRequest
                                                                        .items[
                                                                            index]
                                                                        .lineNum +
                                                                    "        " +
                                                                    "(Status ):" +
                                                                    createOrderRequest
                                                                        .items[
                                                                            index]
                                                                        .status,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                          Divider(
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          IntrinsicHeight(
                                                            child: new Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  itemList.boxQty
                                                                          .toString() +
                                                                      ' boxes ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                VerticalDivider(
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                                Text(
                                                                  itemList.quantity
                                                                          .toString() +
                                                                      ' Quantity ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                VerticalDivider(
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                                Text(
                                                                  itemList.retSchemeQty
                                                                          .toString() +
                                                                      ' Retailer Scheme',
                                                                  // textDirection:TextDirection.ltr,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                              child: new Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              IconButton(
                                                                icon: Icon(
                                                                    Icons.edit),
                                                                onPressed: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                UpdateOrderItem(itemList)),
                                                                  );
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .delete),
                                                                onPressed: () {
                                                                  _ackAlert(
                                                                      context,
                                                                      index);
                                                                },
                                                              ),
                                                            ],
                                                          )),
                                                        ])));
                                          }),
                                ),
                              ),
                            ]),
                      ]),
                ),
              )))
            ])));
  }

  final String deletePrimaryOrderUrl =
      "http://122.160.78.189:85/api/Sap/deletePrimaryOrderItem";

  Future deletePrimaryOrderItem(int index, OrderItem item) async {
    String deleteUrl = deletePrimaryOrderUrl +
        '?DocEntry=' +
        item.docEntry +
        '&LineNum=' +
        item.lineNum;
    Map<String, dynamic> body = Map();
    body.putIfAbsent("DocEntry", () => item.docEntry);
    body.putIfAbsent("LineNum", () => item.lineNum);

    String requestBody = json.encode(body);

    final response = await http.post(deleteUrl,
        headers: {"Content-Type": "application/json"}, body: requestBody);
    if (response.body.contains("Done")) {
      createOrderRequest.items.remove(index);
      Fluttertoast.showToast(
        msg: "Delete Item Successfully",
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 3,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.indigo,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SalesDashboard()),
      );
    }
    
    else{print("Loading........");
      CircularProgressIndicator();
    }
  }
}
