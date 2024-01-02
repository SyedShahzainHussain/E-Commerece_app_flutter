import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/extension/mediaQuery/media_query.dart';
import 'package:e_commerce/extension/sizedBox_height/sizedbox.dart';
import 'package:e_commerce/firebase/notifications-services/firebase_notification.dart';
import 'package:e_commerce/provider/product.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/utils..dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  String? id;
  BuildContext? context;
  EditScreen({super.key, this.id, this.context});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  FirebaseNotificationServices firebaseNotificationServices =
      FirebaseNotificationServices();
  final _titleNode = FocusNode();
  final _amountNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrl = FocusNode();
  final TextEditingController imageUrl = TextEditingController();
  final form = GlobalKey<FormState>();
  var editedProduct =
      Product(id: null, title: '', description: '', price: 0, image: '');

  @override
  void dispose() {
    _titleNode.dispose();
    _amountNode.dispose();
    _descriptionNode.dispose();
    _imageUrl.dispose();
    imageUrl.dispose();
    check();
    super.dispose();
  }

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  bool _isint = true;
  String? deviceToken;
  @override
  void didChangeDependencies() {
    if (_isint) {
      check();
    }
    _isint = false;
    super.didChangeDependencies();
  }

  void check() {
    if (widget.id != null) {
      // !edit product
      editedProduct = context.read<Products>().findById(widget.id ?? '');
      _initValues = {
        'title': editedProduct.title!,
        'description': editedProduct.description!,
        'price': editedProduct.price.toString(),
        'imageUrl': '',
      };
      imageUrl.text = editedProduct.image.toString();
    }
  }

  @override
  void initState() {
    _imageUrl.addListener(() {
      if (!_imageUrl.hasFocus) {
        setState(() {});
      }
    });
    super.initState();
  }

  void saveData() async {
    final validate = form.currentState!.validate();
    if (!validate) {
      return;
    }
    form.currentState!.save();
    context.read<Products>().setLoading(true);
    if (editedProduct.id != null) {
      // ! editedProduct.
      try {
        await context
            .read<Products>()
            .editProducts(editedProduct, editedProduct.id!)
            .then((value) {
          context.read<Products>().setLoading(false);
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        context.read<Products>().setLoading(false);
        Utils.showToast(AppColors.deepPurple, Colors.white, e.toString());
      }
    } else {
      // !addProducts
      try {
        await context
            .read<Products>()
            .addProduct(editedProduct)
            .then((value) async {
          final datas =
              await FirebaseFirestore.instance.collection('user').get();
          for (var element in datas.docs) {
            deviceToken = element['token'];
          }
          final data = {
            'to': deviceToken,
            'notification': {
              'title': 'E-Commerce',
              'body': 'Products Added',
              'sound': 'android_app_src_main_res_raw_jetsons_doorbell',
              'image': editedProduct.image
            },
          };
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              body: jsonEncode(data),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    'key=AAAAu1OOfrU:APA91bGMeERdHxCvMW-HNIAf5Aiv78NOCx4QgGAP_ahccjfGLwWMN84-9372bBtpDe2BG9CF01mxa0nqtqEKD63Bt1PN7tC-NQJOkvudf4Ov7raUDDATBCjmIr8LHCHCzh-H2ALfylZO'
              }).then((value) {
            context.read<Products>().setLoading(false);
          });
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        context.read<Products>().setLoading(false);
        Utils.showToast(AppColors.deepPurple, Colors.white, e.toString());
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  final _controller = DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.platformBrightnessOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              saveData();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: context.watch<Products>().isLoading,
        progressIndicator: const SpinKitFadingCircle(
          color: AppColors.deepPurple,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: form,
            child: SingleChildScrollView(
                child: Column(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  onSaved: (newValue) {
                    editedProduct = Product(
                      id: editedProduct.id,
                      title: newValue!,
                      description: editedProduct.description,
                      price: editedProduct.price,
                      image: editedProduct.image,
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_amountNode),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                10.height,
                TextFormField(
                  initialValue: _initValues['price'],
                  onSaved: (newValue) {
                    editedProduct = Product(
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: editedProduct.description,
                      price: double.parse(newValue!),
                      image: editedProduct.image,
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a amount";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a correct amount";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_descriptionNode),
                  keyboardType: TextInputType.number,
                  focusNode: _amountNode,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                10.height,
                TextFormField(
                  initialValue: _initValues['description'],
                  onSaved: (newValue) {
                    editedProduct = Product(
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: newValue!,
                      price: editedProduct.price,
                      image: editedProduct.image,
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a description";
                    }
                    if (value.length <= 5) {
                      return "Please enter a description at least 5 characters";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_imageUrl),
                  keyboardType: TextInputType.text,
                  focusNode: _descriptionNode,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                10.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: context.screenWidth * .3,
                      height: context.screenHeight * .15,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        width: 2,
                      )),
                      child: imageUrl.text.isEmpty
                          ? const Center(
                              child: Text("No Image"),
                            )
                          : Image.network(imageUrl.text.toString()),
                    ),
                    10.width,
                    Expanded(
                      child: TextFormField(
                        onFieldSubmitted: (value) => saveData(),
                        onSaved: (newValue) {
                          editedProduct = Product(
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            price: editedProduct.price,
                            image: newValue!,
                          );
                        },
                        controller: imageUrl,
                        keyboardType: TextInputType.url,
                        focusNode: _imageUrl,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: "Image URl",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Builder(builder: (BuildContext scaffoldContext) {
                //   return IconButton.filledTonal(
                //       onPressed: () {
                //         showModalBottomSheet(
                //           context: scaffoldContext,
                //           backgroundColor: brightness == Brightness.dark
                //               ? Colors.white
                //               : Colors.black,
                //           builder: (context) => SizedBox(
                //             child: Wrap(
                //               children: [
                //                 ListTile(
                //                     leading:  Icon(Icons.camera_alt,color:  brightness == Brightness.dark
                //                             ? Colors.black
                //                             : Colors.white,),
                //                     title: Text(
                //                       'Camera',
                //                       style: TextStyle(
                //                         color: brightness == Brightness.dark
                //                             ? Colors.black
                //                             : Colors.white,
                //                       ),
                //                     ),
                //                     onTap: () => {}),
                //                 ListTile(
                //                   leading:  Icon(Icons.image,color:  brightness == Brightness.dark
                //                             ? Colors.black
                //                             : Colors.white,),
                //                   title:  Text('Gallery',style: TextStyle(
                //                         color: brightness == Brightness.dark
                //                             ? Colors.black
                //                             : Colors.white,
                //                       ),),
                //                   onTap: () => {},
                //                 ),
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //       icon: const Icon(Icons.camera_alt));
                // })
              ],
            )),
          ),
        ),
      ),
    );
  }
}
