import 'package:e_commerce/extension/language/language.dart';
import 'package:e_commerce/extension/mediaQuery/media_query.dart';
import 'package:e_commerce/firebase/notifications-services/firebase_notification.dart';
import 'package:e_commerce/provider/cart.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/resources/components/drawer_components.dart';
import 'package:e_commerce/resources/components/product_screen.dart';
import 'package:e_commerce/view/cart_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseNotificationServices firebaseNotificationServices =
      FirebaseNotificationServices();
  late Future<void> _fetchData;
  @override
  void initState() {
    super.initState();

    _fetchData = Provider.of<Products>(context, listen: false).getProducts();
    firebaseNotificationServices.requestNotifiactionService();
    // firebaseNotificationServices.getDevicesToken().then((value) {});
    firebaseNotificationServices.FirebaseInIt(context);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<Products>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations!.shopApp),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) => Container(
              margin: EdgeInsets.only(right: context.screenWidth * .005),
              padding: const EdgeInsets.all(3.0),
              child: badges.Badge(
                showBadge: true,
                ignorePointer: false,
                onTap: () {},
                badgeContent: Text(cart.cartlength.toString()),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        reverseTransitionDuration:
                            const Duration(milliseconds: 500),
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const CartScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          Animation<Offset> slideAnimation =
                              Tween(begin: begin, end: end).animate(animation);
                          return SlideTransition(
                            position: slideAnimation,
                            child: child,
                          );
                        },
                      ));
                    },
                    icon: const Icon(Icons.shopping_cart)),
              ),
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder<void>(
          future: _fetchData,
          builder: (context, value) {
            if (value.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitFadingCircle(color: AppColors.deepPurple),
              );
            } else if (context.read<Products>().getProduct.isEmpty) {
              return Center(child: Text(context.localizations!.noProducts));
            } else if (value.hasError) {
              return Center(
                child: Text('Error: ${value.error}'),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: context.read<Products>().getProduct.length,
                  itemBuilder: (context, index) => ChangeNotifierProvider.value(
                    value: context.watch<Products>().getProduct[index],
                    child: const ProductScreen(),
                  ),
                ),
              );
            }
          }),
    );
  }
}
