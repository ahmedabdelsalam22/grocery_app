import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../consts/firebase_consts.dart';
import '../models/wishlist_model.dart';

class WishListProvider with ChangeNotifier
{

   Map<String ,WishlistModel> get getWishListItems{
   return _wishListItems;
  }

  final Map<String, WishlistModel> _wishListItems={};



   Future<void> fetchWishlist()async{

     final userCollection = FirebaseFirestore.instance.collection('users');

     final User?user = authInstance.currentUser;

     final DocumentSnapshot userDoc =
     await userCollection.doc(user!.uid).get();
     if(userDoc == null){
       return;
     }
     final leng = userDoc.get('userWish').length;
     for(int i=0; i<leng; i++){
       _wishListItems.putIfAbsent(userDoc.get('userWish')[i]['productId'], () =>
           WishlistModel(
               id: userDoc.get('userWish')[i]['wishlistId'],
               productId: userDoc.get('userWish')[i]['productId'],
           )
       );
     }
     notifyListeners();
   }



 /*  void addProductToWishList({
    required String productId,
  })
  {
    if(_wishListItems.containsKey(productId)){
      removeOneItem(productId);
    }else{
      _wishListItems.putIfAbsent(productId, () => WishlistModel(
        id: DateTime.now().toString(),
        productId: productId,
      ));
    }

    notifyListeners();
  }*/





  // remove one item from wishlist
   // remove one item from cart
   Future<void> removeOneItem({
     required String wishlistId,
     required String productId,
   })async
   {
     final userCollection = FirebaseFirestore.instance.collection('users');

     final User?user = authInstance.currentUser;

     await userCollection.doc(user!.uid)
         .update({
       'userWish' : FieldValue.arrayRemove([
         {
           'wishlistId': wishlistId,
           'productId' : productId,
         }
       ]),
     });

     _wishListItems.remove(productId);
     await fetchWishlist();
     notifyListeners();
   }

   Future<void> clearOnlineWishlist()async{

     final userCollection = FirebaseFirestore.instance.collection('users');

     final User?user = authInstance.currentUser;


     await userCollection.doc(user!.uid)
         .update({
       'userWish' : [],
     });
     _wishListItems.clear();
     notifyListeners();
   }


   // delete or clear all items in one click ..
  void clearLocalWishlist()
  {
    _wishListItems.clear();
    notifyListeners();
  }




}