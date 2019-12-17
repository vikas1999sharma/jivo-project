import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/ReportModel/Cost.dart';
import 'package:myproject/ReportModel/ProfitandLoss.dart';
import 'package:myproject/ReportModel/fullReport.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

String id;

String todate;

String fromdate;

class RealiseReport extends StatefulWidget {
  /*  RealiseReport({Key key, this.title}) : super(key: key); */
  const RealiseReport({this.key});
  final Key key;

  //final String title;
  @override
  _RealiseReportState createState() => _RealiseReportState();
}

class _RealiseReportState extends State<RealiseReport> {
  BuildContext buildContext;
  DateTime date;
  final String geturl = 'http://122.160.78.189:85/api/Reports/costReport';
  final fromdateTextController = TextEditingController();
  final todateTextController = TextEditingController();

  final GlobalKey<FormState> valuekey = GlobalKey<FormState>();
/*   List<String> _locations = [
    'mainGroup',
    'chain',
    'State',
    'customerName',
    'itemGroupName',
    'itemName',
  ]; // Option 2
   */
  String totalsaleRs = "";
  String totalsaleLtrs = "";
  String realiseReport = "";
  String realise = "";
  final formatter = new NumberFormat("#,###.##");
  int theValue = 1234;

  @override
  void initState() {
    super.initState();
    costReport(id, fromdate, todate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: Text('Realise Report'),
        ),
        // backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Container(
            color: Colors.white70,
            child: new Container(
                child: new ListView(children: <Widget>[
              new Card(
                margin: const EdgeInsets.all(10.0),
                color: Colors.indigo[900],
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                    ),
                    new Text(
                      "Select Month",
                      style: TextStyle(
                        fontSize: 20,
                        height: 2.0,
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                  ),
                  Expanded(
                    child: DateTimePickerFormField(
                      controller: fromdateTextController,
                      inputType: InputType.date,
                      format: DateFormat("MM-dd-yyyy"),
                      initialDate: DateTime.now(),
                      editable: false,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.date_range, color: Colors.red),
                        labelText: 'MM-dd-yyyy',
                        filled: true,
                        labelStyle: TextStyle(),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(2.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      onChanged: (dt) {
                        setState(() => date = dt);
                        print('Selected date: $date');
                      },
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                  ),
                  Expanded(
                    child: DateTimePickerFormField(
                      controller: todateTextController,
                      inputType: InputType.date,
                      format: DateFormat("MM-dd-yyyy"),
                      initialDate: DateTime.now(),
                      editable: false,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.date_range, color: Colors.red),
                        labelText: 'MM-dd-yyyy',
                        filled: true,
                        labelStyle: TextStyle(),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(2.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      onChanged: (dt) {
                        setState(() => date = dt);
                        print('Selected date: $date');
                      },
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                  ),
                  RaisedButton(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.indigo[900],
                    onPressed: () async {
                      if (fromdate != "" && todate != "") {
                        setState(() {});
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        fromdate = fromdateTextController.text;
                        debugPrint(fromdate);
                        todate = todateTextController.text;
                        debugPrint(todate);
                        await costReport(id, fromdate, todate);
                        Navigator.pop(context);
                        setState(() {});
                      } else {
                        // Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
              new Card(
                margin: const EdgeInsets.all(10.0),
                color: Colors.indigo[900],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                    ),
                    new Text(
                      "Realise Report",
                      style: TextStyle(
                        fontSize: 20,
                        height: 2.0,
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                    ),
                  ],
                ),
              ),
              /*   new Card(
                margin: const EdgeInsets.all(10.0),
                color: Colors.indigo[900],
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                      ),
                      DropdownButton(
                        hint: Text('--Select'),
                        style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                        value: _selectedLocation,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                          });
                        },
                        items: _locations.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ]),
              ), */
              new Center(
                  child: new Container(
                      padding: EdgeInsets.only(left: 10.0, top: 20.0),
                      alignment: Alignment.center,
                      child: new Column(children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Expanded(
                                child: new Text(
                              "Total Sale(Ltrs)",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            Expanded(
                              child: Text(
                                totalsaleRs.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            )
                          ],
                        ),
                        Padding(padding: const EdgeInsets.all(10.0)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Expanded(
                                  child: new Text(
                                "Total Sale(Rs)",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Expanded(
                                child: Text(
                                  totalsaleLtrs.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              )
                            ]),
                        Padding(padding: const EdgeInsets.all(10.0)),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                              ),
                              new Expanded(
                                  child: new Text(
                                "Realise(Rs)",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Expanded(
                                child: Text(
                                  realiseReport.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              )
                            ]),
                        Padding(padding: const EdgeInsets.all(10.0)),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Expanded(
                                  child: new Text(
                                "Realise After Scheme(Rs)",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Expanded(
                                  child: Text(
                                realise.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                    // fontWeight: FontWeight.bold),
                                    ),
                              ))
                            ]),
                      ]))),
            ]))));
  }

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
    totalsaleRs = profitandLossReport.totalSale.toString();
    debugPrint(totalsaleRs);
    totalsaleLtrs = profitandLossReport.totalSaleAmount.toString();
    debugPrint(totalsaleLtrs);
    realiseReport = double.parse(profitandLossReport.realise).toString();
    debugPrint(realiseReport);
    realise = double.parse(profitandLossReport.realiseAfterScheme).toString();
    debugPrint(realise);
    setState(() {});

    return cost;
  }
}
