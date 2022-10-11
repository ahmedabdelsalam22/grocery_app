import 'package:beniseuf/consts/firebase_consts.dart';
import 'package:beniseuf/providers/product_provider.dart';
import 'package:beniseuf/screens/cart/cart_widget.dart';
import 'package:beniseuf/widgets/empty_screen.dart';
import 'package:beniseuf/services/global_methods.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;

    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();

    if (cartItemsList.isEmpty) {
      return const EmptyScreen(
          imPath: 'assets/images/cart.png',
          title: 'Your cart is empty!',
          subTitle: 'Add something and make me happy ',
          buttonText: 'shop now!');
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Cart(${cartItemsList.length})',
            color: color,
            textSize: 22,
            isTitle: true,
          ),
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'Empty your cart',
                    subtitle: 'Are you sure?',
                    fct: () async {
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                    },
                    context: context);
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _checkOut(context: context),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return ChangeNotifierProvider.value(
                      value: cartItemsList[index],
                      child: CartWidget(
                        quantity: cartItemsList[index].quantity,
                      ));
                },
                itemCount: cartItemsList.length,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _checkOut({
    required BuildContext context,
  }) {
    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context);


    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrentProduct =
          productProvider.findProductById(value.productId);
      total += (getCurrentProduct.isOnSale
              ? getCurrentProduct.salePrice
              : getCurrentProduct.price) *
          value.quantity;
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: size.height * 0.1,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Material(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
                /*child: InkWell(
                  onTap: () async {
                    final oderId = const Uuid().v4();
                    User? user = authInstance.currentUser;
                    final productProvider =
                        Provider.of<ProductsProvider>(context,listen: false);

                    final ordersProvider = Provider.of<OrdersProvider>(context,listen: false);

                    cartProvider.getCartItems.forEach((key, value) async {
                      final getCurrentProduct =
                          productProvider.findProductById(value.productId);
                      try {
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(oderId)
                            .set({
                          'oderId': oderId,
                          'userId': user!.uid,
                          'productId': value.productId,
                          'price': (getCurrentProduct.isOnSale
                              ? getCurrentProduct.salePrice
                              : getCurrentProduct.price)*value.quantity,
                          'totalPrice': total,
                          'quantity': value.quantity,
                          'imageUrl': getCurrentProduct.imageUrl,
                          'userName': user.displayName,
                          'orderDate':Timestamp.now(),
                        });
                        await cartProvider.clearOnlineCart();
                        cartProvider.clearLocalCart();
                        /////////////
                       ordersProvider.fetchOrders();
                        await Fluttertoast.showToast(
                          msg: "Your order has been placed",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      } catch (error) {
                        GlobalMethods.errorDialog(
                            subtitle: error.toString(), context: context);
                      } finally {}
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      text: 'Order Now',
                      color: Colors.white,
                      textSize: 20,
                    ),
                  ),
                ),*/
              ),
            ),
            const Spacer(),
            FittedBox(
              child: TextWidget(
                text: 'Total : \$${total.toStringAsFixed(2)}',
                color: color,
                textSize: 18,
                isTitle: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
