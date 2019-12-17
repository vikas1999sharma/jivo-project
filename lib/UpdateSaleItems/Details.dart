import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myproject/SalesOrderModel/CreateOrderRequest.dart';
import 'package:myproject/SalesOrderModel/OrderItem.dart';
import 'package:myproject/SalesOrderModel/PrimaryOrder.dart';
import 'UpdateSalesOrder.dart';
import 'package:fluttertoast/fluttertoast.dart';

PrimaryOrder orderListItem;

class Details extends StatefulWidget {
  Details(data) {
    orderListItem = data;
  }
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final String orderItemUrl =
      "http://122.160.78.189:85/api/Sap/getPrimaryOrderItems";

  bool loading = true;
  final formatter = new DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    getPrimaryOrderItems(orderListItem.docEntry);
    

    super.initState();
  }

  List<OrderItem> orderItem = [];

  Future<Null> getPrimaryOrderItems(String docEntry) async {
    setState(() => loading = true);

    debugPrint(docEntry);
    String getoutUrl2 = orderItemUrl + '?DocEntry=' + docEntry;
    final response = await http.get(getoutUrl2);
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map party in responseJson) {
        orderItem.add(OrderItem.fromJson(party));
        loading = false;
      }
    });
  }

  List<CreateOrderRequest> create = new List<CreateOrderRequest>();

  CreateOrderRequest createOrderRequest = new CreateOrderRequest();
  final String deleteOrderUrl =
      "http://122.160.78.189:85/api/Sap/deletePrimaryOrder";

  Future deletePrimary(int index, PrimaryOrder createOrderRequest) async {
    String deleteUrl =
        deleteOrderUrl + '?DocEntry=' + createOrderRequest.docEntry.toString();
    Map<String, dynamic> body = Map();
    body.putIfAbsent("DocEntry", () => createOrderRequest.docEntry);

    String requestBody = json.encode(body);

    final response = await http.post(deleteUrl,
        headers: {"Content-Type": "application/json"}, body: requestBody);
    if (response.body.contains("Done")) {
      Fluttertoast.showToast(
        msg: "Delete Order Successfully",
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 3,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.indigo,
      );
      Navigator.pop(context);
    }
  }

  Future<void> _deleteAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ORDER'),
          content: const Text('Do you want to cancel the order'),
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
                int index;
                deletePrimary(index, orderListItem);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          // backgroundColor: Colors.green,
          title: Text('DETAILS '),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                CreateOrderRequest createOrderRequest =
                    new CreateOrderRequest();
                createOrderRequest.docDate = orderListItem.docDate;
                createOrderRequest.delDate = orderListItem.delDate;
                createOrderRequest.docEntry = int.parse(orderListItem.docEntry);
                createOrderRequest.cardName = orderListItem.cardName;
                createOrderRequest.cardCode = orderListItem.cardCode;
                createOrderRequest.paymentTerms = orderListItem.paymentTerms;
                createOrderRequest.prefTime = orderListItem.prefTime;
                createOrderRequest.remarks = orderListItem.remarks;
                createOrderRequest.status = orderListItem.status;
                createOrderRequest.updateDate = orderListItem.updateDate;
                createOrderRequest.createdBy =
                    int.parse(orderListItem.createdBy);
                createOrderRequest.canceledDate = orderListItem.canceledDate;
                createOrderRequest.canceled = orderListItem.canceled;
                createOrderRequest.docNum = int.parse(orderListItem.docNum);
                createOrderRequest.items = orderItem;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return UpdateSalesOrder(createOrderRequest);
                  }),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteAlert(context);
              },
            )
          ],
        ),
        body: Card(
          child: Container(
            //color: Colors.orangeAccent,
            child: Container(
              child: Stack(
                fit: StackFit.expand,
                overflow: Overflow.visible,
                children: <Widget>[
                  new ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            'ORDERS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.black87,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          color: Colors.white,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              new Row(
                                children: <Widget>[
                                  new Text(orderListItem.cardName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  //   new Text(indexvalue.cardName)
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  new Text(
                                    'Doc Entry :' +
                                        " " +
                                        orderListItem.docEntry +
                                        "                        " +
                                        'Status :' +
                                        " " +
                                        orderListItem.status,
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              Divider(),
                              new Row(
                                children: <Widget>[
                                  new Text(
                                    'Order date :' +
                                        " " +
                                        formatter.format(DateTime.parse(
                                            orderListItem.docDate)) +
                                        "        " +
                                        'Del Date :' +
                                        " " +
                                        formatter.format(DateTime.parse(
                                            orderListItem.delDate)),
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  new Text(
                                      'Payment :' +
                                          " " +
                                          orderListItem.paymentTerms +
                                          "        " +
                                          'Time :' +
                                          " " +
                                          orderListItem.prefTime,
                                      style: TextStyle(fontSize: 12))
                                ],
                              ),
                              Divider(),
                            ],
                          )),
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                      ),
                      Center(
                          child: new Text(
                        'ITEMS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                      Divider(color: Colors.black87),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: orderItem.isEmpty
                              ? Column(
                                  children: <Widget>[
                                    Text(
                                      'No Items added yet !',
                                      style: Theme.of(context).textTheme.title,
                                    )
                                  ],
                                )
                              : buildItemList())
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildItemList() {
    return Card(
      child: new ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: orderItem.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Text(orderItem[index].itemName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      //   new Text(indexvalue.cardName)
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        orderItem[index].itemCode +
                            "            " +
                            'Status :' +
                            " " +
                            orderItem[index].status,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Divider(),
                  new Row(
                    children: <Widget>[
                      new Text(
                          'DocEntry :' +
                              " " +
                              orderItem[index].docEntry +
                              "        " +
                              'LineNum :' +
                              " " +
                              orderItem[index].lineNum,
                          style: TextStyle(fontSize: 12))
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                          'Quantity :' +
                              " " +
                              orderItem[index].quantity.toString() +
                              "        " +
                              'Boxes :' +
                              " " +
                              orderItem[index].boxQty.toString() +
                              "        " +
                              'Retails Scheme :' +
                              " " +
                              orderItem[index].retSchemeQty.toString(),
                          style: TextStyle(fontSize: 12))
                    ],
                  ),
                  Divider(),
                ],
              ),
            );
          }),
    );
  }
}
