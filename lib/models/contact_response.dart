class ContactResponse {
  ContactResponse({
    required this.users,
    required this.id,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.profileImageUrl,
    required this.imageUrl,
  });

  final List<ContactResponse> users;
  final String? id;
  final DateTime? createdAt;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? imageUrl;

  ContactResponse copyWith({
    List<ContactResponse>? users,
    String? id,
    DateTime? createdAt,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    String? imageUrl,
  }) {
    return ContactResponse(
      users: users ?? this.users,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    return ContactResponse(
      users: json["users"] == null ? [] : List<ContactResponse>.from(json["users"]!.map((x) => ContactResponse.fromJson(x))),
      id: json["id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      firstName: json["firstName"],
      lastName: json["lastName"],
      phoneNumber: json["phoneNumber"],
      profileImageUrl: json["profileImageUrl"],
      imageUrl: json["imageUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "users": users.map((x) => x.toJson()).toList(),
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "profileImageUrl": profileImageUrl,
        "imageUrl": imageUrl,
      };

  @override
  String toString() {
    return "$users, $id, $createdAt, $firstName, $lastName, $phoneNumber, $profileImageUrl, $imageUrl, ";
  }
}
