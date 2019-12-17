class TransType {

  final String id;
  final String transName;
  bool isSelected;

  TransType({this.id, this.transName,this.isSelected});

   factory TransType.fromJson(Map<String, dynamic> json) {
      return new TransType(
         id: json['id'],
         transName: json['Name'].toString(),
         isSelected: false
      );
   }
}