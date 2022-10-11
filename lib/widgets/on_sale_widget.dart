import 'package:beniseuf/models/products_model.dart';
import 'package:beniseuf/providers/wishlist_provider.dart';
import 'package:beniseuf/services/global_methods.dart';
import 'package:beniseuf/services/utils.dart';
import 'package:beniseuf/widgets/price_widget.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../inner_screens/product_details.dart';
import '../providers/cart_provider.dart';
import 'heart_btn.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {

    final Utils utils = Utils(context);

    Size size = utils.getScreenSize;
    final theme = utils.getTheme;
    Color color = utils.color;

    final productModel = Provider.of<ProductModel>(context);

    // cart
    final cartProvider = Provider.of<CartProvider>(context);
    bool isInCart = cartProvider.getCartItems.containsKey(productModel.id);

    final wishlistProvider = Provider.of<WishListProvider>(context);
    bool isInWishlist = wishlistProvider.getWishListItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: (){

            Navigator.pushNamed(
                context,
                ProductDetails.routName,
                arguments: productModel.id
            );

            // GlobalMethods.navigateTo(ctx: context, routeName: ProductDetails.routName);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FancyShimmerImage(
                        imageUrl: productModel.imageUrl,
                      width: size.width *0.22, boxFit: BoxFit.fill,height: size.width*0.22,
                    ),
                 Column(
                   children: [
                     TextWidget(
                         text: productModel.isPiece? 'piece' : '1KG',
                         color: color,
                         textSize: 22,
                       isTitle: true,
                     ),
                     const SizedBox(height: 6),
                     Row(
                       children: [
                         GestureDetector(
                           onTap: () async {
                             if(!isInCart){

                               //to check if user login or no , to let him to can add to cart
                               final User? user = authInstance.currentUser;

                               if (user == null) {
                                 GlobalMethods.errorDialog(
                                     subtitle: 'No user found, Please login first',
                                     context: context);
                                 return;
                               }


                               // cartProvider.addProductsToCart(
                               //     productId: productModel.id,
                               //     quantity: 1
                               // );
                              await GlobalMethods.addToCart(
                                   productId: productModel.id,
                                   quantity: 1,
                                   context: context);
                               await cartProvider.fetchCart();

                             }else{
                               return;
                             }

                           },
                           child: Icon(
                             isInCart? IconlyBold.bag2 : IconlyLight.bag2,
                             color: color,
                             size: 22,
                           ),
                         ),
                          HeartBTN(
                            productId: productModel.id,
                            isInWishlist: isInWishlist,
                          ),
                       ],
                     ),
                   ],
                 ),
                  ],
                ),
                 PriceWidget(
                  salePrice: productModel.salePrice,
                  price: productModel.price,
                  textPrice:  '1',
                  isOnSale: true,
                ),
                const SizedBox(height: 5),
                TextWidget(
                    text: productModel.title,
                    color: color,
                    textSize: 16,
                  isTitle: true,
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
