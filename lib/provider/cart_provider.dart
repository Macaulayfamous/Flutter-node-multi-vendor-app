import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/cart.dart';

//A notifier class to manage the cart state, extending stateNotifier
//with an inital state of an empty map
class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({});

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
    } else {
      // if the product is not in the cart, add it with the provied  details
      state = {
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
    }
  }

//Method to increment the quantity   of a product  in the cart
  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      //Notify listeners that the state  has changed
      state = {...state};
    }
  }

  //Method to decrement the quantity of a product in the cart
  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      //Nofify listerners that the state has changed
      state = {...state};
    }
  }
}
