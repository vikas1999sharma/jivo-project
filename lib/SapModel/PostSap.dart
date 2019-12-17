class PostSap {
  final int sapid;
  final String userId;
  final List<String> transType;
  final String fromDate;
  final String fromDateStr;
  final String transTypeStr;
  final String toDate;
  final String toDateStr;
  final String timeLimit;
  final String timeLimitStr;
  final String branch;
  final String createdBy;
  final String rights;
  final String createdOn;
  final String deletedOn;
  final String deletedBy;

  PostSap(
      {this.sapid,
      this.userId,
      this.transTypeStr,
      this.transType,
      this.fromDate,
      this.fromDateStr,
      this.createdBy,
      this.rights,
      this.branch,
      this.timeLimit,
      this.timeLimitStr,
      this.toDateStr,
      this.createdOn,
      this.deletedOn,
      this.deletedBy,
      this.toDate});

  factory PostSap.fromJson(Map<String, dynamic> json) {
    return PostSap(
      sapid: json['id'],
      userId: json['userId'],
      transType: json['transType'],
      transTypeStr: json['transTypeStr'],
      fromDate: json['fromDate'],
      fromDateStr: json['fromDateStr'],
      createdBy: json['createdBy'],
      timeLimit: json['timeLimit'],
      timeLimitStr: json['timeLimitStr'],
      branch: json['branch'],
      toDate: json['toDate'],
      toDateStr: json['toDateStr'],
      rights: json['rights'],
      createdOn: json['createdOn'],
      deletedOn: json['deletedOn'],
      deletedBy: json['deletedBy'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': sapid,
        'userId': userId,
        'transType': transType,
        'transTypeStr': transTypeStr,
        'fromDate': fromDate,
        'fromDateStr': fromDateStr,
        'createdBy': createdBy,
        'timeLimit': timeLimit,
        'timeLimitStr': timeLimitStr,
        'rights': rights,
        'createdOn': createdOn,
        'deletedOn': deletedOn,
        'deletedBy': deletedBy,
        'branch': branch,
        'toDate': toDate,
        'toDateStr': toDateStr,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = sapid;
    map["userId"] = userId;
    map["transType"] = transType;
    map["transTypeStr"] = transTypeStr;
    map["createdBy"] = createdBy;
    map["fromDate"] = fromDate;
    map["fromDateStr"] = fromDateStr;
    map["timeLimit"] = timeLimit;
    map["timeLimitStr"] = timeLimitStr;
    map["branch"] = branch;
    map["createdOn"] = createdOn;
    map["rights"] = rights;
    map["toDate"] = toDate;
    map["deletedOn"] = deletedOn;
    map["deletedBy"] = deletedBy;
    map["toDateStr"] = toDateStr;
    return map;
  }
}
