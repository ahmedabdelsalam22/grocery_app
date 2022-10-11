import 'package:beniseuf/inner_screens/on_sale_screen.dart';
import 'package:beniseuf/services/global_methods.dart';
import 'package:beniseuf/services/utils.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';


import '../consts/consts.dart';
import '../inner_screens/feeds_screen.dart';
import '../models/products_model.dart';
import '../providers/product_provider.dart';
import '../widgets/feed_item.dart';
import '../widgets/on_sale_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {

    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;
    final Color color = utils.color;

    final productsProvider = Provider.of<ProductsProvider>(context);

    final List<ProductModel> OnSaleProducts = productsProvider.getOnSaleProducts;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height*0.33,
              child: Swiper(
                autoplay: true,
                itemBuilder: (BuildContext context,int index){
                  return Image.asset(Consts.offerImages[index],fit: BoxFit.fill,);
                },
                itemCount: Consts.offerImages.length,
                pagination: const SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.white , activeColor: Colors.red
                  ),
                ),
               // control: SwiperControl(color: Colors.black),
              ),
            ),
            const SizedBox(height: 6,),
            TextButton(
              onPressed: (){
                GlobalMethods.navigateTo(
                    ctx: context, routeName:OnSaleScreen.routeName
                );
              },
                child: TextWidget(
                    text: 'View All',
                    color: Colors.blue,
                    textSize: 20
                ),
            ),
            const SizedBox(height: 6,),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      TextWidget(
                          text: 'ON SALE',
                          color: Colors.red,
                          textSize: 22,
                        isTitle: true,
                      ),
                      const SizedBox(width: 5,),
                      const Icon(IconlyLight.discount),
                    ],
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    height: size.height *0.24,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx,index){
                          return ChangeNotifierProvider.value(
                              value: OnSaleProducts[index],
                              child: const OnSaleWidget()
                          );
                        },
                      itemCount: OnSaleProducts.length<10? OnSaleProducts.length : 10,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextWidget(
                    text: 'Our Products',
                    color: color,
                    textSize: 20,
                    isTitle: true,
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: (){
                        GlobalMethods.navigateTo(ctx: context,
                            routeName: FeedsScreen.routeName
                        );
                      },
                      child: TextWidget(
                          text: 'Browser all',
                          color: Colors.blue,
                          textSize: 18,
                        maxLines: 1,
                        isTitle: true,
                      ),
                  )
                ],
              ),
            ),
            GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
             // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height*0.59),
              children: List.generate(
                  productsProvider.getProducts.length < 4 ?
                  productsProvider.getProducts.length :
                  4
                  , (index){
                return ChangeNotifierProvider.value(
                  value: productsProvider.getProducts[index],
                    child: const FeedsWidget()
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
