import 'package:beniseuf/inner_screens/product_details.dart';
import 'package:beniseuf/services/global_methods.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import '../../services/utils.dart';

class OrdersWidget extends StatelessWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;

    return ListTile(
      title: TextWidget(
          text: 'Title x12',
          color: color,
          textSize: 18,
        isTitle: true,
      ),
      subtitle: const Text('Paid : \$12.9'),
      trailing: TextWidget(
        text: '03/08/2022',
        color: color,
        textSize: 18
    ),
      onTap: (){
        GlobalMethods.navigateTo(ctx: context,
            routeName: ProductDetails.routName
        );
      },
      leading: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: FancyShimmerImage(
          width: size.width*0.2,
          imageUrl: 'https://th.bing.com/th/id/OIP.HGSdOr-haiKE1oqb5Swp6QHaFv?pid=ImgDet&rs=1',
          boxFit: BoxFit.fill,
        ),
      ),
    );
  }
}
