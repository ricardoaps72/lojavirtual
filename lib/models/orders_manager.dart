import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/order.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';

class OrdersManager extends ChangeNotifier {
  UserData user;
  List<Order> orders = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription _subscription;

  void updateUser(UserData user){
    this.user = user;
    orders.clear();
    _subscription?.cancel();

    if(user != null){
      _listenToOrders();
    }

  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders').where('user', isEqualTo: user.id).snapshots().listen((event) {
      orders.clear();
      for(final doc in event.docs){
        orders.add(Order.fromDocument(doc));
      }
      //print(orders);
      notifyListeners();
    });

  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}