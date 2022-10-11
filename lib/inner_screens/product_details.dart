import 'package:beniseuf/providers/cart_provider.dart';
import 'package:beniseuf/providers/product_provider.dart';
import 'package:beniseuf/providers/wishlist_provider.dart';
import 'package:beniseuf/services/utils.dart';
import 'package:beniseuf/widgets/heart_btn.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../services/global_methods.dart';
import '../widgets/back_widget.dart';
import '../widgets/text_widget.dart';

class ProductDetails extends StatefulWidget {
  static const routName = '/ProductDetails';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  final _quantityTextController = TextEditingController(text: '1');

  @override

  void dispose()
  {
    //clean up the controller when the widget is disposed
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;
    final productProvider = Provider.of<ProductsProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    final getCurrentProduct = productProvider.findProductById(productId);
    double usedPrice = getCurrentProduct.isOnSale?
    getCurrentProduct.salePrice : getCurrentProduct.price;

    final cartProvider = Provider.of<CartProvider>(context);

    double totalPrice = usedPrice * int.parse(_quantityTextController.text);

    bool isInCart = cartProvider.getCartItems.containsKey(productId);

    final wishlistProvider = Provider.of<WishListProvider>(context);
    bool isInWishlist = wishlistProvider.getWishListItems.containsKey(productId);


    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),

      body: Column(
        children: [
             Flexible(
               flex: 2,
               child: FancyShimmerImage(
                   imageUrl: getCurrentProduct.imageUrl,
                 boxFit: BoxFit.fill,
                 width: size.width,
               ),
             ),
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 30,right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Flexible(
                           child: TextWidget(
                               text: getCurrentProduct.title,
                               color: color,
                               textSize: 25,
                             isTitle: true,
                           ),
                         ),
                        HeartBTN(
                          productId:productId,
                          isInWishlist: isInWishlist,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 30,right: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                            text: '\$${usedPrice.toStringAsFixed(2)}',
                            color: Colors.green,
                            textSize: 22,
                          isTitle: true,
                        ),
                        TextWidget(
                            text: getCurrentProduct.isPiece ? 'piece' : '/kg',
                            color: color,
                            textSize: 22,
                        ),
                        const SizedBox(width: 10),
                        Visibility(
                          visible: getCurrentProduct.isOnSale? true : false,
                            child:Text(
                              '\$${getCurrentProduct.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 15,color: color,
                                decoration: TextDecoration.lineThrough
                              ),
                            ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(63, 200, 101, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextWidget(
                            text: 'Free delivery',
                            color: Colors.white,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      quantityControl(
                        onTap: (){
                          if(_quantityTextController.text=='1'){
                            return;
                          }else{
                            setState((){
                              _quantityTextController.text =
                                  (int.parse(_quantityTextController.text)-1).toString();
                            });
                          }
                        },
                        color: Colors.red,
                        icon: CupertinoIcons.minus,
                      ),
                      const SizedBox(width: 5,),
                      Flexible(
                        flex: 1,
                        child:TextField(
                          controller: _quantityTextController,
                          keyboardType: TextInputType.number,
                          key: const ValueKey('quantity'),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.green,
                          enabled: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          onChanged: (value){
                            if(value.isEmpty){
                              _quantityTextController.text = '1';
                            }else{}
                          },
                        ),
                      ),
                      const SizedBox(width: 5,),
                      quantityControl(
                        onTap: (){
                          setState((){
                            _quantityTextController.text =
                                (int.parse(_quantityTextController.text)+1).toString();
                          });
                        },
                        color: Colors.green,
                        icon: CupertinoIcons.plus,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment :CrossAxisAlignment.start ,
                            children: [
                              TextWidget(
                                text: 'Total',
                                color: Colors.red.shade300,
                                textSize: 20,
                                isTitle: true,
                              ),
                              Row(
                                children: [
                                  TextWidget(
                                    text: '\$${totalPrice.toStringAsFixed(2)}/',
                                    color: color,
                                    textSize: 20,
                                    isTitle: true,
                                  ),
                                  TextWidget(
                                    text: '${_quantityTextController.text}kg',
                                    color: color,
                                    textSize: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Material(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
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
                                    ///////////////////////

                                    // cartProvider.addProductsToCart(
                                    //     productId: getCurrentProduct.id,
                                    //     quantity: int.parse(_quantityTextController.text)
                                    // );
                                    await GlobalMethods.addToCart(
                                        productId: getCurrentProduct.id,
                                        quantity: int.parse(_quantityTextController.text),
                                        context: context);
                                    await cartProvider.fetchCart();

                                  }else{
                                    return;
                                  }

                                },
                                borderRadius:BorderRadius.circular(10),
                                child:Padding(
                                  padding:const EdgeInsets.all(12),
                                  child: TextWidget(
                                    text:isInCart? 'Already in cart' : 'Add to cart',
                                    color: Colors.white,
                                    textSize: 18,
                                  ),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget quantityControl({
    required Color color,
    required IconData icon,
    required Function onTap,
  })
  {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: (){
              onTap();
            },
            borderRadius: BorderRadius.circular(12),
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon,color: Colors.white,),
            ),
          ),
        ),
      ),
    );
  }


}
