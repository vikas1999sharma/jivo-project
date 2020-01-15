  
class SalesOverView
{
   double pieces;
   double quantity;
   double value;
  SalesOverView({this.quantity,this.pieces,this.value });
  factory SalesOverView.fromJson(Map<String, dynamic> json) {
    return SalesOverView(
      pieces: json['pieces'],
      quantity: json['quantity'],
      value: json['value'],
    );

  }

  Map<String, dynamic> toJson() => {
        'pieces': pieces,
        'quantity': quantity,
        'value': value,
        
      };
       

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["pieces"] = pieces;
    map["quantity"] = quantity;
    map["value"] = value;
   
    return map;
  }
}

