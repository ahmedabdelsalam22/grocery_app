import 'package:beniseuf/models/products_model.dart';
import 'package:beniseuf/providers/cart_provider.dart';
import 'package:beniseuf/services/global_methods.dart';
import 'package:beniseuf/services/utils.dart';
import 'package:beniseuf/widgets/price_widget.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../inner_screens/product_details.dart';
import '../models/products_model.dart';
import '../providers/wishlist_provider.dart';
import 'heart_btn.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget( {Key? key}) : super(key: key);


  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {

  final _quantityTextController = TextEditingController();

  @override
  void initState()
  {
    _quantityTextController.text = '1';
    super.initState();
  }
  @override
  void dispose()
  {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Utils utils = Utils(context);

    Size size = utils.getScreenSize;
    final Color color = utils.color;

    final productModel = Provider.of<ProductModel>(context);

    final cartProvider = Provider.of<CartProvider>(context);

    bool isInCart = cartProvider.getCartItems.containsKey(productModel.id);

    final wishlistProvider = Provider.of<WishListProvider>(context);
    bool isInWishlist = wishlistProvider.getWishListItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: (){

            Navigator.pushNamed(
                context,
                ProductDetails.routName,
                arguments: productModel.id
            );

            //GlobalMethods.navigateTo(ctx: context, routeName: ProductDetails.routName);
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                width: size.width *0.2,
                height: size.width*0.21,
                boxFit: BoxFit.fill,
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex:3,
                      child: TextWidget(
                          text: productModel.title,
                          color: color,
                          textSize: 18,
                        maxLines: 1,
                        isTitle: true,
                      ),
                    ),
                    HeartBTN(
                      productId:productModel.id,
                      isInWishlist: isInWishlist,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: PriceWidget(
                        salePrice: productModel.salePrice,
                        price: productModel.price,
                        textPrice: _quantityTextController.text,
                        isOnSale: productModel.isOnSale,
                      ),
                    ),

                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            flex:6,
                            child: FittedBox(
                              child: TextWidget(
                                  text: productModel.isPiece ?'piece' : 'kg',
                                  color: color,
                                  textSize: 20,
                                isTitle: false,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            flex: 2,
                              child: TextFormField(
                                controller: _quantityTextController,
                                onChanged: (value){
                                  setState((){});
                                },
                                key: const ValueKey('10'),
                                style: TextStyle(color: color,fontSize: 18),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                enabled: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow( RegExp('[0-9.]')),
                                ],
                              ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      if(!isInCart){

                        //to check if user login or no , to let him to can add to cart
                        final User? user = authInstance.currentUser;

                        if (user == null) {
                          GlobalMethods.errorDialog(
                              subtitle: 'No user found, Please login first',
                              context: context);
                          return;
                        }
                        ///////////////////////

                        // cartProvider.addProductsToCart(
                        //     productId: productModel.id,
                        //     quantity: int.parse(_quantityTextController.text)
                        // );
                        await GlobalMethods.addToCart(
                            productId: productModel.id,
                            quantity: int.parse(_quantityTextController.text),
                            context: context);
                        await cartProvider.fetchCart();

                      }else{
                        return;
                      }

                    },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).cardColor
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
                  ),
                    child: TextWidget(
                      text: isInCart ? 'Already in cart' : 'Add to cart',
                      textSize: 20,
                      color: color,
                      maxLines: 1,
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
