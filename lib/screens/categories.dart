import 'package:beniseuf/services/utils.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';
import '../widgets/categories_widget.dart';

class CategoriesScreen extends StatelessWidget {
   CategoriesScreen({Key? key}) : super(key: key);

  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];

  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/images/cats/fruits.png',
      'catText': 'Fruits',
    },
    {
      'imgPath': 'assets/images/cats/veg.png',
      'catText': 'Vegetables',
    },
    {
      'imgPath': 'assets/images/cats/Spinach.png',
      'catText': 'Herbs',
    },
    {
      'imgPath': 'assets/images/cats/nuts.png',
      'catText': 'Nuts',
    },
    {
      'imgPath': 'assets/images/cats/spices.png',
      'catText': 'Spices',
    },
    {
      'imgPath': 'assets/images/cats/grains.png',
      'catText': 'Grains',
    },
  ];


  @override
  Widget build(BuildContext context) {

    final utils = Utils(context);
    Color color = utils.color;

    return Scaffold(
      appBar: AppBar(
        elevation:0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(text: 'categories', color: color, textSize: 24,
        isTitle: true,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
            crossAxisCount: 2,
          childAspectRatio: 240/250,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children:List.generate(6,
                  (index){
                    return CategoriesWidget(
                      catText: catInfo[index]['catText'],
                      imPath: catInfo[index]['imgPath'],
                      passedcolor: gridColors[index],
                    );
                  }
          ),
        ),
      ),
    );
  }
}
