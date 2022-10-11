import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import '../../inner_screens/product_details.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class ViewedRecentlyWidget extends StatelessWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:ListTile(
        leading: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0)
          ),
          child: FancyShimmerImage(
            width: size.width*0.2,
            imageUrl:
            'https://th.bing.com/th/id/OIP.HGSdOr-haiKE1oqb5Swp6QHaFv?pid=ImgDet&rs=1',
            boxFit: BoxFit.fill,
          ),
        ),
        title: TextWidget(
          textSize: 18,
          text: 'Title',
          color: color,
          isTitle: true,
        ),
        subtitle: const Text('\$12.88'),
        trailing: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.green
          ),
          child: const Icon(Icons.add,color: Colors.white,),
        ),
        onTap: (){
          GlobalMethods.navigateTo(
              ctx: context, routeName: ProductDetails.routName
          );
        },
      ),
    );
  }
}
