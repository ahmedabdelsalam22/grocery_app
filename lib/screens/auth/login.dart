import 'package:beniseuf/screens/auth/register.dart';
import 'package:beniseuf/screens/btm_bar.dart';
import 'package:beniseuf/screens/loading_manager.dart';
import 'package:beniseuf/widgets/text_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../consts/consts.dart';
import '../../consts/firebase_consts.dart';
import '../../fetch_screen.dart';
import '../../services/global_methods.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/google_button.dart';
import 'forget_pass_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;

  @override
  void dispose()
  {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _passFocusNode.dispose();
   super.dispose();
  }




  bool _isLoading = false;
  Future<void> _submitFormOnLogin() async {

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setState((){
      _isLoading = true;
    });
    if(isValid){
      _formKey.currentState!.save();

      try{
        await authInstance.signInWithEmailAndPassword(
          email: _emailTextController.text.toLowerCase().trim(),
          password: _passwordTextController.text.trim(),
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context){
              return const FetchScreen();
            })
        );
        print('Login successfully');
      }on FirebaseException catch (error){
        GlobalMethods.errorDialog(subtitle: '${error.message}', context: context);
        setState((){
          _isLoading = false;
        });
      } catch (error){
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState((){
          _isLoading = false;
        });
      }
      finally{
        setState((){
          _isLoading = false;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 800,
              autoplayDelay: 8000,
              autoplay: true,
              itemBuilder: (BuildContext context,int index){
                return Image.asset(Consts.authImagesPaths[index],fit: BoxFit.fill,);
              },
              itemCount: Consts.authImagesPaths.length,
              // control: SwiperControl(color: Colors.black),
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 120.0),
                    TextWidget(
                        text: 'Welcome Back',
                        color: Colors.white,
                        textSize: 30,
                      isTitle: true,
                    ),
                    const SizedBox(height: 8.0),
                    TextWidget(
                      text: 'Sign in to continue',
                      color: Colors.white,
                      textSize: 18,
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailTextController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: ()=>FocusScope.of(context).requestFocus(_passFocusNode),
                              validator:(value){
                                if(value!.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.white,),
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.white,),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8,),
                            TextFormField(
                              controller: _passwordTextController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscureText,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: (){
                                _submitFormOnLogin();
                              },
                              validator:(value){
                                if(value!.isEmpty) {
                                  return 'Please enter a valid password';
                                }
                                else if(value.length < 7){
                                  return 'Password must be 7 characters';
                                }
                                else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: Colors.white,),
                              decoration:  InputDecoration(
                                hintText: 'Password',
                                suffixIcon: GestureDetector(
                                  onTap: (){
                                    setState((){
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child:  Icon(
                                    _obscureText?
                                    Icons.visibility :Icons.visibility_off_sharp ,
                                    color: Colors.white,
                                  ),
                                ),
                                hintStyle: const TextStyle(color: Colors.white,),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
                    const SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: (){
                          GlobalMethods.navigateTo(
                              ctx:context,
                              routeName: ForgetPasswordScreen.routName
                          );
                        },
                          child: const Text(
                            'Forget Password?',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic
                            ),
                          ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    AuthButton(
                      buttonText: 'Login',
                      fct: _submitFormOnLogin,
                    ),
                    const SizedBox(height: 10.0),
                     GoogleButton(),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                          text: 'OR',
                          color: Colors.white,
                          textSize: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AuthButton(
                      fct: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context){
                              return const FetchScreen();
                            })
                        );
                      },
                      buttonText: 'Continue as a guest',
                      primary: Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Don\'t have an account?',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            children: [
                              TextSpan(
                                  text: '  Sign up',
                                  style: const TextStyle(
                                      color: Colors.lightBlue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                    GlobalMethods.navigateTo(
                                        ctx: context,
                                        routeName: RegisterScreen.routName
                                    );
                                    }),
                            ])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
