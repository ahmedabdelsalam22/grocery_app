import 'package:beniseuf/models/cart_model.dart';
import 'package:beniseuf/models/products_model.dart';
import 'package:beniseuf/providers/cart_provider.dart';
import 'package:beniseuf/providers/product_provider.dart';
import 'package:beniseuf/services/global_methods.dart';
import 'package:beniseuf/services/utils.dart';
import 'package:beniseuf/widgets/heart_btn.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/product_details.dart';
import '../../providers/wishlist_provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.quantity}) : super(key: key);
  final int quantity;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {

  final _quantityTextController = TextEditingController();

  @override
  void initState()
  {
    _quantityTextController.text =widget.quantity.toString();
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

    final Size size = utils.getScreenSize;
    final Color color = utils.color;

    final cartProvider = Provider.of<CartProvider>(context);

    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);

    final getCurrentProduct = productProvider.findProductById(cartModel.productId);
    double usedPrice = getCurrentProduct.isOnSale?
    getCurrentProduct.salePrice : getCurrentProduct.price;

    final wishlistProvider = Provider.of<WishListProvider>(context);
    bool isInWishlist = wishlistProvider.getWishListItems.containsKey(getCurrentProduct.id);

    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
         context,
         ProductDetails.routName,
         arguments: cartModel.productId
     );
       },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 1),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child:Row(
            children: [
              Container(
                height: size.width*0.25,
                width: size.width *0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FancyShimmerImage(
                  imageUrl: getCurrentProduct.imageUrl,
                  boxFit: BoxFit.fill,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                      text: getCurrentProduct.title,
                      color: color, textSize: 22,isTitle: true),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: size.width*0.3,
                    child: Row(
                      children: [
                        _quantityController(
                          color: Colors.red,
                          icon: CupertinoIcons.minus,
                          onTap: (){
                            if(_quantityTextController.text=='1'){
                              return;
                            }else{
                              cartProvider.reduceQuantityByOne(cartModel.productId);
                              setState((){
                                _quantityTextController.text =
                                    (int.parse(_quantityTextController.text)-1).toString();
                              });
                            }
                          }
                        ),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _quantityTextController,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                              RegExp('[0-9]')
                          ),
                            ],
                            onChanged: (value){
                              setState((){
                                if(value.isEmpty){
                                  _quantityTextController.text='1';
                                }else{
                                  return;
                                }
                              });
                            },
                          ),
                        ),
                        _quantityController(
                            color: Colors.green,
                            icon: CupertinoIcons.add,
                          onTap: (){
                            cartProvider.increaseQuantityByOne(cartModel.productId);
                            setState((){
                              _quantityTextController.text =
                                  (int.parse(_quantityTextController.text)+1).toString();
                            });
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                     InkWell(
                       onTap: ()async{
                        await cartProvider.removeOneItem(
                           cartId: cartModel.id,
                           productId: cartModel.productId,
                           quantity: cartModel.quantity
                         );
                       },
                       child: const Icon(
                         CupertinoIcons.cart_badge_minus,
                         color: Colors.red,
                         size: 20,
                       ),
                     ),
                    const SizedBox(height: 5,),
                     HeartBTN(
                       productId: getCurrentProduct.id,
                       isInWishlist: isInWishlist,
                     ),
                    TextWidget(
                      text: '\$${(usedPrice*int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                      color: color,
                      textSize: 18,isTitle: true,
                      maxLines: 1,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _quantityController({
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
