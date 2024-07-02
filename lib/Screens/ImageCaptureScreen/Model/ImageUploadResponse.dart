
class ImageUploadResponse {
  final int id;
  final int doctorId;
  final int employeeId;
  final String doctorName;
  final String? productName;
  final String? imageName;
  final String imageUrl;
  final String? imageFile;
  final String? message;

  ImageUploadResponse({
    this.id = 0,
    this.doctorId = 0,
    this.employeeId = 0,
     this.doctorName = "",
    this.productName = "",
    this.imageName = "",
     this.imageUrl = "",
    this.imageFile = "",
    this.message = "",
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      id: json['id'] ?? 0,
      doctorId: json['doctorId'] ?? 0,
      employeeId: json['employeeId'] ?? 0,
      doctorName: json['doctorName'] ?? '',
      productName: json['productName'] ?? '',
      imageName: json['imageName'] ?? '',
      imageUrl: json['imageUrl']?? '',
      imageFile: json['imageFile'] ?? '',
      message: json['message'] ?? "Error!!",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'employeeId': employeeId,
      'doctorName': doctorName,
      'productName': productName,
      'imageName': imageName,
      'imageUrl': imageUrl,
      'imageFile': imageFile,
      'message': message,
    };
  }
}
