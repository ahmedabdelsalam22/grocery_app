import 'package:beniseuf/consts/firebase_consts.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/btm_bar.dart';
import '../services/global_methods.dart';

class GoogleButton extends StatelessWidget {
   const GoogleButton({Key? key}) : super(key: key);


   Future<void> _googleSignIn(context)async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();

    if(googleAccount != null){
     final googleAuth = await googleAccount.authentication;
     if(googleAuth.accessToken !=null && googleAuth.idToken !=null){
       try{
         await authInstance.signInWithCredential(
           GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,
               idToken: googleAuth.idToken)
         );
         Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context){
               return const BottomBarScreen();
             })
         );
       }on FirebaseException catch(error){
         GlobalMethods.errorDialog(subtitle: '${error.message}', context: context);
       }catch(error){
         GlobalMethods.errorDialog(subtitle: '$error', context: context);
       }finally{}
     }

    }

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: (){
          _googleSignIn(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
                child: Image.asset('assets/images/google.png',width: 40,)
            ),
            const SizedBox(width: 8),
            TextWidget(
                text: 'Sign in with google',
                color: Colors.white,
                textSize: 18,
            ),

          ],
        ),
      ),
    );
  }
}
