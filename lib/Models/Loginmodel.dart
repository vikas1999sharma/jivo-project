class Loginmodel {
  final String userid;
  final String name;

  Loginmodel(this.userid, this.name);

  Loginmodel.fromJson(Map<String, dynamic> json)
      : userid = json['userId'],
        name = json['name'];

  Map<String, dynamic> toJson() => {'userId': userid, 'name': name};
}
