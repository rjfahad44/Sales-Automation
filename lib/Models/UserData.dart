
class UserData {
  String token;
  String userName;
  String territoryName;
  String areaName;
  String depoName;
  String regionName;
  String employeeName;
  String validity;
  String refreshToken;
  int id;
  String email;
  int clientId;
  int employeeId;
  int territoryId;
  int areaId;
  int depoId;
  int regionId;
  String guidId;
  DateTime expiredTime;

  UserData({
    this.token = '',
    this.userName = '',
    this.territoryName = '',
    this.areaName = '',
    this.depoName = '',
    this.regionName = '',
    this.employeeName = '',
    this.validity = '',
    this.refreshToken = '',
    this.id = 0,
    this.email = '',
    this.clientId = 0,
    this.employeeId = 0,
    this.territoryId = 0,
    this.areaId = 0,
    this.depoId = 0,
    this.regionId = 0,
    this.guidId = '',
    DateTime? expiredTime,
  }) : expiredTime = expiredTime ?? DateTime.now();

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    token: json['data']['token'] as String,
    userName: json['data']['userName'] as String,
    territoryName: json['data']['territoryName'] as String,
    areaName: json['data']['areaName'] as String,
    depoName: json['data']['depoName'] as String,
    regionName: json['data']['regionName'] as String,
    employeeName: json['data']['employeeName'] as String,
    validity: json['data']['validaty'] as String,
    refreshToken: json['data']['refreshToken'] as String,
    id: json['data']['id'] as int,
    email: json['data']['email'] as String,
    clientId: json['data']['clientId'] as int,
    employeeId: json['data']['employeeId'] as int,
    territoryId: json['data']['territoryId'] as int,
    areaId: json['data']['areaId'] as int,
    depoId: json['data']['depoId'] as int,
    regionId: json['data']['regionId'] as int,
    guidId: json['data']['guidId'] as String,
    expiredTime: DateTime.parse(json['data']['expiredTime'] as String),
  );
}
