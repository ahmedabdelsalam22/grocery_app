import 'package:beniseuf/consts/firebase_consts.dart';
import 'package:beniseuf/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier
{

  Map<String ,CartModel> get getCartItems{
    return _cartItems;
  }

  Map<String ,CartModel> _cartItems = {};



//   void addProductsToCart({
//   required String productId,
//     required int quantity
// }){
//     if(_cartItems.containsKey(productId)){
//       removeOneItem(productId);
//     }else{
//       _cartItems.putIfAbsent(productId, () => CartModel(
//           id: DateTime.now().toString(),
//           productId: productId,
//           quantity: quantity
//       ));
//     }
//
//      notifyListeners();
//   }


  final userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> fetchCart()async{

    final User?user = authInstance.currentUser;

    final DocumentSnapshot userDoc =
    await userCollection.doc(user!.uid).get();
    if(userDoc == null){
      return;
    }
    final leng = userDoc.get('userCart').length;
    for(int i=0; i<leng; i++){
      _cartItems.putIfAbsent(userDoc.get('userCart')[i]['productId'], () =>
        CartModel(
            id: userDoc.get('userCart')[i]['cartId'],
            productId: userDoc.get('userCart')[i]['productId'],
            quantity: userDoc.get('userCart')[i]['quantity']
        )
      );
    }
    notifyListeners();
  }


  // minus one cart product quantity
  void reduceQuantityByOne(String productId)
  {
    _cartItems.update(productId,
            (value) => CartModel(
                id: value.id,
                productId: productId,
                quantity: value.quantity - 1
            )
    );
    notifyListeners();
  }

  // plus one cart product quantity

  void increaseQuantityByOne(String productId)
  {
    _cartItems.update(productId,
            (value) => CartModel(
            id: value.id,
            productId: productId,
            quantity: value.quantity + 1
        )
    );
    notifyListeners();
  }

  // remove one item from cart
  Future<void> removeOneItem({
  required String cartId,
    required String productId,
    required int quantity,
})async
  {
    final User?user = authInstance.currentUser;

    await userCollection.doc(user!.uid)
    .update({
      'userCart' : FieldValue.arrayRemove([
        {
          'cartId' : cartId,
          'productId' : productId,
          'quantity' : quantity,
        }
      ]),
    });

    _cartItems.remove(productId);
    await fetchCart();
    notifyListeners();
  }

  Future<void> clearOnlineCart()async{

    final User?user = authInstance.currentUser;


    await userCollection.doc(user!.uid)
        .update({
      'userCart' : [],
    });
    _cartItems.clear();
    notifyListeners();
  }


  // delete or clear all items in one click ..
  void clearLocalCart()
  {
    _cartItems.clear();
    notifyListeners();
  }

}