import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Models/Partymodel.dart';
import 'package:myproject/SalesOrderModel/CreateOrderRequest.dart';
import 'package:myproject/SalesOrderModel/OrderItem.dart';
import 'package:myproject/UpdateSaleItems/UpdateOrderItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'OrderAddItem.dart';

const double _kPickerSheetHeight = 216.0;

class SalesOrderPage extends StatefulWidget {
  @override
  _SalesOrderPageState createState() => _SalesOrderPageState();
}

class _SalesOrderPageState extends State<SalesOrderPage> {
  _onClear() {
    setState(() {
      searchTextField.textField.controller.text = "";
    });
  }

  deleteOrder(index) {
    createOrderRequest.items.removeAt(index);
  }

  bool _validate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime date2;
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
  var cardcode = "";
  String selectedtime;
  String selectedpayment;
  PartyModel selectedPartyItem;

  var createdBy;
  CreateOrderRequest createOrderRequest;

  TextEditingController remarksTextController = TextEditingController();

  AutoCompleteTextField searchTextField;

  GlobalKey<AutoCompleteTextFieldState<PartyModel>> key = new GlobalKey();
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

  List<OrderItem> itemData = [];
  @override
  void initState() {
    getParties();
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

  Widget _buildFromDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
              CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: date,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() => date = newDateTime);
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
                // padding: const EdgeInsets.all(2),
                child: Card(
                  color: Colors.white70,
                  child: Text(
                    DateFormat.yMd().format(date),
                    style: const TextStyle(
                        fontSize: 12.0,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.double,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
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
                initialDateTime: todate,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() => todate = newDateTime);
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
                padding: const EdgeInsets.all(2),
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
                //padding: const EdgeInsets.all(2),
                child: Card(
                  color: Colors.white70,
                  child: Text(
                    DateFormat.yMd().format(todate),
                    style: const TextStyle(
                        fontSize: 12.0,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.double,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            )
          ]),
    );
  }

  List<OrderItem> item = [];

  BuildContext buildContext;
  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              ),
              title: Text(
                'Sales Order',
                style: TextStyle(fontSize: 22),
              ),
            ),
            resizeToAvoidBottomPadding: false,
            body: ListView(children: <Widget>[
              Card(
                child: Form(
                    key: _formKey,
                    autovalidate: _validate,
                    child: SingleChildScrollView(
                      child: Container(
                        //   padding: const EdgeInsets.all(0),
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
                                                .startsWith(
                                                    query.toLowerCase()) ||
                                            item.cardCode
                                                .toLowerCase()
                                                .startsWith(
                                                    query.toLowerCase());
                                      },
                                      itemSorter: (a, b) {
                                        return a.cardName.compareTo(b.cardName);
                                      },
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
                                              padding:
                                                  const EdgeInsets.all(4.0),
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
                                      child: TextFormField(
                                        controller: remarksTextController,
                                        autofocus: false,
                                        obscureText: false,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            this.selectedpayment =
                                                newValueSelected;
                                          });
                                        },
                                        validator: (String value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please Choose Payments Mode';
                                          }
                                          return null;
                                        },
                                        value: selectedpayment,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            this.selectedtime =
                                                newValueSelected;
                                          });
                                        },
                                        validator: (String value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please Choose Time';
                                          }
                                          return null;
                                        },
                                        value: selectedtime,
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
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  FlatButton.icon(
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    //color: Colors.indigo[900],
                                    label: Text(
                                      'Add Items',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      createdBy =
                                          int.parse(prefs.getString("id"));
                                      if (_formKey.currentState.validate()) {
                                        if (createOrderRequest == null) {
                                          createOrderRequest =
                                              new CreateOrderRequest();
                                        }

                                        var currentDate = new DateTime.now();
                                        createOrderRequest.cardName =
                                            selectedPartyItem.cardName;

                                        createOrderRequest.cardCode =
                                            searchTextField
                                                .textField.controller.text;
                                        createOrderRequest.remarks =
                                            remarksTextController.text;
                                        createOrderRequest.createdOn =
                                            DateFormat.yMd()
                                                .format(currentDate);
                                        createOrderRequest.updateDate =
                                            DateFormat.yMd()
                                                .format(currentDate);
                                        createOrderRequest.docNum = 0;
                                        createOrderRequest.canceled = "";
                                        createOrderRequest.status = "s";
                                        createOrderRequest.canceledDate =
                                            "1979-09-01 00:00:00";
                                        createOrderRequest.docEntry = 0;
                                        createOrderRequest.createdBy =
                                            createdBy;
                                        createOrderRequest.docDate =
                                            date.toString();
                                        createOrderRequest.delDate =
                                            todate.toString();
                                        createOrderRequest.prefTime =
                                            selectedtime;
                                        createOrderRequest.paymentTerms =
                                            selectedpayment;

                                        String lineNum = getLineNum(
                                            createOrderRequest.items);

                                        final itemData = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderAddItems(lineNum)),
                                        ) as OrderItem;
                                        if (createOrderRequest.items == null) {
                                          createOrderRequest.items =
                                              new List<OrderItem>();
                                        }

                                        if (itemData != null)
                                          createOrderRequest.items
                                              .add(itemData);
                                      }
                                    },
                                  ),
                                ]),
                            Divider(),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    height: 35,
                                    child: RaisedButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          Map<String, dynamic>
                                              createOrderRequestMap =
                                              createOrderRequest.toJson();
                                          createPrimaryOrder(
                                                  createOrderRequestMap)
                                              .then((response) {
                                            if (response.body
                                                .contains("DONE")) {
                                              loading = false;
                                              Fluttertoast.showToast(
                                                msg: "Data Stored Successfully",
                                                textColor: Colors.white,
                                                toastLength: Toast.LENGTH_SHORT,
                                                timeInSecForIos: 3,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.indigo,
                                              );
                                              debugPrint(response.body);
                                              Navigator.pop(context);
                                            }
                                          });
                                        }
                                      },
                                      textColor: Colors.white,
                                      color: Colors.indigo[900],
                                      child: Text(
                                        "SUBMIT",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ]),
                            Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        child: createOrderRequest == null
                                            ? new Container()
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: createOrderRequest
                                                    .items.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  var itemList =
                                                      createOrderRequest
                                                          .items[index];
                                                  return new Card(
                                                      margin: EdgeInsets.all(1),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          child: new Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(1),
                                                                ),
                                                                new Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      itemList
                                                                          .itemName,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )
                                                                  ],
                                                                ),
                                                                Divider(
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                                new Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      itemList.itemCode +
                                                                          "            " +
                                                                          "LineNum :" +
                                                                          itemList
                                                                              .lineNum,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )
                                                                  ],
                                                                ),
                                                                Divider(
                                                                  color: Colors
                                                                      .black87,
                                                                ),

                                                                // Padding(padding: const EdgeInsets.all(2),),
                                                                IntrinsicHeight(
                                                                  child:
                                                                      new Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        itemList.boxQty.toString() +
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
                                                                        itemList.quantity.toString() +
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
                                                                        itemList.retSchemeQty.toString() +
                                                                            ' Retailer Scheme',
                                                                        // textDirection:TextDirection.ltr,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                new Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: <
                                                                      Widget>[
                                                                    new IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .edit),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => UpdateOrderItem(itemList)),
                                                                        );
                                                                      },
                                                                    ),
                                                                    new IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .delete),
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          createOrderRequest
                                                                              .items
                                                                              .removeAt(index);
                                                                        });
                                                                      },
                                                                    )
                                                                  ],
                                                                )
                                                              ])));
                                                }),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    )),
              )
            ])));
  }
}
