import 'package:badges/badges.dart';
import 'package:beniseuf/screens/cart/cart_screen.dart';
import 'package:beniseuf/screens/categories.dart';
import 'package:beniseuf/screens/home_screen.dart';
import 'package:beniseuf/screens/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';
import '../providers/cart_provider.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {

  List _pages =
  [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    UserScreen()
  ];

  int _selectedIndex =0;
  void selectedPage(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;


    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _isDark? Theme.of(context).cardColor:Colors.white,
        currentIndex: _selectedIndex,
        onTap: selectedPage,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: _isDark? Colors.white10 : Colors.grey,
        selectedItemColor:  _isDark? Colors.lightBlue : Colors.black87,
        elevation: 0.0,
        items:<BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0?IconlyBold.home : IconlyLight.home),label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1?IconlyBold.category : IconlyLight.category),label: 'Category'
          ),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_,myCart,ch){
                  return Badge(
                      toAnimate: true,
                      shape: BadgeShape.circle,
                      badgeColor: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                      //position: BadgePosition.topEnd(top: -7,end: -7),
                      badgeContent:  Text(
                        myCart.getCartItems.length.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      child: Icon(
                          _selectedIndex == 2?IconlyBold.buy
                              : IconlyLight.buy));
                },
              ),
              label: 'Cart'
          ),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3?IconlyBold.user2 : IconlyLight.user2),label: 'User'
          ),
        ],
      ),
    );
  }
}
