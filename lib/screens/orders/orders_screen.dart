import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders_provider.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'orders_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routName = '/OrdersScreen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {

    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;


    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orderList = ordersProvider.getOrders;

    if(orderList.isEmpty){
      return const EmptyScreen(
          imPath: 'assets/images/cart.png',
          title: "You didn't place any order yet!",
          subTitle: 'Order any something that your like it!',
          buttonText: 'Order now!'
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Your orders (${orderList.length})',
            color: color,
            textSize: 22,
            isTitle: true,
          ),
        ),

        body: Container(
          child: ListView.separated(
              itemBuilder: (context,index){
                return  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 6),
                  child: ChangeNotifierProvider.value(
                    value: orderList[index],
                      child: OrdersWidget()
                  ),
                );
              },
              separatorBuilder: (context,index){
                return  Padding(
                  padding: const EdgeInsets.only(left: 6,right: 6),
                  child: Divider(color: color.withOpacity(0.3),),
                );
              },
              itemCount: orderList.length
          ),
        ),
      );
    }

  }
}
