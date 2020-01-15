import 'dart:io';
import 'package:myproject/ReportModel/Sales.dart';
import 'package:myproject/ReportModel/SalesWhereClause.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class SalesDatabaseHelper {
  Database db;

  SalesDatabaseHelper() {
    init();
  }
  void init() async {
    Directory documentsDirctory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirctory.path, "salesitems.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) async {
      await newDb.execute(
          """CREATE TABLE SalesTable(docDate TEXT,mainGroup TEXT,chain TEXT,state TEXT,cardCode TEXT,
        customerName TEXT,itmsGrpNam TEXT,itemCode TEXT,itemName TEXT,salPackUn DECIMAL,pieces DECIMAL,liters DECIMAL,
        saleAmount DECIMAL,realise DECIMAL,schemeQty DECIMAL,schemeSaleAmt DECIMAL,schemeAmt DECIMAL,claimAmount DECIMAL,variety STRING,type STRING)""");
    });
  }

  Future<int> insertExpense(Sales sales) {
    return db.insert(
      "SalesTable",
      sales.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<String> totalLtrs() async {
    Database newDB = this.db;
    List<Map> list =
        await newDB.rawQuery("Select SUM(liters) as TotalLtrs from SalesTable");
    Map<String, dynamic> amountMap = list.first;
    print(amountMap["TotalLtrs"]);
    return amountMap["TotalLtrs"].toString();
  }

  Future<String> totalRs() async {
    Database newDB = this.db;
    List<Map> list =
        await newDB.rawQuery("Select SUM(saleAmount) as Total from SalesTable");
    Map<String, dynamic> amountMap = list.first;
    print(amountMap["Total"]);
    return amountMap["Total"].toString();
  }

  Future<List<Sales>> dynamicQuery(
      String grpVal, List<SalesWhereClause> whereListValue) async {
    Database newDB = this.db;
    List<Sales> salesList = new List<Sales>();
    String dynamicQuerySalesAmount =
        "Select SUM(saleAmount) as saleAmount,Sum(liters) as liters ,type,variety,mainGroup,chain,state,customerName,itmsGrpNam ,itemName From SalesTable";
    String groupBy = " GROUP BY ";
    String whereClauseString = " ";
    if (grpVal != null) {
      groupBy = groupBy + grpVal;
    }

    if (grpVal == null) {
      groupBy = groupBy + grpVal;
    }

    if (whereListValue != null) {
      for (int i = 0; i < whereListValue.length; i++) {
        SalesWhereClause whereClause = whereListValue[i];

        if (i == 0) {
          whereClauseString = whereClauseString + " WHERE ";
        }

        whereClauseString = whereClauseString +
            whereClause.whereKey +
            "='" +
            whereClause.whereValue +
            "'";

        if (i < whereListValue.length - 1) {
          whereClauseString = whereClauseString + " AND ";
        }
      }
    }

    dynamicQuerySalesAmount =
        dynamicQuerySalesAmount + whereClauseString + groupBy;
    List<Map> dynamicList = await newDB.rawQuery(dynamicQuerySalesAmount);
    for (int i = 0; i < dynamicList.length; i++) {
      Sales sales = new Sales();
      Map<String, dynamic> groupMap = dynamicList[i];
      sales.mainGroup = groupMap["mainGroup"];
      sales.chain = groupMap["chain"];
      sales.state = groupMap["state"];
      sales.customerName = groupMap["customerName"];
      sales.itmsGrpNam = groupMap["itmsGrpNam"];
      sales.itemName = groupMap["itemName"];
      sales.variety = groupMap["variety"];
      sales.saleAmount = groupMap["saleAmount"] == ""
          ? "0.00"
          : groupMap["saleAmount"].toString();
      sales.liters =
          groupMap["liters"] == "" ? "0.00" : groupMap["liters"].toString();
      sales.type = groupMap["type"];
      salesList.add(sales);
    }
    return salesList;
  }

  void deleteExpense() async {
    int count = await db.rawDelete("DELETE FROM SalesTable");
    print(count);
  }
}
