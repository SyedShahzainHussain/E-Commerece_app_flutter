import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDrawerComponents extends StatelessWidget {
  const AdminDrawerComponents({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteName.orderScreen);
              },
              title: const Text(
                "Orders",
              ),
              leading: const FaIcon(FontAwesomeIcons.basketShopping)),
          const Divider(),
          ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.mainScreen,
                  (route) => false,
                );
              },
              title: const Text(
                "Go To Home",
              ),
              leading: const Icon(Icons.edit)),
          const Divider(),
          ListTile(
              onTap: () async {
                await clearAdminSharedPreferences().then((value) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RouteName.mainScreen);
                });
              },
              title: const Text(
                "Logout",
              ),
              leading: const Icon(Icons.logout)),
        ],
      )),
    );
  }
}

Future clearAdminSharedPreferences() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.remove("email");
  sp.remove("password");
  sp.remove('isLogin');
}
