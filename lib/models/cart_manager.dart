import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';

class CartManager {

  List<CartProduct> items = [];

  UserData userData;

  void updateUser(UserManager userManager){
    userData = userManager.userData;
    items.clear();
    if(userData != null){
      _loadCartItems();
    }

  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await userData.cartReference.get();
    items = cartSnap.docs.map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)).toList();
  }

  void addToCart(Product product){
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.quantity++;
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      userData.cartReference.add(cartProduct.toCartItemMap());
    }

  }

  void _onItemUpdated(){



  }

}