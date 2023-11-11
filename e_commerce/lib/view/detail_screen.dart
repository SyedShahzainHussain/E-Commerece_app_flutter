// ignore_for_file: must_be_immutable

import 'package:e_commerce/extension/mediaQuery/media_query.dart';
import 'package:e_commerce/extension/sizedBox_height/sizedbox.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dismissible_page/dismissible_page.dart';

class DetailScreen extends StatelessWidget {
  String id;

  DetailScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final loadedData = context.read<Products>().findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedData.title.toString()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: context.screenHeight * .3,
              width: context.screenWidth,
              child: GestureDetector(
                  onTap: () {
                    context.pushTransparentRoute(
                        SecondPage(imageUrl: loadedData.image!));
                  },
                  child: Image.network(loadedData.image!, fit: BoxFit.cover)),
            ),
            10.height,
            Text(
              '\$${loadedData.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            10.height,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedData.description!,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

@immutable
class SecondPage extends StatelessWidget {
  String imageUrl;
  SecondPage({super.key, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).pop();
      },
      // Note that scrollable widget inside DismissiblePage might limit the functionality
      // If scroll direction matches DismissiblePage direction
      direction: DismissiblePageDismissDirection.vertical,
      isFullScreen: false,
      child: Hero(
        tag: 'Unique tag',
        child: Image.network(
          imageUrl,
        ),
      ),
    );
  }
}
