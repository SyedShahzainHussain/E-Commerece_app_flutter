import 'dart:convert';

import 'package:e_commerce/constants/appUrl.dart';
import 'package:e_commerce/provider/product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   image:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   image:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   image: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   image:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get getProduct {
    return [..._products];
  }

  void toggleFavorite(String productId) {
    final productIndex =
        _products.indexWhere((product) => product.id == productId);
    if (productIndex >= 0) {
      _products[productIndex].toggleFavorite();
      notifyListeners(); // Notify listeners when the state changes
    }
  }

  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favoritesItem {
    return _products.where((element) => element.isFavorite!).toList();
  }

  // void showFavorite() {
  //   _isshowFavorite = true;
  //   notifyListeners();
  // }

  // void hideFavorite() {
  //   _isshowFavorite = false;
  //   notifyListeners();
  // }
//! getProduct
  Future<void> getProducts() async {
    try {
      final response = await http.get(Uri.parse(AppUrl.getProduct));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data.isEmpty) {
        return;
      }
      final List<Product> loadedProducts = [];
      data.forEach((key, value) {
        loadedProducts.add(Product.fromJson(key, value));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

//!add products
  Future<void> addProduct(Product newProduct) async {
    try {
      final response = await http.post(Uri.parse(AppUrl.addProduct),
          body: jsonEncode(newProduct.toJson()));
      _products.add(Product(
        id: jsonDecode(response.body)['name'],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        image: newProduct.image,
      ));
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }

//! edit product
  Future<void> editProducts(Product newProduct, String id) async {
    final productIndex = _products.indexWhere((element) => element.id == id);

    if (productIndex >= 0) {
      await http.patch(
        Uri.parse('${AppUrl.baseUrl}/products/$id.json'),
        body: jsonEncode(
          newProduct.toJson(),
        ),
      );

      _products[productIndex] = newProduct;
      notifyListeners();
    } else {
      if (kDebugMode) {
        print("error");
      }
    }
  }
  //! deleted product

  void deleteProducts(String id) async {
    await http.delete(Uri.parse('${AppUrl.baseUrl}/products/$id.json'));
    _products.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
