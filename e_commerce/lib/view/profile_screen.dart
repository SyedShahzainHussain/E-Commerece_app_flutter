import 'dart:io';

import 'package:e_commerce/extension/language/language.dart';
import 'package:e_commerce/extension/mediaQuery/media_query.dart';
import 'package:e_commerce/model/login_model_getter.dart';
import 'package:e_commerce/repository/google/google_authentication.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/utils..dart';
import 'package:e_commerce/viewModel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import "package:http_parser/http_parser.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    getSharedPreferencesData();
    super.initState();
  }

  Future getSharedPreferencesData() async {
    final data = context.read<GoogleSignInprovider>();
    await context.read<LoginModelGetter>().fetchLoginModel();

    await data.getDataToSharedPreference();
    await data.checkSignInUser();
  }

  @override
  Widget build(BuildContext context) {
    final googledata = context.read<GoogleSignInprovider>();
    final loginData = context.watch<LoginModelGetter>();
    context.watch<LoginModelGetter>().fetchLoginModel();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations!.profile),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loginData.isLoading,
        progressIndicator: const SpinKitFadingCircle(
          color: AppColors.deepPurple,
        ),
        child: googledata.isSignedIn == false
            ? Consumer<LoginModelGetter>(
                builder: (context, value, child) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: context.screenWidth * .15,
                              backgroundImage:  const NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtZvNXJYdl0uUzKj7gqgpe_OxRtw2FFvH21k0Pyq0Q3Eh8X49bKtZlLjajfU2erdn7BQA&usqp=CAU"),
                            ),
                            // Positioned(
                            //   bottom: -10,
                            //   right: 0,
                            //   child: IconButton(
                            //     onPressed: () async {
                            //       XFile? image = await ImagePicker().pickImage(
                            //         source: ImageSource.gallery,
                            //       );

                            //       if (image != null) {
                            //         final data = {
                            //           "email": value.loginModel.user!.email,
                            //           "password":
                            //               value.loginModel.user!.password
                            //         };
                            //         // ignore: use_build_context_synchronously
                            //         await uploadImage(
                            //           File(image.path),
                            //           value.loginModel.user!.token!,
                            //           context,
                            //           data,
                            //           value,
                            //         );
                            //       }
                            //     },
                            //     icon: const Icon(
                            //       Icons.camera_alt,
                            //       color: AppColors.deepPurple,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Card(
                          // color: AppColors.greyColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: context.screenHeight * .01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.person),
                                      const SizedBox(),
                                      Text(value
                                          .loginModel.user!.organizationName!),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: context.screenHeight * .01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.email),
                                      const SizedBox(),
                                      Text(value.loginModel.user!.email!)
                                    ],
                                  ),
                                  SizedBox(
                                    height: context.screenHeight * .01,
                                  ),
                                ]),
                          ),
                        )
                      ]),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: context.screenWidth * .15,
                            backgroundImage: NetworkImage(googledata.imageUrl!),
                          ),
                          googledata.isSignedIn
                              ? const SizedBox()
                              : Positioned(
                                  bottom: -10,
                                  right: 0,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: AppColors.deepPurple,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      Card(
                        color: AppColors.greyColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: context.screenHeight * .01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.person),
                                    const SizedBox(),
                                    Text(googledata.name!),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: context.screenHeight * .01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.email),
                                    const SizedBox(),
                                    Text(googledata.email!)
                                  ],
                                ),
                                SizedBox(
                                  height: context.screenHeight * .01,
                                ),
                              ]),
                        ),
                      )
                    ]),
              ),
      ),
    );
  }
}

Future<void> uploadImage(File imageFile, String token, BuildContext context,
    dynamic data, LoginModelGetter loginModelGetter) async {
  loginModelGetter.setLoading(true);
  var request = http.MultipartRequest(
    'PUT',
    Uri.parse(
        'https://jackdelivery-full-backend.onrender.com/api/upload/profile-photo'),
  );
  request.headers['authorization'] = 'Bearer $token';

  final multiPartFile = await http.MultipartFile.fromPath(
      'image', imageFile.path,
      contentType: MediaType('image', 'jpg'));

  request.files.add(multiPartFile);

  var response = await request.send();

  if (response.statusCode == 200) {
    // final currentContext = context;
    if (response.statusCode == 200) {
      await AuthViewModel().loginProfile(data);

      loginModelGetter.setLoading(false);
      Utils.showToast(AppColors.deepPurple, Colors.white, "Profile Updated");
    }
  } else {
    loginModelGetter.setLoading(false);
    Utils.showToast(AppColors.deepPurple, Colors.white,
        'Image upload failed with status code ${response.statusCode}');
    print('Response body: ${await response.stream.bytesToString()}');
  }
}
