import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, Favorite>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Map<String, Favorite>> {
  FavoriteNotifier() : super({}) {
    _loadFavorites();
  }

  //A private method that loads items from sharedpreferences
  Future<void> _loadFavorites() async {
    //retrieving the sharepreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    //fetch the json string of the favorite items from sharedpreferences  under the key favorites
    final favoriteString = prefs.getString('favorites');
    //checking if the string is not null, meaning there is  saved data to load
    if (favoriteString != null) {
      //decode the json String into map of dynamic data
      final Map<String, dynamic> favoriteMap = jsonDecode(favoriteString);

      //covert the dynamic map  into a map of Favorite Object using the 'fromjson" factory method
      final favorites = favoriteMap
          .map((key, value) => MapEntry(key, Favorite.fromJson(value)));

      //updating the state with the loaded favorites
      state = favorites;
    }
  }

  //A private method that saves the current list of favorite items to sharedpreferences
  Future<void> _saveFavorites() async {
    //retrieving the sharepreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    //encoding the current state (Map of favorite object ) into json String
    final favoriteString = jsonEncode(state);
    //saving the json string to sharedpreferences with the key "favorites"
    await prefs.setString('favorites', favoriteString);
  }

  void addProductToFavorite({
    required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    state[productId] = Favorite(
        productName: productName,
        productPrice: productPrice,
        category: category,
        image: image,
        vendorId: vendorId,
        productQuantity: productQuantity,
        quantity: quantity,
        productId: productId,
        description: description,
        fullName: fullName);

    //notify listeners tha tthe state has changed
    state = {...state};
    _saveFavorites();
  }

  //Method to remove item from the cart
  void removeFavoriteItem(String productId) {
    state.remove(productId);
    //Notify Listerners that the state has changed

    state = {...state};
    _saveFavorites();
  }

  Map<String, Favorite> get getFavoriteItems => state;
}
