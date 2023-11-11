import 'package:flutter/material.dart';

class Cart {
  final String id, productId, title;
  final int quantity;
  final double price;

  Cart({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class CartProvider with ChangeNotifier {
    bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
   Map<String, Cart> _cart = {};

  Map<String, Cart> get getCart => {..._cart};

  void addToCart(String productId, String title, double price) {
    if (_cart.containsKey(productId)) {
      //! update the cart
      _cart.update(
        productId,
        (existingValue) => Cart(
          id: existingValue.id,
          productId: existingValue.productId,
          title: title,
          quantity: existingValue.quantity + 1,
          price: price,
        ),
      );
    } else {
      // ! add to the cart
      _cart.putIfAbsent(
        productId,
        () => Cart(
          id: DateTime.now().toString(),
          productId: productId,
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  int get cartlength {
    //! cartlength
    var cart = 0;
    _cart.forEach((key, value) {
      cart += value.quantity;
    });
    return cart;
  }

  double get totalAmount {
    // ! totalAmount
    var total = 0.0;
    _cart.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void removeSingleCart(String productId, String title, double price) {
    if (_cart.containsKey(productId)) {
      // ! single Update
      if (_cart[productId]!.quantity > 1) {
        _cart.update(
            productId,
            (existingValue) => Cart(
                id: DateTime.now().toString(),
                productId: productId,
                title: title,
                quantity: existingValue.quantity - 1,
                price: price));
      } else {
        // ! single remove product
        _cart.remove(productId);
      }
    }

    notifyListeners();
  }

  void deleteCart(String productId) {
    // ! remove product
    _cart.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cart = {};
    notifyListeners();
  }
}
