// database.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // add user to db
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc('id')
        .set(userInfoMap);
  }

  // update wallet money firebase
  Future UpdateUserWallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc('id')
        .update({"Wallet": amount});
  }

  // add item to firebase storage
  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  // get the item photo from storage
  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  // get the item from cart storage
  Future<Stream<QuerySnapshot>> getItemCart(String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc('id')
        .collection("Cart")
        .snapshots();
  }

  // add cart item
  Future addItemtoCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc('id')
        .collection('Cart')
        .add(userInfoMap);
  }

  // update wallet money firebase
}
