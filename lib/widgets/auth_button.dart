import 'package:beniseuf/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
   AuthButton({Key? key, Key,
     required this.fct,
     required this.buttonText,
     this.primary = Colors.white38,
  }) : super(key: key);

  final Function fct;
  final String buttonText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: (){
            fct();
          },
        style: ElevatedButton.styleFrom(
          primary: primary,
        ),
          child: TextWidget(
              text: buttonText,
              color: Colors.white,
              textSize: 18
          ),
      ),
    );
  }
}
