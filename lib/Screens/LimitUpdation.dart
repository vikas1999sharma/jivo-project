import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myproject/Models/Limitchanges.dart';

class LimitUpdation extends StatefulWidget {
  @override
  _LimitUpdationState createState() => _LimitUpdationState();
}

class _LimitUpdationState extends State<LimitUpdation> {
  String _fromdate = "Select";
  String _todate = "Select";
  List<Limitchanges> newLimit = new List<Limitchanges>();
  final formatter1 = new DateFormat("yyyy-MM-dd To HH:mm:ss");
  static final geturl =
      "http://122.160.78.189:85/api/Web/getCustomerLimitChanges";

  String fromdate;

  String todate;
  bool loading = false;

  @override
  void initState() {
    super.initState();
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
          title: Text(
            'Check Limit Changes',
            style: TextStyle(fontSize: 18),
          ),
          //backgroundColor: Colors.purple,
        ),
        body: Container(
         
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                    print('confirm $date');
                    _fromdate = '${date.year} - ${date.month} - ${date.day}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  //margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  height: 30.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "From Date",
                        style: TextStyle(
                            // color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 13.0,
                                  //color: Colors.teal,
                                ),
                                Text(
                                  " $_fromdate",
                                  style: TextStyle(
                                      //color: Colors.teal,

                                      fontSize: 13.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              Divider(),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                    print('confirm $date');
                    _todate = '${date.year} - ${date.month} - ${date.day}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  // margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  height: 30.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "To Date",
                        style: TextStyle(
                            //    color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 13.0,
                                  //   color: Colors.teal,
                                ),
                                Text(
                                  " $_todate",
                                  style: TextStyle(
                                      //     color: Colors.teal,

                                      fontSize: 13.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              Divider(),
              RaisedButton(
                child: Text(
                  'SUBMIT',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                color: Colors.indigo[900],
                onPressed: () {
                  if (fromdate != "" && todate != "") {
                    setState(() => loading = true);
                    print('error');
                    fromdate = _fromdate.toString();
                    todate = _todate.toString();
                    setState(() {
                      loading = false;
                    });
                    Map<String, dynamic> customerChangeReq = new Map();
                    customerChangeReq.putIfAbsent("fromDate", () => fromdate);
                    customerChangeReq.putIfAbsent("toDate", () => todate);
                    getCustomerChanges(customerChangeReq);
                  }
                },
              ),
              Divider(),
              Container(
                child: new Expanded(
                  child: Container(
                    //height: MediaQuery.of(context).size.height * 0.4,
                    child: newLimit.isEmpty
                        ? Column(
                            children: <Widget>[
                              Text(
                                'No Limit added yet !',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : loading
                            ? Center(child: CircularProgressIndicator())
                            : new ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: newLimit.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return new Card(

                                      //      padding: const EdgeInsets.all(0.0),
                                      child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        child: new Text(
                                          newLimit[index].cardName,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        child: new Text(
                                            newLimit[index].cardCode,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.0),
                                            textAlign: TextAlign.left),
                                      ),
                                      Divider(),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        child: new Text(
                                            "Valid Till  : " +
                                                formatter1.format(
                                                    DateTime.parse(
                                                        newLimit[index]
                                                            .lastCreatedOn)),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.0),
                                            textAlign: TextAlign.left),
                                      ),
                                      Divider(),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        child: new Text(
                                          "New Limit  : " +
                                              newLimit[index]
                                                  .newLimit
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        child: new Text(
                                          "Limit Changes  : " +
                                              newLimit[index]
                                                  .timesChanged
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  ));
                                }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<http.Response>> getCustomerChanges(
      Map<String, dynamic> customerChangeReq) async {
    setState(() => loading = true);
    var body = json.encode(customerChangeReq);
    var response = await http.post(geturl,
        headers: {"Content-Type": "application/json"}, body: body);
    debugPrint(body);
    if (response.statusCode == 200) {
      final parsed =
          json.decode(response.body.toString()).cast<Map<String, dynamic>>();

      setState(() {
        newLimit = parsed
            .map<Limitchanges>((json) => Limitchanges.fromJson(json))
            .toList();
        new CircularProgressIndicator();
        loading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
    return null;
  }
}
