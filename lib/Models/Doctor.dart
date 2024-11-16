

class Doctor {
  int id;
  String doctorName;
  String doctorCode;
  String degree;
  String className;
  String specialtyName;

  Doctor({
    this.id = 0,
    this.doctorName = '',
    this.doctorCode = '',
    this.degree = '',
    this.className = '',
    this.specialtyName = '',
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json["id"],
    doctorName: json["doctorName"],
    doctorCode: json["doctorCode"],
    degree: json["degree"],
    className: json["className"],
    specialtyName: json["specialtyName"],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctorName': doctorName,
    'doctorCode': doctorCode,
    'degree': degree,
    'className': className,
    'specialtyName': specialtyName,
  };
}
