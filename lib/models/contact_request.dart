class ContactRequest {
  ContactRequest({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.profileImageUrl,
  });

  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profileImageUrl;

  ContactRequest copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) {
    return ContactRequest(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  factory ContactRequest.fromJson(Map<String, dynamic> json) {
    return ContactRequest(
      firstName: json["firstName"],
      lastName: json["lastName"],
      phoneNumber: json["phoneNumber"],
      profileImageUrl: json["profileImageUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "profileImageUrl": profileImageUrl,
      };

  @override
  String toString() {
    return "$firstName, $lastName, $phoneNumber, $profileImageUrl, ";
  }
}
