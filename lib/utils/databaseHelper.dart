import 'package:myproject/ReportModel/Expense.dart';
import 'package:myproject/ReportModel/WhereClause.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  Database db;

  DataBaseHelper() {
    init();
  }

  //create table//
  void init() async {
    Directory documentsDirctory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirctory.path, "items.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) async {
      await newDb.execute("""
        CREATE TABLE ExpenseTable
        (transId INTEGER,
        transDate TEXT,
        account TEXT,
        budget TEXT,
        deptt TEXT,
        state TEXT,
        category TEXT,
        branch TEXT,
        narration TEXT,
        amount DECIMAL)
          """);
    });
  }

  //insert data in a table //
  Future<int> insertExpense(Expense expn) {
    return db.insert(
      "ExpenseTable",
      expn.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  //read data from table //
  Future<String> readExpense() async {
    Database newDB = this.db;

    List<Map> list =
        await newDB.rawQuery("Select SUM(amount) as Total  from ExpenseTable");
    Map<String, dynamic> amountMap = list.first;
    print(amountMap["Total"]);
    return amountMap["Total"].toString();
  }

  Future<List<Expense>> dynamicQuery(
      String grpVal, List<WhereClause> whereListValue) async {
    Database newDB = this.db;
    List<Expense> expenseList = new List<Expense>();

    String dynamicQuery =
        "SELECT Sum(amount) as amount , state ,narration , account ,category,branch, deptt ,budget FROM ExpenseTable";
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
        WhereClause whereClause = whereListValue[i];

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

    dynamicQuery = dynamicQuery + whereClauseString + groupBy;

    List<Map> dynamicList = await newDB.rawQuery(dynamicQuery);

    for (int i = 0; i < dynamicList.length; i++) {
      Expense expense = new Expense();
      Map<String, dynamic> groupMap = dynamicList[i];
      expense.category = groupMap["category"];
      expense.budget = groupMap["budget"];
      expense.deptt = groupMap["deptt"];
      expense.state = groupMap["state"];
      expense.category = groupMap["category"];
      expense.branch = groupMap["branch"];
      expense.narration = groupMap["narration"];
      expense.amount =
          groupMap["amount"] == "" ? "0.00" : groupMap["amount"].toString();
      expense.account = groupMap["account"];
      expenseList.add(expense);
    }

    return expenseList;
  }

//delete query //
  void deleteExpense() async {
    int count = await db.rawDelete("DELETE FROM ExpenseTable");
    print(count);
  }
}
