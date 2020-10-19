import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/cart_product.dart';

class Order {

  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.productsPrice;
    userId = cartManager.userData.id;
    address = cartManager.address;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set(
      {
        'items' : items.map((e) => e.toOrderItemMap()).toList(),
        'price' : price,
        'user'  : userId,
        'address' : address.toMap(),
      }
    );
  }

  List<CartProduct> items;
  num price;
  String orderId;
  String userId;
  Address address;
  Timestamp date;



}