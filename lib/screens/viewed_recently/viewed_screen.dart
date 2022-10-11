import 'package:beniseuf/screens/viewed_recently/viewed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';

class ViewedScreen extends StatelessWidget {
  static const routName = '/ViewedScreen';
  const ViewedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;

      bool? isEmpty;

    if(isEmpty == false)
    {
      return const EmptyScreen(
            imPath: 'assets/images/history.png',
            title: 'Your History is empty!',
            subTitle: 'No product has been viewed yet!',
            buttonText: 'shop now!'
        );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'History',
            color: color,
            textSize: 22,
            isTitle: true,
          ),
          actions: [
            IconButton(
              onPressed: (){
                GlobalMethods.warningDialog(
                    title: 'Empty your History',
                    subtitle: 'Are you sure?',
                    fct: (){}, context: context);
              },
              icon: Icon(IconlyBroken.delete ,color: color,),
            ),
          ],
        ),

        body: ListView.builder(
          itemBuilder: (context,index){
            return  const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2,vertical: 6),
              child: ViewedRecentlyWidget(),
            );
          },
          itemCount: 5,
        ),
      );
    }

  }
}
