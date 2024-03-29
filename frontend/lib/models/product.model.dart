// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:frontend/models/rating.model.dart';

class ProductModel {
  final List<String> images;
  final String name;
  final String description;
  final int price;
  final int quantity;
  final String category;
  final List<RatingModel>? rating;
  String id;
  ProductModel({
    required this.images,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    this.rating,
    this.id = '',
  });

  ProductModel copyWith({
    List<String>? images,
    String? name,
    String? description,
    int? price,
    int? quantity,
    String? category,
    String? id,
  }) {
    return ProductModel(
      images: images ?? this.images,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'images': images,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'rating': rating,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      images: List<String>.from(map['images'] as List<dynamic>),
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as int,
      quantity: map['quantity'] as int,
      category: map['category'] as String,
      id: map['_id'] as String,
      rating: map['ratings'] != null
          ? List<RatingModel>.from(
              map['ratings']?.map(
                (x) => RatingModel.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(images: $images, name: $name, description: $description, price: $price, quantity: $quantity, category: $category, id: $id)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.images, images) &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.quantity == quantity &&
        other.category == category;
  }

  @override
  int get hashCode {
    return images.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        category.hashCode;
  }
}
