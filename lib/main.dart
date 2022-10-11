import 'package:beniseuf/consts/firebase_consts.dart';
import 'package:beniseuf/inner_screens/on_sale_screen.dart';
import 'package:beniseuf/provider/dark_theme_provider.dart';
import 'package:beniseuf/providers/cart_provider.dart';
import 'package:beniseuf/providers/orders_provider.dart';
import 'package:beniseuf/providers/product_provider.dart';
import 'package:beniseuf/providers/wishlist_provider.dart';
import 'package:beniseuf/screens/auth/forget_pass_screen.dart';
import 'package:beniseuf/screens/auth/login.dart';
import 'package:beniseuf/screens/auth/register.dart';
import 'package:beniseuf/screens/btm_bar.dart';
import 'package:beniseuf/screens/orders/orders_screen.dart';
import 'package:beniseuf/screens/viewed_recently/viewed_screen.dart';
import 'package:beniseuf/screens/wishlist/wishlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'fetch_screen.dart';
import 'inner_screens/cate_screen.dart';
import 'inner_screens/feeds_screen.dart';
import 'inner_screens/product_details.dart';

void main(){
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme()async
  {
   themeChangeProvider.setDarkTheme =
         await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState()
  {
    getCurrentAppTheme();
    super.initState();
  }


  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context,snapshot)
      {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }else if(snapshot.hasError){
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('An error occurred'),
              ),
            ),
          );
        }


        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_){
              return themeChangeProvider;
            }),
            ChangeNotifierProvider(create: (_){
              return ProductsProvider();
            }),
            ChangeNotifierProvider(create: (_){
              return CartProvider();
            }),
            ChangeNotifierProvider(create: (_){
              return WishListProvider();
            }),
            ChangeNotifierProvider(create: (_){
              return OrdersProvider();
            }),
          ],



          child: Consumer<DarkThemeProvider>(
            builder: (context,themeProvider,child){
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme:Styles.themeData(themeProvider.getDarkTheme, context),
                home: const FetchScreen(),
                routes: {
                  OnSaleScreen.routeName : (ctx) =>  const OnSaleScreen(),
                  FeedsScreen.routeName : (ctx) => const FeedsScreen(),
                  ProductDetails.routName : (ctx) => const ProductDetails(),
                  WishlistScreen.routName : (ctx) => const WishlistScreen(),
                  OrdersScreen.routName : (ctx) => const OrdersScreen(),
                  ViewedScreen.routName : (ctx) => const ViewedScreen(),
                  LoginScreen.routName : (ctx) => const LoginScreen(),
                  RegisterScreen.routName : (ctx) => const RegisterScreen(),
                  ForgetPasswordScreen.routName : (ctx) => const ForgetPasswordScreen(),
                  CategoryScreen.routeName : (ctx) => const CategoryScreen(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
