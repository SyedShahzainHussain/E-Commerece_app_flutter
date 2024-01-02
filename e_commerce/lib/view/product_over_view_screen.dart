// import 'dart:io';

import 'package:e_commerce/admin/drawer_components.dart';
import 'package:e_commerce/extension/language/language.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:e_commerce/view/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prdouct = context.watch<Products>();
    return Scaffold(
      drawer: const AdminDrawerComponents(),
      appBar: AppBar(
        title: const Text("Product Overview"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditScreen(
                              context: context,
                            )));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: prdouct.getProduct.isEmpty
          ? Center(
              child: Text(context.localizations!.noProducts),
            )
          : RefreshIndicator(
              onRefresh: () => prdouct.getProducts(),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final data = prdouct.getProduct[index];
                  return Card(
                    child: ListTile(
                      title: Text(data.title!),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data.image!),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RouteName.editScreen,
                                      arguments: data.id);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                )),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content:
                                                const Text("Are You Sure?"),
                                            actions: [
                                              FilledButton.tonal(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: const Text('Yes')),
                                              FilledButton.tonal(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: const Text('No')),
                                            ],
                                          )).then((value) {
                                    if (value == true) {
                                      prdouct.deleteProducts(data.id!);
                                    }
                                  });
                                },
                                icon: const Icon(Icons.delete,
                                    color: AppColors.redColor)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: prdouct.getProduct.length,
              ),
            ),
    );
  }
}
