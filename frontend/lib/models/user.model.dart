// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String? username;
  final String email;
  final String password;
  final String? address;
  final String? type;
  final List<dynamic> cart;
  UserModel({
    this.id = '',
    this.username,
    required this.email,
    required this.password,
    required this.cart,
    this.address,
    this.type,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? address,
    String? type,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      cart: cart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'cart': cart,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      address: map['address'] as String,
      type: map['type'] as String,
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(username: $username, email: $email, password: $password, address: $address, type: $type)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.email == email &&
        other.password == password &&
        other.address == address &&
        other.type == type;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        email.hashCode ^
        password.hashCode ^
        address.hashCode ^
        type.hashCode;
  }
}
