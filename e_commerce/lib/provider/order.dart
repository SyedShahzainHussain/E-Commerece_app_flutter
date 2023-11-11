import 'dart:convert';

import 'package:e_commerce/constants/appUrl.dart';
import 'package:e_commerce/provider/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Order {
  String? id;
  DateTime? datetime;
  double? totalAmount;
  List<Cart>? cartList;
  Order({
    required this.id,
    required this.datetime,
    required this.totalAmount,
    required this.cartList,
  });

  Order.fromJson(String key, Map<String, dynamic> json) {
    id = key;
    datetime = DateTime.parse(json["dateTime"]);
    totalAmount = json["amount"];
    cartList = (json["products"] as List<dynamic>)
        .map((e) => Cart(
            id: e['id'],
            productId: e['productId'],
            title: e['title'],
            quantity: e['quantity'],
            price: e['price']))
        .toList();
  }
}

class OrderProvider with ChangeNotifier {
  List<Order> _orderList = [];

  List<Order> get order => [..._orderList];

  Future<void> getOrder() async {
    final response = await http.get(Uri.parse(AppUrl.addOrder));
    try {
      final List<Order> orderList = [];
      final extradedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (extradedData.isEmpty) {
        return;
      }
      extradedData.forEach((key, value) {
        orderList.add(Order.fromJson(key, value));
      });
      _orderList = orderList.reversed.toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    notifyListeners();
  }

  Future<void> addOrder(
    List<Cart> cart,
    double totalAmount,
  ) async {
    // ! add order
    final timestamp = DateTime.now();
    try {
      final response = await http.post(Uri.parse(AppUrl.addOrder),
          body: jsonEncode({
            'amount': totalAmount,
            'dateTime': timestamp.toIso8601String(),
            'products': cart
                .map((e) => {
                      'id': e.id,
                      'productId': e.productId,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price
                    })
                .toList()
          }));
      _orderList.insert(
        0,
        Order(
          id: jsonDecode(response.body)['name'],
          datetime: timestamp,
          totalAmount: totalAmount,
          cartList: cart,
        ),
      );
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }
}
