class PrimaryOrderItem
{  String docEntry;
   String createdBy;
   String createdOn;
   String canceled;
   String canceledDate;
   String updateDate;
   String status;
   String lineNum;
   String id;
   String itemCode;
   String itemName;
   String quantity;
   String boxQty;
   String uOM;
   String retSchemeQty;
   String itmRemarks;

 

   PrimaryOrderItem(
      this.docEntry,
      this.createdBy,
      this.createdOn,
      this.canceled,
      this.canceledDate,
      this.updateDate,
      this.status,
      this.lineNum,
      this.id,
      this.itemCode,
      this.itemName,
      this.quantity,
      this.boxQty,
      this.uOM,
      this.retSchemeQty,
      this.itmRemarks);

     
  PrimaryOrderItem.fromJson(Map<String, dynamic> json) 
     : docEntry= json['DocEntry'].toString(),
      createdBy= json['CreatedBy'].toString(),
      createdOn= json['CreatedOn'],
      canceled =json['Canceled'],
      canceledDate = json['CanceledDate'],
      updateDate = json['UpdateDate'],
      status = json['Status'],
      lineNum = json['LineNum'].toString(),
      id = json['id'].toString(),
      itemCode =json['ItemCode'],
      itemName = json['ItemName'],
      quantity = json['Quantity'].toString(),
      boxQty = json['BoxQty'].toString(),
      itmRemarks = json['ItmRemarks'],
      uOM = json['UOM'],
      retSchemeQty = json['RetSchemeQty'].toString();

       Map<String, dynamic> toJson() => {
         'DocEntry': docEntry,
      'CreatedBy': createdBy,
      'CreatedOn': createdOn,
      'Canceled': canceled,
      'CanceledDate': canceledDate,
      'UpdateDate': updateDate,
      'Status':status,
      'LineNum': lineNum,
      'id': id,
      'ItemCode': itemCode,
      'ItemName': itemName,
      'Quantity': quantity,
      'BoxQty': boxQty,
      'ItmRemarks': itmRemarks,
      'UOM': uOM,
      'RetSchemeQty': retSchemeQty,
      };
    
  
  
 
}