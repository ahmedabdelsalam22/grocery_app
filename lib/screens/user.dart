import 'package:beniseuf/consts/firebase_consts.dart';
import 'package:beniseuf/screens/auth/forget_pass_screen.dart';
import 'package:beniseuf/screens/auth/login.dart';
import 'package:beniseuf/screens/loading_manager.dart';
import 'package:beniseuf/screens/viewed_recently/viewed_screen.dart';
import 'package:beniseuf/screens/wishlist/wishlist_screen.dart';
import 'package:beniseuf/services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';
import '../widgets/text_widget.dart';
import 'orders/orders_screen.dart';

class UserScreen extends StatefulWidget {
   UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _addressTextController = TextEditingController();

  @override
  void dispose()
  {
    _addressTextController.dispose();
    super.dispose();
  }

  String? _name;
  String? _email;
  String? _address;


  final User? user = authInstance.currentUser;
  bool _isLoading = false;

  @override
  void initState(){
    getUserData();
    super.initState();
  }

  Future<void> getUserData()async{

    setState((){
      _isLoading = true;
    });
     if(user == null){
       setState((){
         _isLoading = false;
       });
       return;
     }
     try{
      String _uid = user!.uid;
      
      final DocumentSnapshot userDoc =
             await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if(userDoc == null){
        return;
      }else{
        _name = userDoc.get('name');
        _email = userDoc.get('email');
        _address = userDoc.get('shipping_address');
        _addressTextController.text = userDoc.get('shipping_address');
      }
     }catch (error){
       setState((){
         _isLoading = false;
       });
       GlobalMethods.errorDialog(subtitle: '$error', context: context);
     }finally{
       setState((){
         _isLoading = false;
       });
     }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text:  TextSpan(
                        text: 'Hi,   ',
                        style: const TextStyle(
                            color: Colors.cyan,
                            fontSize: 27,
                            fontWeight: FontWeight.bold
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: _name ?? 'user',
                              style: TextStyle(
                                  color: color,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal
                              ),
                              recognizer: TapGestureRecognizer()..onTap=(){
                                print('my name is pressed');
                              }
                          ),
                        ]
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: _email ?? 'user email',
                    color: color,
                    textSize: 18,
                    // isTitle: true,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(height: 20,),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 20,),
                  _listTiles(
                    title: 'Address',
                    subtitle: _address ?? 'address',
                    icon: IconlyBold.profile,
                      onPressed: ()async{
                        await _showAddressDialog();
                      },
                    color: color
                  ),
                  _listTiles(
                      title: 'Orders',
                      icon: IconlyBold.bag,
                      onPressed: (){
                        GlobalMethods.navigateTo(ctx: context,
                            routeName: OrdersScreen.routName
                        );
                      },
                      color: color
                  ),
                  _listTiles(
                      title: 'Wishlist',
                      icon: IconlyBold.heart,
                      onPressed: (){
                        GlobalMethods.navigateTo(ctx: context,
                            routeName: WishlistScreen.routName);
                      },
                      color: color
                  ),
                  _listTiles(
                      title: 'Viewed',
                      icon: IconlyBold.show,
                      onPressed: (){
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ViewedScreen.routName
                        );
                      },
                      color: color
                  ),
                  _listTiles(
                      title: 'Forget Password',
                      icon: IconlyBold.unlock,
                      onPressed: (){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context){
                              return const ForgetPasswordScreen();
                            })
                        );
                      },
                      color: color
                  ),
                  SwitchListTile(
                    title: const Text('Theme',style: TextStyle(fontSize: 24),),
                    secondary:  Icon(themeState.getDarkTheme?Icons.dark_mode_outlined
                        : Icons.light_mode_outlined),
                    onChanged: (bool value) {
                      themeState.setDarkTheme = value;
                    },
                    value: themeState.getDarkTheme,
                  ),
                  _listTiles(
                      title:  user == null ? 'Login' :'Logout',
                      icon: user==null? IconlyBold.login : IconlyBold.logout,
                      color: color,
                      onPressed: (){
                       // if user not login we switch logout btn to login btn to let him to login
                        if(user == null){
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context){
                                return const LoginScreen();
                              })
                          );
                        }else{
                          GlobalMethods.warningDialog(
                              title: 'Sign out',
                              subtitle: 'Do you wanna sign out ?',
                              fct: ()async{
                               await authInstance.signOut();
                               Navigator.of(context).pushReplacement(
                                   MaterialPageRoute(builder: (context){
                                     return const LoginScreen();
                                   })
                               );
                              },
                              context: context);
                        }

                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listTiles({
  required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color
}){
    return ListTile(
      title: Text(title,style: const TextStyle(fontSize: 24),),
      subtitle:TextWidget(
        text: subtitle ?? "",
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: (){
        onPressed();
      },
    );
  }




  Future<void> _showAddressDialog()async
  {
    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: _addressTextController,
              /*onChanged: (value){
                 _addressTextController.text;
              },*/
              maxLines:5,
              decoration: const InputDecoration(hintText: 'Your address'),
            ),
            actions: [
              TextButton(
                  onPressed: ()async{
                    String _uid = user!.uid;
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(_uid)
                          .update({
                        'shipping-address': _addressTextController.text,
                      });

                      Navigator.pop(context);
                      setState(() {
                        _address = _addressTextController.text;
                      });
                    } catch (err) {
                      GlobalMethods.errorDialog(
                          subtitle: err.toString(), context: context);
                    }
                  },
                  child: const Text('Update')
              )
            ],
          );
        }
    );
  }
}
