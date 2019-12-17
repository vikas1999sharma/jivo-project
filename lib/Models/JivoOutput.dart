class JivoOutput {
  final String currentOutstanding;
  final String currentOverDue;
  final String salesOrder;
  final String currentLimit;
  JivoOutput(this.currentOutstanding, this.currentOverDue, this.salesOrder ,this.currentLimit);

  JivoOutput.fromJson(Map<String, dynamic> json)
      : currentOutstanding = json['Outstanding'],
        currentOverDue = json['OverDue'],
        salesOrder=json['LastOpenOrder'], 
        currentLimit=json['CurrentLimit'];

  Map<String, dynamic> toJson() => {
        'Outstanding': currentOutstanding,
        'OverDue': currentOverDue,
        'LastOpenOrder':salesOrder,
        'CurrentLimit':currentLimit,
      };
}
