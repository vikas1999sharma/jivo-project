import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/ReportModel/Sales.dart';
import 'package:myproject/ReportModel/SalesWhereClause.dart';
import 'dart:async';
import 'package:myproject/utils/SalesDatabaseHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double _kPickerSheetHeight = 216.0;

class RealiseReport extends StatefulWidget {
  @override
  _RealiseReportState createState() => _RealiseReportState();
}

class _RealiseReportState extends State<RealiseReport> {
  List varietyResult = [];
  String variety = "null";
  String type = "null";

  final formatter = new NumberFormat("#,###.##");
  final salesDbHelper = new SalesDatabaseHelper();
  String selectedGroupByValue;
  int userId;
  int id;
  var previousGroupBy;
  double sumLitres = 0;
  bool loading = false;
  int selectedVal;
  String fromdate;
  String todate;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  String selectedFilterType;
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();

    _asynMethod();
  }

  _asynMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = int.parse(prefs.getString("id"));

    variety = null;

    if (fromdate != "" && todate != "") {
      setState(() {});
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          });

      fromdate = fromDate.toString();
      todate = toDate.toString();

      setState(() {
        variety = varietyResult.length == 0 ? null : varietyResult.toString();
        type = selectedFilterType;
      });
      Map<String, dynamic> body = new Map();
      body.putIfAbsent("fromdate", () => fromdate);
      body.putIfAbsent("todate", () => todate);
      body.putIfAbsent("userId", () => userId);
      body.putIfAbsent("variety", () => variety);
      body.putIfAbsent("type", () => type);
      grpby = null;
      setState(() {
        whereClauseList.clear();
      });

      await getSalesReport(body);

      Navigator.pop(context);
      setState(() {});
    } else {
      loading = false;
    }
  }

  List<String> typeFilter = <String>['null', 'Sales', 'Sales Return', 'Claims'];
  String grpby;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;

  Widget buildSubmitButton() {
    return RaisedButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userId = int.parse(prefs.getString("id"));
        variety = null;

        if (_formKey.currentState.validate()) {
          if (fromdate != "" && todate != "") {
            setState(() {});
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                });
            _formKey.currentState.save();
            fromdate = fromDate.toString();
            todate = toDate.toString();

            setState(() {
              variety =
                  varietyResult.length == 0 ? null : varietyResult.toString();
              type = selectedFilterType;
            });
            Map<String, dynamic> body = new Map();
            body.putIfAbsent("fromdate", () => fromdate);
            body.putIfAbsent("todate", () => todate);
            body.putIfAbsent("userId", () => userId);
            body.putIfAbsent("variety", () => variety);
            body.putIfAbsent("type", () => type);
            grpby = null;
            setState(() {
              whereClauseList.clear();
            });

            await getSalesReport(body);
            Navigator.pop(context);
            setState(() {});
          } else {
            loading = false;
          //  await new Future.delayed(const Duration(seconds: 20));
          }
        }
      },
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      color: Colors.indigo[900],
    );
  }

  double sumAmount = 0;

  void backNavigation() {
    if (whereClauseList.length > 0) {
      int backPointer = whereClauseList.length - 1;
      SalesWhereClause where = whereClauseList[backPointer];
      grpby = where.whereKey;
      selectedGroupByValue = where.whereKey;
      whereClauseList.removeAt(backPointer);
      salesDbHelper.dynamicQuery(grpby, whereClauseList).then((saleList) {
        setState(() {
          glbSalesList = saleList;
        });
      });
      return;
    } else {
      _asynMethod();
    }
  }

  void setSelectedValue(Sales sale) {
    SalesWhereClause where = new SalesWhereClause();
    if (grpby == null) {
      grpby = selectedGroupByValue;
      previousGroupBy = selectedGroupByValue;
      salesDbHelper.dynamicQuery(grpby, whereClauseList).then((salesList) {
        setState(() {
          glbSalesList = salesList;
        });
      });
      return;
    } else {
      grpby = selectedGroupByValue;
      where.whereKey = previousGroupBy;
    }
    if (previousGroupBy != grpby) {
      switch (previousGroupBy) {
        case "mainGroup":
          where.whereValue = sale.mainGroup;
          break;
        case "chain":
          where.whereValue = sale.chain;
          break;
        case "state":
          where.whereValue = sale.state;
          break;
        case "customerName":
          where.whereValue = sale.customerName;
          break;
        case "itemName":
          where.whereValue = sale.itemName;
          break;
        case "itmsGrpNam":
          where.whereValue = sale.itmsGrpNam;
          break;
        case "type":
          where.whereValue = sale.type;
          break;
        case "variety":
          where.whereValue = sale.variety;
          break;

        default:
      }
      previousGroupBy = selectedGroupByValue;
      whereClauseList.add(where);
      //  backPointer++;
      salesDbHelper.dynamicQuery(grpby, whereClauseList).then((saleList) {
        setState(() {
          glbSalesList = saleList;
        });
      });
    } else {
      setState(() {
        _validate = true;
        Fluttertoast.showToast(
          msg: "Please Select next drill!",
          textColor: Colors.redAccent,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIos: 3,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.indigo,
        );
      });
    }
  }

  List<SalesWhereClause> whereClauseList = [];
  final String url = 'http://122.160.78.189:85/SapSales/getSales';

  List<Sales> glbSalesList = new List<Sales>();

  Future<List<http.Response>> getSalesReport(salesReport) async {
    var body = json.encode(salesReport);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      final parsed =
          json.decode(response.body.toString()).cast<Map<String, dynamic>>();
await Future.value();
      setState(() {
        List<Sales> salesList =
            parsed.map<Sales>((json) => Sales.fromJson(json)).toList();
          
       
        salesDbHelper.deleteExpense();

        for (int i = 0; i < salesList.length; i++) {
          Sales _sales = salesList[i];
          salesDbHelper.insertExpense(_sales);
        }
        salesDbHelper.totalRs().then((String saleAmount) {
          setState(() => sumAmount = double.parse(saleAmount));
          Sales sales = new Sales();
          sales.saleAmount = sumAmount.toString();
          sales.liters = sumLitres.toString();
          sales.variety = variety.toString();
          glbSalesList.removeWhere((sales) => sales != null);
          glbSalesList.add(sales);
        });

        salesDbHelper.totalLtrs().then((String liters) {
          setState(() => sumLitres = double.parse(liters));

          Sales sales = new Sales();
          sales.state = "Sales";
          sales.liters = sumLitres.toString();

          sales.saleAmount = sumAmount.toString();

          glbSalesList.removeWhere((sales) => sales != null);
          glbSalesList.add(sales);
        });
      
      });
    }

    await new Future.delayed(const Duration(seconds: 34));
    return null;
  }

  final GlobalKey<FormState> valuekey = GlobalKey<FormState>();
  List<String> groupByList = [
    'mainGroup',
    'chain',
    'state',
    'customerName',
    'itmsGrpNam',
    'itemName',
  ];

  ScrollController _controller;

  Widget buildHeaders() {
    return Card(
      child: Container(
        color: Colors.indigo[900],
        child: Row(
            //  mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: new Container(
                    padding: const EdgeInsets.all(3),
                    width: 100.0,
                    child: new Text(
                      "Total Sales (Rs)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white),
                    )),
              ),
              VerticalDivider(
                width: 12,
                color: Colors.black,
              ),
              Expanded(
                child: new Container(
                    // padding: const EdgeInsets.all(6),
                    width: 100.0,
                    child: new Text(
                      "Total Sales (Ltrs)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white),
                    )),
              ),
              VerticalDivider(
                color: Colors.black,
              ),
              Expanded(
                child: new Container(
                    //padding: const EdgeInsets.all(18),

                    width: 100.0,
                    child: new Text(
                      grpby == null ? "" : grpby,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white),
                    )),
              ),
            ]),
      ),
    );
  }

  Widget buildList() {
    return Container(
        child: glbSalesList.isEmpty
            ? Center(child: Text('Empty', style: TextStyle(color: Colors.red)))
            : new ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                scrollDirection: Axis.vertical,
                itemCount: glbSalesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: InkWell(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  Sales expns = glbSalesList[index];
                                  setSelectedValue(expns);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                width: 120,
                                child: new Text(
                                    formatter.format(double.parse(double.parse(
                                            glbSalesList[index]
                                                .saleAmount
                                                .toString())
                                        .toString())),
                                    style: TextStyle(
                                        color: Colors.lightBlue, fontSize: 14)),
                              )),
                        ),
                        SizedBox(width: 30),
                        Divider(color: Colors.black),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                Sales expns = glbSalesList[index];
                                setSelectedValue(expns);
                              }
                            },
                            child: Container(
                                padding: const EdgeInsets.all(0),
                                width: 150,
                                child: new Text(
                                  formatter.format(double.parse(double.parse(
                                          glbSalesList[index].liters.toString())
                                      .toString())),
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 14),
                                )),
                          ),
                        ),
                        SizedBox(width: 20),
                        Flexible(
                          child: Container(
                            //  padding: const EdgeInsets.all(15),
                            width: 150,
                            child:
                                new Text(showSelectedValue(glbSalesList[index]),
                                    style: TextStyle(
                                      fontFamily: 'DancingScript',
                                    ),
                                    maxLines: 8),
                          ),
                        ),
                      ],
                    ),
                  );
                }));
  }

  String showSelectedValue(Sales salesList) {
    if (grpby == null) {
      return "";
    }

    switch (grpby) {
      case "mainGroup":
        return salesList.mainGroup;

      case "chain":
        return salesList.chain;

      case "state":
        return salesList.state;
        break;

      case "customerName":
        return salesList.customerName;

      case "itmsGrpNam":
        return salesList.itmsGrpNam;

      case "itemName":
        return salesList.itemName;

      case "type":
        return salesList.type;

      case "variety":
        return salesList.variety;

      default:
        return "";
    }
  }

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
                initialDateTime: fromDate,
                backgroundColor: Colors.green,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() => fromDate = newDateTime);
                },
              ),
            );
          },
        );
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              'From Date',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Text(
              DateFormat.yMd().format(fromDate),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.blue,
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
            return Container(
              child: _buildBottomPicker(
                CupertinoDatePicker(
                  backgroundColor: Colors.green,
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: toDate,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() => toDate = newDateTime);
                  },
                ),
              ),
            );
          },
        );
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              'To Date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Text(
              DateFormat.yMd().format(toDate),
              style: const TextStyle(
                fontSize: 13.0,
                color: Colors.blue,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget buildBackButton() {
    return new RaisedButton(
      onPressed: () {
        backNavigation();
      },
      child: Text(
        "Back",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
      ),
      color: Colors.indigo[900],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              ),
              title: Text('Sales Report'),
            ),
            resizeToAvoidBottomInset: false,
            body: Form(
              key: _formKey,
              autovalidate: _validate,
              child: Container(
                  child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.indigo[900],
                    child: new Row(
                      children: <Widget>[
                        Card(
                            color: Colors.indigo[900],
                            child: Text(
                              "Select Date",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: new Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: _buildFromDatePicker(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                      ),
                      Flexible(
                        child: _buildtoDatePicker(context),
                      )
                    ],
                  ),
                ),
                Card(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: buildSubmitButton()),
                      Padding(padding: const EdgeInsets.all(40)),
                      Container(
                          child: Flexible(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            iconEnabledColor: Colors.white,
                            items: typeFilter.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    dropDownStringItem,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String newValueSelected) {
                              // typeFilter.clear();

                              setState(() {
                                selectedFilterType = newValueSelected;
                              });
                            },
                            value: selectedFilterType,
                            hint: Container(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                '--Type ',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                Card(
                  //color: Colors.indigo[900],
                  child: Container(
                    child: MultiSelectFormField(
                      autovalidate: false,
                      titleText: 'Choose only one Variety',
                      dataSource: [
                        {
                          "display": "Canola",
                          "value": "Canola",
                        },
                        {
                          "display": "Mustard",
                          "value": "Mustard",
                        },
                        {
                          "display": "Olive",
                          "value": "Olive",
                        },
                        {
                          "display": "WGD",
                          "value": "WGD",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'OK',
                      cancelButtonLabel: 'CANCEL',
                      hintText: 'Please choose one ',
                      value: varietyResult,
                      onSaved: (value) {
                        if (value == null)
                          return null;
                        else {
                          setState(() {
                            this.varietyResult = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Card(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: new Text(
                            "Realise Report",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      Container(
                          padding: const EdgeInsets.all(2),
                          child: buildBackButton())
                    ],
                  ),
                ),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Flexible(
                          flex: 1,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              color: Colors.indigo[900],
                              padding: const EdgeInsets.all(0),
                              child: DropdownButtonFormField<String>(
                                iconEnabledColor: Colors.white,
                                items: groupByList
                                    .map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        dropDownStringItem,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String newValueSelected) {
                                  setState(() {
                                    this.selectedGroupByValue =
                                        newValueSelected;
                                  });
                                },
                                validator: (String value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please Select group by first!';
                                  }
                                  return null;
                                },
                                value: selectedGroupByValue,
                                hint: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    '--Select ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                new Column(
                  children: <Widget>[
                    buildHeaders(),
                    Divider(),
                    buildList(),
                    Divider()
                  ],
                ),
              ]))),
            )));
  }
}
