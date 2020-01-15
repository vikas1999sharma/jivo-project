class Sales {
  String docDate;
  String mainGroup;
  String chain;
  String state;
  String cardCode;
  String customerName;
  String itmsGrpNam;
  String itemCode;
  String itemName;
  double salPackUn;
  double pieces;
  String liters;
  String saleAmount;
  double realise;
  double schemeQty;
  double schemeSaleAmt;
  double schemeAmt;
  double claimAmount;
  String variety;
  String type;

  Sales(
      {this.cardCode,
      this.chain,
      this.claimAmount,
      this.customerName,
      this.docDate,
      this.itemCode,
      this.itemName,
      this.itmsGrpNam,
      this.liters,
      this.mainGroup,
      this.pieces,
      this.realise,
      this.saleAmount,
      this.salPackUn,
      this.schemeAmt,
      this.schemeQty,
      this.schemeSaleAmt,
      this.state,
      this.variety,
      this.type});
  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      cardCode: json['cardCode'],
      chain: json['chain'],
      claimAmount: json['claimAmount'],
      customerName: json['customerName'],
      docDate: json['docDate'],
      itemCode: json['itemCode'],
      itemName: json['itemName'],
      itmsGrpNam: json['itmsGrpNam'],
      liters: json['liters'].toString(),
      mainGroup: json['mainGroup'],
      pieces: json['pieces'],
      realise: json['realise'],
      saleAmount: json['saleAmount'].toString(),
      salPackUn: json['salPackUn'],
      schemeAmt: json['schemeAmt'],
      schemeQty: json['schemeQty'],
      schemeSaleAmt: json['schemeSaleAmt'],
      state: json['state'],
      variety: json['variety'],
      type: json['type'],
    );
  }
  Map<String, dynamic> toJson() => {
        'cardCode': cardCode,
        'chain': chain,
        'claimAmount': claimAmount,
        'customerName': customerName,
        'docDate': docDate,
        'itemCode': itemCode,
        'itemName': itemName,
        'itmsGrpNam': itmsGrpNam,
        'liters': liters,
        'mainGroup': mainGroup,
        'pieces': pieces,
        'realise': realise,
        'saleAmount': saleAmount,
        'salPackUn': salPackUn,
        'schemeAmt': schemeAmt,
        'schemeQty': schemeQty,
        'schemeSaleAmt': schemeSaleAmt,
        'state': state,
        'variety': variety,
        'type': type
      };
  Map toMap() {
    var map = new Map<String, dynamic>();
    map['cardCode'] = cardCode;
    map['chain'] = chain;
    map['claimAmount'] = claimAmount;
    map['customerName'] = customerName;
    map['docDate'] = docDate;
    map['itemCode'] = itemCode;
    map['itemName'] = itemName;
    map['itmsGrpNam'] = itmsGrpNam;
    map['liters'] = liters;
    map['mainGroup'] = mainGroup;
    map['pieces'] = pieces;
    map['realise'] = realise;
    map['saleAmount'] = saleAmount;
    map['salPackUn'] = salPackUn;
    map['schemeAmt'] = schemeAmt;
    map['schemeQty'] = schemeQty;
    map['schemeSaleAmt'] = schemeSaleAmt;
    map['state'] = state;
    map['variety'] = variety;
    map['type'] = type;
    return map;
  }
}
