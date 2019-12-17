import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:myproject/Models/Limit.dart';
import 'package:myproject/Models/PartyDetailmodel.dart';
import 'package:myproject/Models/Partymodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class SearchCustLimit extends StatefulWidget {
  @override
  _SearchCustLimitState createState() => new _SearchCustLimitState();
}

class _SearchCustLimitState extends State<SearchCustLimit> {
  Widget appBarTitle = new Text("Search Party");
  Icon actionIcon = new Icon(Icons.search);
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getParties() async {
    setState(() => loading = true);
    final response = await http.get(getparties);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map party in responseJson) {
        _party.add(PartyModel.fromJson(party));
        loading = false;
      }
    });
  }

  bool loading = false;
  @override
  void initState() {
    super.initState();

    getParties();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: new Text(
          'Create Limit',
          style: TextStyle(fontSize: 18),
        ),
        elevation: 0.0,
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
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
            child: loading
                ? Center(child: CircularProgressIndicator())
                : _searchResult.length != 0 || controller.text.isNotEmpty
                    ? new ListView.builder(
                        itemCount: _searchResult.length,
                        itemBuilder: (context, i) {
                          return new Card(
                            child: new ListTile(
                              title: new Text(_searchResult[i].cardCode +
                                  '      ' +
                                  _searchResult[i].cardName),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CustomerLimit(
                                          _searchResult[i].cardCode,
                                        )));
                              },
                            ),
                            margin: const EdgeInsets.all(0.0),
                          );
                        },
                      )
                    : loading
                        ? Center(child: CircularProgressIndicator())
                        : new ListView.builder(
                            itemCount: _party.length,
                            itemBuilder: (context, index) {
                              return new Card(
                                child: new ListTile(
                                  title: new Text(_party[index].cardCode +
                                      '      ' +
                                      _party[index].cardName),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => CustomerLimit(
                                                  _party[index].cardCode,
                                                )));
                                  },
                                ),
                                margin: const EdgeInsets.all(0.0),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _party.forEach((_party) {
      if (_party.cardCode.toLowerCase().contains(text) ||
          _party.cardName.toLowerCase().contains(text))
        _searchResult.add(_party);
    });

    setState(() {});
  }

  List<PartyModel> _searchResult = [];
  List<PartyModel> _party = [];
  final String getparties = "http://122.160.78.189:85/api/Web/getParties";
  // final String GET_PARTIES = "http://192.168.0.148:85/api/Web/getParties";
}

const double _kPickerSheetHeight = 216.0;

PartyDetailmodel partyDetail;
String gCardCode;
double currentLimit = 0;

class CustomerLimit extends StatefulWidget {
  CustomerLimit(data) {
    gCardCode = data;
  }

  @override
  _CustomerLimitState createState() => _CustomerLimitState();
}

class _CustomerLimitState extends State<CustomerLimit> {
  final String getoutUrl =
      'http://122.160.78.189:85/api/Web/getCustomerOutstanding';

  //DateTime date1=DateTime.now();
  DateTime time = DateTime.now();
  DateTime date = DateTime.now().add(new Duration(hours: 6));
  DateTime dateTime = DateTime.now().add(new Duration(hours: 6));
  String newLimit, validDate, validTime;
  int id;

  static final getPostUrl = 'http://122.160.78.189:85/api/Web/createLimit';

  final GlobalKey<FormState> _currentKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _localformKey = GlobalKey<FormState>();

  final newLimitTextController = TextEditingController();
  final validDateTextController = TextEditingController();
  final validTimeTextController = TextEditingController();
  final currentLimitTextController = TextEditingController();

  String cardCode;
  final formatter = new NumberFormat("#,###.##");
  int theValue = 1234;

  Widget _buildMenu(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(),
      height: 44.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
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

  TimeOfDay startTime = TimeOfDay.now();
  Widget _buildDateTimePicker(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return _buildBottomPicker(
                CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: dateTime,

                  /* initialTime: TimeOfDay(
                                    hour: date.hour, minute: date.minute), */

                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() => dateTime = newDateTime);
                  },
                ),
              );
            },
          );
        },
        child: _buildMenu(
          <Widget>[
            const Text(
              'Date & Time',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(45.0),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  time == null
                      ? 'No date Chosen !'
                      : /* 'Picked Date : ${ */
                      DateFormat.yMMMd().add_jm().format(dateTime),
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    getCustomerOutstanding(gCardCode);
  }

  @override
  void dispose() {
    newLimitTextController.dispose();
    validDateTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              ),title: Text('Add New Limits')),
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          body: Container(
              // margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(3),
              color: Colors.white,
              child: Card(
                child: new ListView(children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      //  margin: const EdgeInsets.all(5),
                      color: Colors.indigo[500],
                      child: Text('CREATE LIMIT OF CUSTOMER',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(5)),
                  Card(
                      color: Colors.white,
                      //margin: const EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Card(
                          child: new Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                              ),
                              Card(
                                  child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // Padding(padding: const EdgeInsets.all(2.0)),
                                  Flexible(
                                      child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Current Outstanding',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child:
                                          new FutureBuilder<PartyDetailmodel>(
                                              future: getCustomerOutstanding(
                                                  gCardCode),
                                              builder: (context, snapShot) {
                                                if (!snapShot.hasData)
                                                  return Container();

                                                return new Text(
                                                  "\u20B9" +
                                                      formatter.format(
                                                          double.parse(snapShot
                                                              .data
                                                              .currentOutstanding)),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13),
                                                );
                                              }),
                                    ),
                                  )
                                ],
                              )),
                              Padding(padding: const EdgeInsets.all(5)),
                              Card(
                                  child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  /*   Padding(
                                padding: const EdgeInsets.all(2.0),
                              ), */
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Current Limit',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                          //  fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: new FutureBuilder<
                                              PartyDetailmodel>(
                                          key: _currentKey,
                                          future:
                                              getCustomerOutstanding(gCardCode),
                                          builder: (context, snapShot) {
                                            if (!snapShot.hasData) {
                                              return Container();
                                            } else {
                                              if (snapShot.data != null) {
                                                currentLimit = double.parse(
                                                    snapShot.data.currentLimit);
                                              }
                                              return new Text(
                                                "\u20B9" +
                                                    formatter.format(
                                                        double.parse(snapShot
                                                            .data
                                                            .currentLimit)),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                ),
                                              );
                                            }
                                          }),
                                    ),
                                  )
                                ],
                              )),
                              Padding(
                                padding: const EdgeInsets.all(5),
                              ),
                              Card(
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          'New Limit',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          key: _localformKey,
                                          controller: newLimitTextController,
                                          autofocus: true,
                                          decoration: new InputDecoration(
                                            fillColor: Colors.red,
                                            labelText: 'Enter Limit',
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      2.0),
                                              borderSide: new BorderSide(),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(padding: const EdgeInsets.all(5)),
                              Card(
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  textDirection: prefix0.TextDirection.ltr,
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: _buildDateTimePicker(context)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                              ),
                              new Container(
                                  child: Card(
                                      child: new Column(children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: new RaisedButton(
                                      child: const Text(
                                        'Submit',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      color: Colors.indigo[900],
                                      elevation: 14.0,
                                      splashColor: Colors.blue,
                                      onPressed: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                                 
                                        id = int.parse(prefs.getString("id"));
                                        Limit newPost = new Limit(
                                            cardCode: gCardCode,
                                            createdBy: id,
                                           
                                            currentLimit: currentLimit,
                                            newLimit: double.parse(
                                                newLimitTextController.text),
                                            validTill: dateTime.toString());

                                        var jsonData = newPost.toJson();
                                        debugPrint(gCardCode);
                                        debugPrint(id.toString());
                                        debugPrint(currentLimit.toString());

                                        debugPrint(double.parse(
                                                newLimitTextController.text)
                                            .toString());

                                        createPost(jsonData);
                                      }),
                                ),
                              ])))
                            ],
                          ),
                        ),
                      ))
                ]),
              )),
        ));
  }

  Future<http.Response> createPost(Map<String, dynamic> postJsonData) async {
    var body = json.encode(postJsonData);
    var response = await http.post(getPostUrl,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");

    if (response.body.contains("Done")) {
      Fluttertoast.showToast(
        msg: "Successfully Stored",
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 3,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.indigo,
      );
      Navigator.of(context).pop("/Value");
    }

    return response;
  }

  Future<PartyDetailmodel> getCustomerOutstanding(String cardCode) async {
    String getoutUrl2 = getoutUrl + '?CardCode=' + cardCode;
    final response = await http.get(getoutUrl2);
    final responseJson = json.decode(response.body);

    List<PartyDetailmodel> userList = responseJson
        .map<PartyDetailmodel>((json) => new PartyDetailmodel.fromJson(json))
        .toList();
    partyDetail = userList[0];
    return userList[0];
  }
}
