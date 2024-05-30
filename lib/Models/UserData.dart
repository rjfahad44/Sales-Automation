
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
    token: json['data']['token'],
    userName: json['data']['userName'],
    territoryName: json['data']['territoryName'],
    areaName: json['data']['areaName'],
    depoName: json['data']['depoName'],
    regionName: json['data']['regionName'],
    employeeName: json['data']['employeeName'],
    validity: json['data']['validaty'],
    refreshToken: json['data']['refreshToken'],
    id: json['data']['id'],
    email: json['data']['email'],
    clientId: json['data']['clientId'],
    employeeId: json['data']['employeeId'],
    territoryId: json['data']['territoryId'],
    areaId: json['data']['areaId'],
    depoId: json['data']['depoId'],
    regionId: json['data']['regionId'],
    guidId: json['data']['guidId'],
    expiredTime: DateTime.parse(json['data']['expiredTime']),
  );

  Map<String, dynamic> toJson() => {
      'id': id,
      'clientId': clientId,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'depoName': depoName,
      'regionName': regionName,
      'territoryName': territoryName,
      'areaName': areaName,
      'areaId': areaId,
      'territoryId': territoryId,
      'regionId': regionId,
      'depoId': depoId,
      'userName': userName,
      'token': token,
      'validity': validity,
      'refreshToken': refreshToken,
      'email': email,
      'guidId': guidId,
      'expiredTime': expiredTime,
    };
}
