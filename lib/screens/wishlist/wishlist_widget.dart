import 'package:beniseuf/inner_screens/product_details.dart';
import 'package:beniseuf/models/products_model.dart';
import 'package:beniseuf/models/wishlist_model.dart';
import 'package:beniseuf/providers/wishlist_provider.dart';
import 'package:beniseuf/services/global_methods.dart';
import 'package:beniseuf/services/utils.dart';
import 'package:beniseuf/widgets/heart_btn.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../widgets/text_widget.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;

    final wishlistProvider = Provider.of<WishListProvider>(context);

    final wishlistModel = Provider.of<WishlistModel>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.findProductById(wishlistModel.productId);

    double usedPrice = getCurrentProduct.isOnSale?
    getCurrentProduct.salePrice : getCurrentProduct.price;

    bool isInWishlist = wishlistProvider.getWishListItems.containsKey(getCurrentProduct.id);

    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
            context,
            ProductDetails.routName,
            arguments: wishlistModel.productId
        );
      },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: size.height*0.20,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: color,width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    //width: size.width*0.2,
                    height: size.width*0.25,
                    child: FancyShimmerImage(
                      imageUrl: getCurrentProduct.imageUrl,
                      boxFit: BoxFit.fill,
                    ),
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: (){},
                              icon: Icon(IconlyLight.bag2 ,color: color,),
                            ),
                            HeartBTN(
                                productId: getCurrentProduct.id,
                              isInWishlist: isInWishlist,
                            ),
                          ],
                        ),
                      ),
                      TextWidget(
                          text: getCurrentProduct.title,
                          color: color,
                          textSize: 20.0,
                          maxLines: 2,
                          isTitle: true,
                        ),
                      const SizedBox(height: 5,),
                      TextWidget(
                        text: '\$${usedPrice.toStringAsFixed(2)}',
                        color: color,
                        textSize: 18.0,
                        maxLines: 1,
                        isTitle: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
