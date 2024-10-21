// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  final String id;
  final String productName;
  final int productPrice;
  final int quantity;
  final String description;
  final String category;
  final String vendorId;
  final String fullName;
  final String subCategory;
  final List<String> images;
  final double averageRating;
  final int totalRatings;

  Product(
      {required this.id,
      required this.productName,
      required this.productPrice,
      required this.quantity,
      required this.description,
      required this.category,
      required this.vendorId,
      required this.fullName,
      required this.subCategory,
      required this.images,
      required this.averageRating,
      required this.totalRatings});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'description': description,
      'category': category,
      'vendorId': vendorId,
      'fullName': fullName,
      'subCategory': subCategory,
      'images': images,
      'averageRating': averageRating,
      'totalRatings': totalRatings
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] as String,
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as int,
      quantity: map['quantity'] as int,
      description: map['description'] as String,
      category: map['category'] as String,
      vendorId: map['vendorId'] as String,
      fullName: map['fullName'] as String,
      subCategory: map['subCategory'] as String,
      images: List<String>.from(
        (map['images'] as List<dynamic>),
      ),
      averageRating: (map['averageRating'] is int
          ? (map['averageRating'] as int).toDouble()
          : map['averageRating'] as double),
      totalRatings: map['totalRatings'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
