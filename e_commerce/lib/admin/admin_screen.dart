import 'package:e_commerce/admin/drawer_components.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:const  AdminDrawerComponents(),
      appBar: AppBar(

      ),
    );
  }
}