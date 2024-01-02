import 'package:e_commerce/extension/language/language.dart';
import 'package:e_commerce/provider/order.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:e_commerce/provider/cart.dart';

import 'package:e_commerce/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<CartProvider>();
    final order = context.read<OrderProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations!.cart),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<CartProvider>(
              builder: (context, cart, child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${context.localizations!.totalAmount}:'),
                      FittedBox(
                          child:
                              Text(' ${cart.totalAmount.toStringAsFixed(2)}')),
                    ],
                  ),
                  const Spacer(),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent.shade400,
                            borderRadius: BorderRadius.circular(50)),
                        child: FittedBox(
                          child: Text(
                            '${context.localizations!.quantity}:- ${cart.cartlength.toString()}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: data.totalAmount <= 0
                        ? null
                        : () async {
                            data.setLoading(true);
                            await order
                                .addOrder(cart.getCart.values.toList(),
                                    cart.totalAmount)
                                .then((value) {
                              data.setLoading(false);
                            });
                            cart.clearCart();
                          },
                    child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent.shade400,
                            borderRadius: BorderRadius.circular(50)),
                        child: data.isLoading
                            ? Text(context.localizations!.sendOrder,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis))
                            : Text(
                                context.localizations!.orderNow,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              )),
                  )),
                ],
              ),
            ),
          )),
        ),
        data.getCart.isEmpty
            ? Center(child: Text(context.localizations!.nocart))
            : Center(
                child: Text(
                context.localizations!.products,
                style: const TextStyle(fontSize: 17),
              )),
        Consumer<CartProvider>(
          builder: (context, value, child) => Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final data = value.getCart.values.toList()[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Slidable(
                    key: ValueKey(data.productId),
                    endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        dismissible: DismissiblePane(
                            key: ValueKey(data.productId),
                            onDismissed: () {
                              value.deleteCart(data.productId);
                            }),
                        children: [
                          SlidableAction(
                              onPressed: (context) {
                                value.deleteCart(data.productId);
                              },
                              icon: Icons.delete,
                              flex: 1,
                              backgroundColor: AppColors.redColor,
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.circular(12.0))
                        ]),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: ListTile(
                        subtitle: Text('\$${data.price}'),
                        title: Text(
                          data.title.toString(),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                value.addToCart(
                                    data.productId, data.title, data.price);
                              },
                              child: Chip(
                                backgroundColor:
                                    AppColors.deepPurple.withOpacity(0.2),
                                label: const FaIcon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            FittedBox(child: Text(data.quantity.toString())),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                value.removeSingleCart(
                                    data.productId, data.title, data.price);
                              },
                              child: Chip(
                                backgroundColor:
                                    AppColors.deepPurple.withOpacity(0.2),
                                label: const FaIcon(FontAwesomeIcons.minus,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: value.getCart.length,
            ),
          ),
        )
      ]),
    );
  }
}
