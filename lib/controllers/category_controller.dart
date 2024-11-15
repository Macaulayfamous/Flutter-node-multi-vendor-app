
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mac_store_app/global_variable.dart';
import 'package:mac_store_app/models/category.dart';

class CategoryController {
  //load the uploaded category

  Future<List<Category>> loadCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      // print(response.body); // Print response body to check its structure

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((category) => Category.fromJson(category)).toList();
        return categories;
      } else if (response.statusCode == 404) {
        return [];
      }
       else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print(e);
      throw Exception('Error loading Categories: $e');
    }
  }
}
