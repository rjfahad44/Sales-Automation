

class ChemistDropdownResponse {
  ChemistModel data;
  bool success;
  dynamic exception;
  int messageType;
  int count;
  String message;
  DateTime dateTime;

  ChemistDropdownResponse({
    ChemistModel? data,
    this.success = false,
    this.exception = "",
    this.messageType = 0,
    this.count = 0,
    this.message = '',
    DateTime? dateTime,
  })  : data = data ?? ChemistModel(),
        dateTime = dateTime ?? DateTime.now();

  factory ChemistDropdownResponse.fromJson(Map<String, dynamic> json) {
    return ChemistDropdownResponse(
      data: ChemistModel.fromJson(json['data']),
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

class ChemistModel {
  String chemistCode;
  String chemistID;
  String name;
  String address;
  String? contactPerson;
  String contactNo;
  String? city;

  ChemistModel({
    this.chemistCode = '',
    this.chemistID = '',
    this.name = '',
    this.address = '',
    this.contactPerson = '',
    this.contactNo = '',
    this.city = '',
  });

  factory ChemistModel.fromJson(Map<String, dynamic> json) {
    return ChemistModel(
      chemistCode: json['chemistCode'] ?? '',
      chemistID: json['chemistID'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      contactPerson: json['contactPerson'],
      contactNo: json['contactNo'] ?? '',
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chemistCode': chemistCode,
      'chemistID': chemistID,
      'name': name,
      'address': address,
      'contactPerson': contactPerson,
      'contactNo': contactNo,
      'city': city,
    };
  }
}
