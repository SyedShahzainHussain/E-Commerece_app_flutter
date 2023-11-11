import 'package:e_commerce/provider/order.dart';
import 'package:e_commerce/resources/components/orderItems.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
@override
  void initState() {
    super.initState();

  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final order = context.read<OrderProvider>();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
        ),
        body:  FutureBuilder(
              future: order.getOrder(),
              builder: (context,snapshot) {
                return ListView.builder(
                    itemBuilder: (context, index) {
                      final orders = order.order[index];
                      return OrderItems(orders: orders);
                    },
                    itemCount: order.order.length,
                  );
              }
            ));
  }
}
