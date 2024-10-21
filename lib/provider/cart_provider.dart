import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Define a  StateNotifierProvider to expose an instance of the CartNofier
//Making it accessible within our app
final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});

//A notifier class to manage the cart state, extending stateNotifier
//with an inital state of an empty map
class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({}) {
    _loadCartItems();
  }

  //A private method that loads items from sharedpreferences
  Future<void> _loadCartItems() async {
    //retrieving the sharepreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    //fetch the json string of the favorite items from sharedpreferences  under the key favorites
    final cartString = prefs.getString('cart_items');
    //checking if the string is not null, meaning there is  saved data to load
    if (cartString != null) {
      //decode the json String into map of dynamic data
      final Map<String, dynamic> cartMap = jsonDecode(cartString);

      //covert the dynamic map  into a map of Favorite Object using the 'fromjson" factory method
      final cartItems =
          cartMap.map((key, value) => MapEntry(key, Cart.fromJson(value)));

      //updating the state with the loaded favorites
      state = cartItems;
    }
  }

//A private method that saves the current list of favorite items to sharedpreferences
  Future<void> _saveCartItems() async {
    //retrieving the sharepreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    //encoding the current state (Map of favorite object ) into json String
    final cartString = jsonEncode(state);
    //saving the json string to sharedpreferences with the key "favorites"
    await prefs.setString('cart_items', cartString);
  }

  //Method to add product to the cart
  void addProductToCart({
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
    //check if the product is already in the cart
    if (state.containsKey(productId)) {
      //if the product is already in the cart, update its quantity and maybe other detail
      state = {
        ...state,
        productId: Cart(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          category: state[productId]!.category,
          image: state[productId]!.image,
          vendorId: state[productId]!.vendorId,
          productQuantity: state[productId]!.productQuantity,
          quantity: state[productId]!.quantity + 1,
          productId: state[productId]!.productId,
          description: state[productId]!.description,
          fullName: state[productId]!.fullName,
        )
      };
      _saveCartItems();
    } else {
      // if the product is not in the cart, add it with the provied  details
      state = {
        ...state,
        productId: Cart(
            productName: productName,
            productPrice: productPrice,
            category: category,
            image: image,
            vendorId: vendorId,
            productQuantity: productQuantity,
            quantity: quantity,
            productId: productId,
            description: description,
            fullName: fullName)
      };

      _saveCartItems();
    }
  }

//Method to increment the quantity   of a product  in the cart
  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      //Notify listeners that the state  has changed
      state = {...state};
      _saveCartItems();
    }
  }

  //Method to decrement the quantity of a product in the cart
  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      //Notify listerners that the state has changed
      state = {...state};
      _saveCartItems();
    }
  }

  //Method to remove item from the cart
  void removeCartItem(String productId) {
    state.remove(productId);
    //Notify Listerners that the state has changed

    state = {...state};
    _saveCartItems();
  }

  //Method to calculate total amount of items we have in cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });

    return totalAmount;
  }

  Map<String, Cart> get getCartItems => state;
}
