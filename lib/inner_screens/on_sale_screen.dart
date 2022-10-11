import 'package:beniseuf/models/products_model.dart';
import 'package:beniseuf/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/on_sale_widget.dart';
import '../widgets/text_widget.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = '/OnSaleScreen';

  const OnSaleScreen({Key? key}) : super(key: key);

  final bool _isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;

    final productsProvider = Provider.of<ProductsProvider>(context);
    final List<ProductModel> OnSaleProducts = productsProvider.getOnSaleProducts;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: const BackWidget(),
        title: TextWidget(
          text: 'Products On Sale',
          color: color,
          textSize: 22,
          isTitle: true,
        ),
      ),
      body: OnSaleProducts.isEmpty
          ? const EmptyProdWidget(text: 'No product on sale yet!',)
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 2,
                // crossAxisSpacing: 10,
                childAspectRatio: size.width / (size.height * 0.45),
                children: List.generate(
                    OnSaleProducts.length
                , (index) {
                  return ChangeNotifierProvider.value(
                    value: OnSaleProducts[index],
                      child: const OnSaleWidget()
                  );
                }),
              ),
            ),
    );
  }
}
