class LoginApiResponse {
  CurrentUserData data;
  bool success;
  dynamic exception;
  int messageType;
  int count;
  String message;
  DateTime dateTime;

  LoginApiResponse({
    CurrentUserData? data,
    this.success = false,
    this.exception = "",
    this.messageType = 0,
    this.count = 0,
    this.message = '',
    DateTime? dateTime,
  })  : data = data ?? CurrentUserData(),
        dateTime = dateTime ?? DateTime.now();

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) {
    return LoginApiResponse(
      data: CurrentUserData.fromJson(json['data']),
      success: json['success'],
      exception: json['exception'],
      messageType: json['messageType'],
      count: json['count'],
      message: json['message'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'success': success,
        'exception': exception,
        'messageType': messageType,
        'count': count,
        'message': message,
        'dateTime': dateTime,
      };
}

class CurrentUserData {
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
  String expiredTime;

  CurrentUserData({
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
    this.expiredTime = '',
  });

  factory CurrentUserData.fromJson(Map<String, dynamic> json) {
    return CurrentUserData(
      token: json['token'],
      userName: json['userName'],
      territoryName: json['territoryName'],
      areaName: json['areaName'],
      depoName: json['depoName'],
      regionName: json['regionName'],
      employeeName: json['employeeName'],
      validity: json['validaty'],
      refreshToken: json['refreshToken'],
      id: json['id'],
      email: json['email'],
      clientId: json['clientId'],
      employeeId: json['employeeId'],
      territoryId: json['territoryId'],
      areaId: json['areaId'],
      depoId: json['depoId'],
      regionId: json['regionId'],
      guidId: json['guidId'],
      expiredTime: json['expiredTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'userName': userName,
        'territoryName': territoryName,
        'areaName': areaName,
        'depoName': depoName,
        'regionName': regionName,
        'employeeName': employeeName,
        'validaty': validity,
        'refreshToken': refreshToken,
        'id': id,
        'email': email,
        'clientId': clientId,
        'employeeId': employeeId,
        'territoryId': territoryId,
        'areaId': areaId,
        'depoId': depoId,
        'regionId': regionId,
        'guidId': guidId,
        'expiredTime': expiredTime,
      };
}
