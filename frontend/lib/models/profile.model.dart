// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProfileModel {
  final String username;
  final String email;
  final String address;
  final String type;
  ProfileModel({
    required this.username,
    required this.email,
    required this.address,
    required this.type,
  });

  ProfileModel copyWith({
    String? username,
    String? email,
    String? address,
    String? type,
  }) {
    return ProfileModel(
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'address': address,
      'type': type,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      username: map['username'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) => ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileModel(username: $username, email: $email, address: $address, type: $type)';
  }

  @override
  bool operator ==(covariant ProfileModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.username == username &&
      other.email == email &&
      other.address == address &&
      other.type == type;
  }

  @override
  int get hashCode {
    return username.hashCode ^
      email.hashCode ^
      address.hashCode ^
      type.hashCode;
  }
}
