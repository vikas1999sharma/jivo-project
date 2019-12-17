class PartyDetailmodel {
  final String currentOutstanding;
  final String currentOverDue;
  final String salesOrder;
  final String currentLimit;
  PartyDetailmodel(this.currentOutstanding, this.currentOverDue, this.salesOrder,
      this.currentLimit);

  PartyDetailmodel.fromJson(Map<String, dynamic> json)
      : currentOutstanding = json['Outstanding'],
        currentOverDue = json['OverDue'],
        salesOrder = json['LastOpenOrder'],
        currentLimit = json['CurrentLimit'];

  Map<String, dynamic> toJson() => {
        'Outstanding': currentOutstanding,
        'OverDue': currentOverDue,
        'LastOpenOrder': salesOrder,
        'CurrentLimit': currentLimit,
      };
}
