class SchemeItemList {

String itemcode;
   String itemname;

  SchemeItemList({this.itemcode, this.itemname});

   factory SchemeItemList.fromJson(Map<String, dynamic> json) {
      return new SchemeItemList(
         itemcode: json['itemCode'].toString(),
         itemname: json['itemName'].toString()
      );
   }
}