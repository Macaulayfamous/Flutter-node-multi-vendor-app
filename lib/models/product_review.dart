// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductReview {
  final String id;
  final String buyerId;
  final String email;
  final String fullName;
  final String productId;
  final double rating;
  final String review;

  ProductReview({required this.id, required this.buyerId, required this.email, required this.fullName, required this.productId, required this.rating, required this.review});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'buyerId': buyerId,
      'email': email,
      'fullName': fullName,
      'productId': productId,
      'rating': rating,
      'review': review,
    };
  }

  factory ProductReview.fromMap(Map<String, dynamic> map) {
    return ProductReview(
      id: map['_id'] as String,
      buyerId: map['buyerId'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      productId: map['productId'] as String,
      rating: map['rating'] as double,
      review: map['review'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductReview.fromJson(String source) => ProductReview.fromMap(json.decode(source) as Map<String, dynamic>);
}
