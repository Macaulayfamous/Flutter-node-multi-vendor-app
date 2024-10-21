import 'package:flutter/material.dart';
// import 'package:mac_store_app/controllers/auth_controller.dart';
import 'package:mac_store_app/views/screens/detail/screens/order_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  // final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // await _authController.signOutUSer(context: context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const OrderScreen();
          }));
        },
        child: const Text('My Orders ',),
      ),
    );
  }
}
