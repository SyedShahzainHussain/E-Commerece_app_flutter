import 'package:e_commerce/extension/language/language.dart';

import 'package:e_commerce/provider/change_language_.dart';
import 'package:e_commerce/repository/google/google_authentication.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:e_commerce/viewModel/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(children: [
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RouteName.favoritesScreen);
            },
            title: Text(
              context.localizations!.favorites,
            ),
            leading: const Icon(
              Icons.favorite,
              color: AppColors.greyColor,
            ),
          ),
          const Divider(),
          ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteName.adminLoginScreen);
              },
              title: Text(
                context.localizations!.admin,
              ),
              leading: const Icon(Icons.admin_panel_settings_sharp)),
          const Divider(),
          ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteName.profileScreen);
              },
              title: Text(
                context.localizations!.profileScreen,
              ),
              leading: const Icon(Icons.supervised_user_circle)),
          const Divider(),
          ListTile(
              onTap: () async {
                final isSign = context.read<GoogleSignInprovider>().isSignedIn;
                if (isSign) {
                  await context.read<GoogleSignInprovider>().userSignOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteName.splashScreen, (route) => false);
                } else {
                  await FirebaseAuth.instance.signOut().then((value)async {

                  await context.read<UserViewModel>().remove().then((value) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteName.splashScreen, (route) => false);
                  });
                  });
                }
              },
              title: Text(
                context.localizations!.logout,
              ),
              leading: const Icon(Icons.logout)),
          const Divider(),
          Consumer<ChangeLanguage>(
            builder: (context, changeLanguage, child) => SwitchListTile(
              value: context.watch<ChangeLanguage>().isLanguage ?? false,
              activeColor: AppColors.deepPurple,
              inactiveThumbColor: AppColors.greyColor,
              onChanged: (value) {
                changeLanguage.chnageLanguages(value);
                changeLanguage.loadLanguage();
              },
              title: Text(context.localizations!.changeLanguage),
            ),
          )
        ]),
      ),
    );
  }
}
