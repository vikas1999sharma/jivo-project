
class Limit {
  final String cardCode;
  final double currentLimit;
  final int createdBy;
  final double newLimit;
  final String validTill;

  Limit({this.cardCode, this.currentLimit, this.newLimit, this.validTill,this.createdBy});

  factory Limit.fromJson(Map<String, dynamic> json) {
    return Limit(
      cardCode: json['CardCode'],
      currentLimit: json['CurrentLimit'],
      newLimit: json['NewLimit'],
      validTill: json['ValidTill'],
      createdBy:json['createdBy']
    );
  }

  Map<String, dynamic> toJson() => {
        'CardCode': cardCode,
        'CurrentLimit': currentLimit,
        'NewLimit': newLimit,
        'ValidTill': validTill,
        'createdBy':createdBy,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["CardCode"] = cardCode;
    map["CurrentLimit"] = currentLimit;
    map["NewLimit"] = newLimit;
    map["createdBy"]=createdBy;
    map["ValidTill"] = validTill;
    return map;
  }
}
