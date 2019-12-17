class SearchSapRights {
  String id;
  String userid;
  String transType;
  String transTypeStr;
  String fromDate;
  String fromDateStr;
  String toDate;
  String toDateStr;
  String timeLimit;
  String timeLimitStr;
  String rights;
  String createdBy;
  String createdOn;
  String deletedBy;
  String deletedOn;

  

  SearchSapRights({
      this.id,
      this.userid,
      this.transType,
      this.transTypeStr,
      this.fromDate,
      this.fromDateStr,
      this.toDate,
      this.toDateStr,
      this.timeLimit,
      this.timeLimitStr,
      this.createdBy,
      this.createdOn,
      this.deletedBy,
      this.deletedOn,
      this.rights});

  factory SearchSapRights.fromJson(Map<String, dynamic> json) {
    return new SearchSapRights(

        id: json['id'].toString(),
        userid: json['userId'],
        transType: json['transType'].toString(),
        transTypeStr: json['transTypeStr'].toString(),
        fromDate: json['fromDate'].toString(),
        fromDateStr: json['fromDateStr'].toString(),
        toDate: json['toDate'].toString(),
        toDateStr: json['toDateStr'].toString(),
        timeLimit: json['timeLimit'].toString(),
        timeLimitStr: json['timeLimitStr'].toString(),
        createdBy: json['createdBy'],
        createdOn: json['createdOn'].toString(),
        deletedBy: json['deletedBy'].toString(),
        deletedOn: json['deletedOn'].toString(),
        rights: json['rights'].toString());
    
  }
}
