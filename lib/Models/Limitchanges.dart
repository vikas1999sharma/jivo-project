
class Limitchanges {
  final String cardCode;
  final String cardName;

  final int timesChanged;
  final double newLimit;
  final String lastCreatedOn;

  Limitchanges({this.cardCode, this.cardName,this.newLimit, this.lastCreatedOn,this.timesChanged});

  factory Limitchanges.fromJson(Map<String, dynamic> json) {
    return Limitchanges(
      cardCode: json['cardCode'].toString(),
      cardName: json['cardName'].toString(),
      newLimit: json['newLimit'],
      timesChanged: json['timesChanged'],
      lastCreatedOn:json['lastCreatedOn'].toString()
    );
  }

  Map<String, dynamic> toJson() => {
        'cardCode': cardCode,
        'cardName': cardName,
        'NewLimit': newLimit,
        'lastCreatedOn': lastCreatedOn,
        'timesChanged':timesChanged,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["cardCode"] = cardCode;
    map["cardName"] = cardName;
    map["NewLimit"] = newLimit;
    map["timesChanged"]=timesChanged;
    map["lastCreatedOn"] = lastCreatedOn;
    return map;
  }
}
