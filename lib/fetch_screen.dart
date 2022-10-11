import 'package:beniseuf/providers/cart_provider.dart';
import 'package:beniseuf/providers/product_provider.dart';
import 'package:beniseuf/providers/wishlist_provider.dart';
import 'package:beniseuf/screens/btm_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'consts/firebase_consts.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {

  @override
  void initState()
  {
    Future.delayed(const Duration(microseconds: 5),() async {

      final productsProvider = Provider.of<ProductsProvider>(context,listen: false);

      final cartProvider = Provider.of<CartProvider>(context,listen: false);
      final wishlistProvider = Provider.of<WishListProvider>(context, listen: false);

      final User? user = authInstance.currentUser;
      if (user == null) {
        await productsProvider.fetchProducts();
        cartProvider.clearLocalCart();
        wishlistProvider.clearLocalWishlist();
      } else {
        await productsProvider.fetchProducts();
        await cartProvider.fetchCart();
        await wishlistProvider.fetchWishlist();
      }


      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
        return const BottomBarScreen();
      }));

      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/offers/Offer4.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            const Center(
              child: SpinKitFadingFour(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
