import 'contact_response.dart';

class Contact {
  Contact({
    required this.success,
    required this.messages,
    required this.data,
    required this.status,
  });

  final bool? success;
  final List<String> messages;
  final Data? data;
  final int? status;

  Contact copyWith({
    bool? success,
    List<String>? messages,
    Data? data,
    int? status,
  }) {
    return Contact(
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      success: json["success"],
      messages: json["messages"] == null ? [] : List<String>.from(json["messages"]!.map((x) => x)),
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
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

class Data {
  Data({
    required this.users,
  });

  final List<ContactResponse> users;

  Data copyWith({
    List<ContactResponse>? users,
  }) {
    return Data(
      users: users ?? this.users,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      users: json["users"] == null ? [] : List<ContactResponse>.from(json["users"]!.map((x) => ContactResponse.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "users": users.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$users, ";
  }
}
