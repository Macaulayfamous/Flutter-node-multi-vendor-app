import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/auth_controller.dart';
import 'package:mac_store_app/provider/cart_provider.dart';
import 'package:mac_store_app/provider/delivered_order_count_provider.dart';
import 'package:mac_store_app/provider/favorite_provider.dart';
import 'package:mac_store_app/provider/user_provider.dart';
import 'package:mac_store_app/views/screens/detail/screens/order_screen.dart';
import 'package:mac_store_app/views/screens/detail/screens/shipping_address_screen.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final AuthController _authController = AuthController();

  //show signout dialog
  void showSignOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'Are you sure',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              'Do you really want to logout ?',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  await _authController.signOutUser(context: context, ref:ref);
                },
                child: Text(
                  "Logout",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final buyerId = ref.read(userProvider)!.id;
    //fetch the delivered order count when the widget  build
    ref
        .read(deliveredOrderCountProvider.notifier)
        .fetchDeliveredOrderCount(buyerId, context);

    //watch the deliveredOrderCountProvider to reactively rebuild when state changes
    final deliveredCount = ref.watch(deliveredOrderCountProvider);
    final user = ref.read(userProvider);
    final cartData = ref.read(cartProvider);
    final favoriteCount = ref.read(favoriteProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 450,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/FBrbGWQJqIbpA5ZHEpajYAEh1V93%2Fuploads%2Fimages%2F78dbff80_1dfe_1db2_8fe9_13f5839e17c1_bg2.png?alt=media",
                        width: MediaQuery.of(context).size.width,
                        height: 451,
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                    top: 30,
                    right: 30,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/icons/not.png',
                        width: 20,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      const Align(
                        alignment: Alignment(0, -0.53),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(
                              "https://cdn.pixabay.com/photo/2014/04/03/10/32/businessman-310819_1280.png"),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0.23, -0.61),
                        child: InkWell(
                          onTap: () {},
                          child: Image.asset(
                            'assets/icons/edit.png',
                            width: 19,
                            height: 19,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: const Alignment(0, 0.03),
                    child: user!.fullName != ""
                        ? Text(
                            user.fullName,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            'User',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  Align(
                    alignment: const Alignment(0.05, 0.17),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ShippingAddressScreen();
                        }));
                      },
                      child: user.state != ""
                          ? Text(
                              user.state,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              'States',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.09, 0.81),
                    child: SizedBox(
                      width: 287,
                      height: 117,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 240,
                            top: 66,
                            child: Text(
                              deliveredCount.toString(),
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 212,
                            top: 99,
                            child: Text(
                              "Completed",
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 224,
                            top: 2,
                            child: Container(
                              width: 52,
                              height: 58,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png",
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 13,
                                    top: 18,
                                    child: Image.network(
                                      width: 26,
                                      height: 26,
                                      'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F4ad2eb1752466c61c6bb41a0e223251a906a1a7bcorrect%201.png?alt=media&token=57abd4a6-50b4-4609-bb59-b48dce4c8cc6',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 130,
                            top: 66,
                            child: Text(
                              favoriteCount.length.toString(),
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 22,
                                  letterSpacing: 0.4),
                            ),
                          ),
                          Positioned(
                            left: 108,
                            top: 99,
                            child: Text(
                              'Favorite',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 114,
                            top: 2,
                            child: Container(
                              width: 52,
                              height: 58,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png",
                                  ),
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 15,
                                    top: 18,
                                    child: Image.network(
                                      width: 26,
                                      height: 26,
                                      "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F068bdad59a9aff5a9ee67737678b8d5438866afewish-list%201.png?alt=media&token=4a8abc27-022f-4a53-8f07-8c10791468e4",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 66,
                            child: Text(
                              cartData.length.toString(),
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 13,
                            top: 99,
                            child: Text(
                              'Cart',
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.4),
                            ),
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            child: Container(
                              width: 56,
                              height: 63,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fe0080f58f1ec1f2200fcf329b10ce4c4.png',
                                  ),
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 12,
                                    top: 15,
                                    child: Image.network(
                                      width: 33,
                                      height: 33,
                                      'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fc2afb7fb33cd20f4f1aed312669aa43b8bb2d431cart%20(2)%201.png?alt=media&token=be3d8494-1ccd-4925-91f1-ee30402dfb0e',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const OrderScreen();
                }));
              },
              leading: Image.asset(
                'assets/icons/orders.png',
              ),
              title: Text(
                'Track your order',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const OrderScreen();
                }));
              },
              leading: Image.asset(
                'assets/icons/history.png',
              ),
              title: Text(
                'History',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {},
              leading: Image.asset(
                'assets/icons/help.png',
              ),
              title: Text(
                'Help',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                showSignOutDialog(context);
              },
              leading: Image.asset(
                'assets/icons/logout.png',
              ),
              title: Text(
                'Logout',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
