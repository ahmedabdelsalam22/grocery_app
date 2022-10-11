import 'package:beniseuf/inner_screens/cate_screen.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget {
   const CategoriesWidget({required this.catText, required this.imPath, required this.passedcolor});

  final String catText,imPath;
  final Color passedcolor;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    double _screenWidth = size.width;

    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context,
            CategoryScreen.routeName,
          arguments: catText
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: passedcolor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: passedcolor.withOpacity(0.7),width: 2),
        ),
        child: Column(
          children: [
            Container(
              width: _screenWidth*0.3,
              height:  _screenWidth*0.3,
              decoration:  BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      imPath,
                    ),
                  fit: BoxFit.fill
                ),
              ),
            ),
            TextWidget(text: catText, color: color, textSize: 20,isTitle: true,)
          ],
        ),
      ),
    );
  }
}
