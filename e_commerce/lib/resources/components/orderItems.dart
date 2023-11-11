import 'dart:math';

import 'package:e_commerce/provider/order.dart' as ord;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItems extends StatefulWidget {
  final ord.Order orders;
  const OrderItems({
    super.key,
    required this.orders,
  });

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.orders.totalAmount.toString()),
            subtitle:
                Text(DateFormat('dd/MM/yyyy').format(widget.orders.datetime!)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              icon: Icon(
                isExpanded ? Icons.expand_more : Icons.expand_less,
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.orders.cartList!.length * 20.0 + 10, 100),
              child: ListView.builder(
                reverse: true,
                itemCount: widget.orders.cartList!.length,
                itemBuilder: (ctx, index) {
                  final prod = widget.orders.cartList![index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        prod.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${prod.quantity}x \$${prod.price}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
