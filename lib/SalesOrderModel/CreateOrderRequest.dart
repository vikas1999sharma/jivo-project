import 'package:http/http.dart' as http;
import 'dart:convert';
import 'OrderItem.dart';

final createPrimaryOrderurl =
    "http://122.160.78.189:85/api/Sap/createPrimaryOrder";

Future<http.Response> createPrimaryOrder(
    Map<String, dynamic> postJsonData) async {
  // showToast("inside createSapRightsfunc");
  var body = json.encode(postJsonData);
  var response = await http.post(createPrimaryOrderurl,
      headers: {"Content-Type": "application/json"}, body: body);
  return response;
}

String getLineNum(List<OrderItem> items) {
  String lineNum = "0";

  if (items != null && items.length > 0) {
    lineNum = items[items.length - 1].lineNum;
  }

  int lineNo = int.parse(lineNum);
  lineNo++;
  return lineNo.toString();
}

class CreateOrderRequest {
  int docEntry;
  int docNum;
  String docDate;
  String cardCode;
  String cardName;
  String delDate;
  String prefTime;
  String paymentTerms;
  String remarks;
  int createdBy;
  String createdOn;
  String canceled;
  String canceledDate;
  String updateDate;
  String status;
  List<OrderItem> items;

  CreateOrderRequest(
      {this.docEntry,
      this.docNum,
      this.docDate,
      this.cardCode,
      this.cardName,
      this.delDate,
      this.prefTime,
      this.paymentTerms,
      this.createdBy,
      this.remarks,
      this.createdOn,
      this.canceled,
      this.canceledDate,
      this.updateDate,
      this.status,
      this.items});

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) {
    List<OrderItem> items = (json['items'] as List)
        .map((itemSaleJson) => OrderItem.fromJson(itemSaleJson))
        .toList();

    return CreateOrderRequest(
        docEntry: json['DocEntry'],
        docNum: json['DocNum'],
        docDate: json['DocDate'],
        cardCode: json['CardCode'],
        cardName: json['CardName'],
        delDate: json['DelDate'],
        prefTime: json['PrefTime'],
        paymentTerms: json['PaymentTerms'],
        remarks: json['Remarks'],
        createdBy: json['CreatedBy'],
        createdOn: json['CreatedOn'],
        canceled: json['Canceled'],
        canceledDate: json['CanceledDate'],
        updateDate: json['UpdateDate'],
        status: json['Status'],
        items: items);
  }
  Map<String, dynamic> toJson() => {
        'DocEntry': docEntry,
        'DocNum': docNum,
        'DocDate': docDate,
        'CardCode': cardCode,
        'CardName': cardName,
        'DelDate': delDate,
        'PrefTime': prefTime,
        'PaymentTerms': paymentTerms,
        'Remarks': remarks,
        'CreatedBy': createdBy,
        'CreatedOn': createdOn,
        'Canceled': canceled,
        'CanceledDate': canceledDate,
        'UpdateDate': updateDate,
        'Status': status,
        'items': items,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();

    map["DocEntry"] = docEntry;
    map["DocNum"] = docNum;
    map["DocDate"] = docDate;
    map["CardCode"] = cardCode;
    map["CardName"] = cardName;
    map["DelDate"] = delDate;
    map["PrefTime"] = prefTime;
    map["PaymentTerms"] = paymentTerms;
    map["Remarks"] = remarks;
    map["CreatedBy"] = createdBy;
    map["CreatedOn"] = createdOn;
    map["Canceled"] = canceled;
    map["CanceledDate"] = canceledDate;
    map["UpdateDate"] = updateDate;
    map["Status"] = status;
    map["items"] = items;

    return map;
  }
}
