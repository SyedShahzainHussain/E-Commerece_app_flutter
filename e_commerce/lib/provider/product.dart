import 'dart:convert';

import 'package:e_commerce/constants/appUrl.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/utils..dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String? id;
  String? title;
  String? description;
  double? price;
  String? image;
  bool? isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.isFavorite = false,
  });

  Product.fromJson(String key, Map<String, dynamic> json) {
    id = key;
    title = json['title'];
    description = json['description'];
    price = json['price'];
    image = json['imageUrl'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map<String, dynamic>();
    json['title'] = title;
    json['description'] = description;
    json['price'] = price;
    json['imageUrl'] = image;
    json['isFavorite'] = isFavorite;
    return json;
  }

  void toggleFavorite() async {
    final oldFavorite = isFavorite;
    isFavorite = !isFavorite!;
    notifyListeners();
    try {
      final response = await http.patch(
          Uri.parse('${AppUrl.baseUrl}/products/$id.json'),
          body: jsonEncode({"isFavorite": isFavorite}));
      if (response.statusCode > 400) {
        isFavorite = oldFavorite;
        notifyListeners();
      }
    } catch (e) {
            isFavorite = oldFavorite;
        notifyListeners();
      Utils.showToast(AppColors.deepPurple, Colors.white, e.toString());
    }
  }
}
