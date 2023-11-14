import 'package:e_commerce/provider/cart.dart';
import 'package:e_commerce/provider/product.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/utils..dart';
import 'package:e_commerce/view/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class ProductScreen extends StatelessWidget {
  const ProductScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<Product>();
    final cart = context.read<CartProvider>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
              onPressed: () {
                cart.addToCart(provider.id!, provider.title!, provider.price!);

                Utils.showToast(
                    AppColors.deepPurple, Colors.white, "Added to cart");
              },
              icon: const Icon(Icons.shopping_cart)),
          title: Text(provider.title!),
          trailing: Consumer<Product>(
            builder: (context, value, child) => IconButton(
                onPressed: () {
                  value.toggleFavorite();
                },
                icon: Icon(
                  provider.isFavorite!
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: AppColors.redColor,
                )),
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      DetailScreen(id: provider.id!),
                  reverseTransitionDuration: const  Duration(milliseconds: 500),
                  transitionDuration:  const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animations, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    Animation<Offset> animation =
                        Tween(begin: begin, end: end).animate(animations);
                    return SlideTransition(
                      position: animation,
                      child: child,
                    );
                  },
                ));
          },
          child: Image.network(
            provider.image.toString(),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.error,
                color: AppColors.redColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
