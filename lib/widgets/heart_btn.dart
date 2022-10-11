import 'package:beniseuf/providers/product_provider.dart';
import 'package:beniseuf/services/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../models/products_model.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';

class HeartBTN extends StatelessWidget {
   HeartBTN({Key? key, required this.productId, this.isInWishlist=false,})
       : super(key: key);

  final String productId;
  final bool? isInWishlist;

  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.findProductById(productId);

    final Utils utils = Utils(context);
    Color color = utils.color;

    final wishlistProvider = Provider.of<WishListProvider>(context);

    return GestureDetector(
      onTap: () async {

       try{

         final User? user = authInstance.currentUser;

         if (user == null) {
           GlobalMethods.errorDialog(
               subtitle: 'No user found, Please login first',
               context: context);
           return;
         }
         if(isInWishlist==false && isInWishlist != null){
          await GlobalMethods.addToWishlist(productId: productId, context: context);
         }else{
          await wishlistProvider.removeOneItem(
               wishlistId: wishlistProvider.getWishListItems[getCurrentProduct.id]!.id,
               productId: productId);
         }
       await wishlistProvider.fetchWishlist();
       }catch (error){

       }finally{}

       // wishlistProvider.addProductToWishList(productId: productId);
      },
      child: Icon(
        isInWishlist !=null && isInWishlist==true ? IconlyBold.heart : IconlyLight.heart,

        color:isInWishlist !=null && isInWishlist==true ? Colors.red : color,
        size: 22,
      ),
    );
  }
}
