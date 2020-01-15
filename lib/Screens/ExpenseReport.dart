import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/ReportModel/Cost.dart';
import 'package:myproject/ReportModel/Expense.dart';
import 'package:myproject/ReportModel/ProfitandLoss.dart';
import 'package:myproject/ReportModel/WhereClause.dart';
import 'package:myproject/ReportModel/fullReport.dart';
import 'package:myproject/Screens/RealiseReport.dart';
import 'package:myproject/utils/databaseHelper.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

const double _kPickerSheetHeight = 216.0;

class ExpenseReport extends StatefulWidget {
  @override
  _ExpenseReportState createState() => _ExpenseReportState();
}

class _ExpenseReportState extends State<ExpenseReport> {
  final dbHelper = DataBaseHelper();
  DateTime todate = DateTime.now();

  DateTime fromdate = DateTime.now();
  bool loading = false;
  String fromDate;
  String toDate;
  var userId;
  double sumAmount = 0;
  String id;
  var selectedGroupByValue;
  var previousSelectedGroupByValue;

  final formatter = new NumberFormat("#,###.##");

  @override
  void initState() {
    _controller = ScrollController();

    super.initState();
    costReport(id, fromDate, toDate);
    _asynMethod();
  }

  _asynMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = int.parse(prefs.getString("id"));
    if (fromDate != "" && toDate != "" && userId != "") {
      setState(() {});
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      grpby = null;
      fromDate = fromdate.toString();
      toDate = todate.toString();

      Map<String, dynamic> body = new Map();
      body.putIfAbsent("fromDate", () => fromDate);
      body.putIfAbsent("toDate", () => toDate);
      body.putIfAbsent("userId", () => userId);

      await getExpenseReport(body);
      await costReport(id, fromDate, toDate);
      Navigator.pop(context);
      setState(() {});
    } else {
      loading = false;
    }
  }

  //cost api url//
  final String geturl = 'http://122.160.78.189:85/api/Reports/costReport';
  double totalsaleRs = 0;
  double divResult = 0;
  //div() function //
  String div(String sumAmount) {
    if (sumAmount.isEmpty) {
      return " ";
    }
    divResult = double.parse(sumAmount) / totalsaleRs;
    print(divResult);
    return divResult.toString();
  }

  String getExpenseUrl = "http://122.160.78.189:85/SapExpense/getExpense";

  List<Expense> glbExpenseList = new List<Expense>();

  Future<List<http.Response>> getExpenseReport(expenseReport) async {
    var body = json.encode(expenseReport);
    var response = await http.post(getExpenseUrl,
        headers: {"Content-Type": "application/json"}, body: body);
    debugPrint(body);

    if (response.statusCode == 200) {
      final parsed =
          json.decode(response.body.toString()).cast<Map<String, dynamic>>();

      setState(() {
        List<Expense> expenseList =
            parsed.map<Expense>((json) => Expense.fromJson(json)).toList();

        dbHelper.deleteExpense();

        for (int i = 0; i < expenseList.length; i++) {
          Expense exp = expenseList[i];
          dbHelper.insertExpense(exp);
        }

        dbHelper.readExpense().then((String amount) {
          setState(() => sumAmount = double.parse(amount));
          Expense expense = new Expense();
          expense.state = "Expense";
          expense.amount = sumAmount.toString();

          glbExpenseList.removeWhere((expense) => expense != null);
          glbExpenseList.add(expense);
        });
      });
    } else {
      throw Exception('Failed to load data');
    }
    return null;
  }

  String grpby;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;

  void backNavigation() {
    if (whereClauseList.length > 0) {
      int backPointer = whereClauseList.length - 1;
      WhereClause where = whereClauseList[backPointer];
      grpby = where.whereKey;
      selectedGroupByValue = where.whereKey;
      whereClauseList.removeAt(backPointer);
      dbHelper.dynamicQuery(grpby, whereClauseList).then((expenseList) {
        setState(() {
          glbExpenseList = expenseList;
        });
      });
      return;
    } else {
      _asynMethod();
    }
  }

  void setSelectedValue(Expense expense) {
    WhereClause where = new WhereClause();
    if (grpby == null) {
      grpby = selectedGroupByValue;
      previousSelectedGroupByValue = selectedGroupByValue;
      dbHelper.dynamicQuery(grpby, whereClauseList).then((expenseList) {
        setState(() {
          glbExpenseList = expenseList;
        });
      });
      return;
    } else {
      grpby = selectedGroupByValue;
      where.whereKey = previousSelectedGroupByValue;
    }
    if (previousSelectedGroupByValue != grpby) {
      switch (previousSelectedGroupByValue) {
        case "state":
          where.whereValue = expense.state;
          break;

        case "branch":
          where.whereValue = expense.branch;
          break;

        case "budget":
          where.whereValue = expense.budget;
          break;

        case "deptt":
          where.whereValue = expense.deptt;
          break;

        case "account":
          where.whereValue = expense.account;
          break;

        case "category":
          where.whereValue = expense.category;
          break;

        case "narration":
          where.whereValue = expense.narration;
          break;

        default:
          return;
      }

      previousSelectedGroupByValue = selectedGroupByValue;
      whereClauseList.add(where);
      //  backPointer++;
      dbHelper.dynamicQuery(grpby, whereClauseList).then((expenseList) {
        setState(() {
          glbExpenseList = expenseList;
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

//cost api calling//
  Future<Cost> costReport(String id, String fromdate, String todate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    if (fromdate == null) {
      fromdate = "";
    } else {
      print("Please select dates");
    }
    if (todate == null) {
      todate = "";
    } else {
      print("Please select dates");
    }
    String getoutUrl2 = geturl +
        '?userId=' +
        id +
        '&fromDate=' +
        fromdate +
        '&toDate=' +
        todate;
    final response = await http.get(getoutUrl2);
    final responseJson = json.decode(response.body);
    var report = responseJson["fullReport"];
    List<FullReport> fullReport = report
        .map<FullReport>((json) => new FullReport.fromJson(json))
        .toList();
    var report2 = responseJson["profitAndLossReport"];
    ProfitandLossReport profitandLossReport =
        new ProfitandLossReport.fromJson(report2);
    Cost cost = new Cost(fullReport, profitandLossReport);
    debugPrint(totalsaleRs.toString());
    setState(() {
      totalsaleRs = profitandLossReport.totalSale;
    });
    return cost;
  }

  Widget buildHeaders() {
    return Card(
      child: Container(
        color: Colors.indigo[900],
        child: Row(
            //  mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: new Container(
                    padding: const EdgeInsets.all(6),
                    width: 100.0,
                    child: new Text(
                      "Total Sales (Rs)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white),
                    )),
              ),
              VerticalDivider(
                color: Colors.black,
              ),
              Expanded(
                child: new Container(
                    // padding: const EdgeInsets.all(6),
                    width: 160.0,
                    child: new Text(
                      "Total Sales (Ltrs)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
        child: glbExpenseList.isEmpty
            ? Center(child: Text('Empty', style: TextStyle(color: Colors.red)))
            : new ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                scrollDirection: Axis.vertical,
                itemCount: glbExpenseList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                Expense expns = glbExpenseList[index];
                                setSelectedValue(expns);
                              }
                            },
                            child: Container(
                                padding: const EdgeInsets.all(2),
                                width: 120,
                                child: new Text(
                                  formatter.format(double.parse(double.parse(
                                          glbExpenseList[index]
                                              .amount
                                              .toString())
                                      .toString())),
                                  style: TextStyle(color: Colors.lightBlue),
                                )),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.black,
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                Expense expns = glbExpenseList[index];
                                setSelectedValue(expns);
                              }
                            },
                            child: Container(
                                padding: const EdgeInsets.all(0),
                                width: 160,
                                child: new Text(
                                    formatter.format(double.parse(
                                        div(glbExpenseList[index].amount)
                                            .toString())),
                                    style: TextStyle(color: Colors.lightBlue))),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.black,
                        ),
                        Flexible(
                          child: Container(
                            //  padding: const EdgeInsets.all(15),
                            width: 150,
                            child: new Text(
                              showSelectedValue(glbExpenseList[index]),
                              maxLines: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }));
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
                backgroundColor: Colors.green,
                mode: CupertinoDatePickerMode.date,
                initialDateTime: fromdate,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() => fromdate = newDateTime);
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
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
              DateFormat.yMd().format(fromdate),
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
            return _buildBottomPicker(
              CupertinoDatePicker(
                backgroundColor: Colors.green,
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
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              'To Date',
              style: TextStyle(
                fontSize: 13,
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
              DateFormat.yMd().format(todate),
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

//on submit 2 api calling//
  Widget buildSubmitButton() {
    return RaisedButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userId = int.parse(prefs.getString("id"));
        if (_formKey.currentState.validate()) {
          if (fromDate != "" && toDate != "" && userId != "") {
            setState(() {});
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });

            fromDate = fromdate.toString();
            toDate = todate.toString();

            Map<String, dynamic> body = new Map();
            body.putIfAbsent("fromDate", () => fromDate);
            body.putIfAbsent("toDate", () => toDate);
            body.putIfAbsent("userId", () => userId);
            grpby = null;
            setState(() {
              whereClauseList.clear();
            });
            await getExpenseReport(body);
            await costReport(id, fromDate, toDate);
            Navigator.pop(context);
            setState(() {});
          } else {
            loading = false;
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

  ScrollController _controller;
//dynamic list//
  Widget buildItemList() {
    return Container(
        child: glbExpenseList.isEmpty
            ? Center(child: Text('Empty'))
            : new ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                scrollDirection: Axis.vertical,
                itemCount: glbExpenseList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(4),
                              child: new Text(
                                "Expense (Rs)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  Expense expns = glbExpenseList[index];
                                  setSelectedValue(expns);
                                }
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: new Text(
                                    formatter.format(double.parse(double.parse(
                                            glbExpenseList[index].amount)
                                        .toString())),
                                    style: TextStyle(color: Colors.lightBlue),
                                  )),
                            ),
                          ],
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(4),
                              child: new Text(
                                "Expense Per Litre(Rs)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.all(8),
                                child: new Text(
                                  formatter.format(double.parse(
                                      div(glbExpenseList[index].amount)
                                          .toString())),
                                )),
                          ],
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(4),
                              child: new Text(
                                grpby == null ? "" : grpby,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: new Text(
                                    showSelectedValue(glbExpenseList[index]),
                                    maxLines: 8),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        )
                      ],
                    ),
                  );
                }));
  }

  String showSelectedValue(Expense expense) {
    if (grpby == null) {
      return "";
    }

    switch (grpby) {
      case "state":
        return expense.state;

      case "branch":
        return expense.branch;

      case "budget":
        return expense.budget;

      case "deptt":
        return expense.deptt;

      case "account":
        return expense.account;

      case "category":
        return expense.category;

      case "narration":
        return expense.narration;

      default:
        return "";
    }
  }

  Widget buildBackButton() {
    return new RaisedButton(
      onPressed: () {
        //  Navigator.pop(context);
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

  var groupByList = [
    "state",
    "branch",
    "budget",
    "deptt",
    "account",
    "category",
    "narration",
  ];
  List<WhereClause> whereClauseList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              ),
              title: Text('Expense Report'),
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: buildSubmitButton()),
                    ],
                  ),
                ),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "Total Sales (Ltrs.)",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RealiseReport()),
                            );
                          },
                          child: Text(
                            formatter
                                .format(double.parse(totalsaleRs.toString())),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 15),
                          ),
                        ),
                      )
                    ],
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
                                    selectedGroupByValue = newValueSelected;
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
