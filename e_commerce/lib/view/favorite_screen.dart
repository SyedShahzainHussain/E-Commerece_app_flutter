import 'package:e_commerce/extension/language/language.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:e_commerce/resources/components/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<Products>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations!.favorites),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: provider.favoritesItem.isEmpty
            ? Center(
                child: Text(
                context.localizations!.nofavorites,
              ))
            : GridView.builder(
                itemCount: provider.favoritesItem.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
                itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  value: provider.favoritesItem[index],
                  child: ProductScreen(),
                ),
              ),
      ),
    );
  }
}
