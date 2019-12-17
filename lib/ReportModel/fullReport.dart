class FullReport {
  final String maingroup;
  final String chain;
  final String groupname;
  final String customername;
  final String itemsgroupname;
  final String itemcode;
  final String itemname;
  final double salpackun;
  final double totalsalespieces;
  final double totalsaleslitres;
  final double totalsalesamount;
  final double otherquantity;
  final double realise;
  final double schemeamount;
  final double schemesaleamount;
  final double saleorderlitres;
  final double saleorderscheme;

  FullReport(
      this.maingroup,
      this.chain,
      this.groupname,
      this.customername,
      this.itemsgroupname,
      this.itemcode,
      this.itemname,
      this.salpackun,
      this.totalsalespieces,
      this.totalsaleslitres,
      this.totalsalesamount,
      this.otherquantity,
      this.realise,
      this.schemeamount,
      this.schemesaleamount,
      this.saleorderlitres,
      this.saleorderscheme);

  FullReport.fromJson(Map<String, dynamic> json)
      : maingroup = json['mainGroup'],
        chain = json['chain'],
        groupname = json['groupName'],
        customername = json['customerName'],
        itemsgroupname = json['itemsGroupName'],
        itemcode = json['itemCode'],
        itemname = json['itemName'],
        salpackun = json['salPackUn'],
        totalsalespieces = json['totalSalePieces'],
        totalsaleslitres = json['totalSaleLitres'],
        totalsalesamount = json['totalSaleAmount'],
        otherquantity = json['otherQuantity'],
        realise = json['realise'],
        schemeamount = json['schemeAmount'],
        schemesaleamount = json['schemeSaleAmount'],
        saleorderlitres = json['saleOrderLitres'],
        saleorderscheme = json['saleOrderScheme'];

  Map<String, dynamic> toJson() => {
        'mainGroup': maingroup,
        'chain': chain,
        'groupName': groupname,
        'customerName': customername,
        'itemsGroupName': itemsgroupname,
        'itemCode': itemcode,
        'itemName': itemname,
        'salPackUn': salpackun,
        'totalSalePieces': totalsalespieces,
        'totalSaleLitres': totalsaleslitres,
        'totalSaleAmount': totalsalesamount,
        'otherQuantity': otherquantity,
        'realise': realise,
        'schemeAmount': schemeamount,
        'schemeSaleAmount': schemesaleamount,
        'saleOrderLitres': saleorderlitres,
        'saleOrderScheme': saleorderscheme,
      };
}
