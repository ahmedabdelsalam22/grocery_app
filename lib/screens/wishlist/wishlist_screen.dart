import 'package:beniseuf/providers/wishlist_provider.dart';
import 'package:beniseuf/screens/wishlist/wishlist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import '../cart/cart_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routName = '/WishlistScreen';

  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;

    final wishlistProvider = Provider.of<WishListProvider>(context);
    final wishItemsList = wishlistProvider.getWishListItems.values.toList().reversed.toList();

    if(wishItemsList.isEmpty){
      return const EmptyScreen(
          imPath: 'assets/images/wishlist.png',
          title: "Your wishlist is empty!",
          subTitle: 'Explore more and shortlist some items!',
          buttonText: 'Add a wish!'
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const BackWidget(),
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Wishlist${wishItemsList.length}',
            color: color,
            textSize: 22,
            isTitle: true,
          ),
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'Empty your wishlist',
                    subtitle: 'Are you sure?',
                    fct: () async{
                     await wishlistProvider.clearOnlineWishlist();
                      wishlistProvider.clearLocalWishlist();
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
        body: MasonryGridView.count(
          itemCount: wishItemsList.length,
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemBuilder: (context, index) {
            return ChangeNotifierProvider.value(
              value:wishItemsList[index] ,
                child: const WishlistWidget()
            );
          },
        ),
      );
    }

  }
}
