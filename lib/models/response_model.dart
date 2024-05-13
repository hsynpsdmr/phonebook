import 'contact_response.dart';

class ResponseModel {
  ResponseModel({
    required this.success,
    required this.messages,
    required this.data,
    required this.status,
  });

  final bool? success;
  final List<String> messages;
  final ContactResponse? data;
  final int? status;

  ResponseModel copyWith({
    bool? success,
    List<String>? messages,
    ContactResponse? data,
    int? status,
  }) {
    return ResponseModel(
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      success: json["success"],
      messages: json["messages"] == null ? [] : List<String>.from(json["messages"]!.map((x) => x)),
      data: json["data"] == null ? null : ContactResponse.fromJson(json["data"]),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "messages": messages.map((x) => x).toList(),
        "data": data?.toJson(),
        "status": status,
      };

  @override
  String toString() {
    return "$success, $messages, $data, $status, ";
  }
}
