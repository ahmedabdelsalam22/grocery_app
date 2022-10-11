import 'package:beniseuf/inner_screens/feeds_screen.dart';
import 'package:beniseuf/services/global_methods.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import '../services/utils.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key, required this.imPath,
    required this.title, required this.subTitle,
    required this.buttonText}) : super(key: key);

  final String imPath,title,subTitle,buttonText;

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;

    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50,),
              Image.asset(
                imPath,
                width: double.infinity,
                height: size.height*0.4,
              ),
              const SizedBox(height: 10,),
               const Text(
                'whoops',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 20,),
              TextWidget(
                  text: title,
                  color: Colors.cyan,
                  textSize: 20
              ),
              const SizedBox(height: 20,),
              TextWidget(
                  text: subTitle,
                  color: Colors.cyan,
                  textSize: 20
              ),
              SizedBox(height: size.height*0.15),
              ElevatedButton(
                  onPressed: (){
                    GlobalMethods.navigateTo(ctx: context,
                        routeName: FeedsScreen.routeName
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child:  TextWidget(
                        text: buttonText,
                        color: color,
                        textSize: 20
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
