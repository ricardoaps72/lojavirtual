import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/order.dart';
import 'package:lojavirtual/models/user.dart';

class AdminOrdersManager extends ChangeNotifier {

  UserData user;
  List<Order> _orders = [];

  UserData userFilter;
  List<Status> statusFilter = [Status.preparing];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription _subscription;

  void updateAdmin({bool adminEnabled}){

    _orders.clear();
    _subscription?.cancel();

    if(adminEnabled){
      _listenToOrders();
    }

  }

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();
    if (userFilter != null){
      output = output.where((o) => o.userId == userFilter.id).toList();
    }

    return output = output.where((o) => statusFilter.contains(o.status)).toList();

  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders').snapshots().listen(
            (event) {
      for(final change in event.docChanges){
        switch(change.type){
          case DocumentChangeType.added:
            _orders.add(
              Order.fromDocument(change.doc)
            );
            break;
          case DocumentChangeType.modified:
            final modOrder = _orders.firstWhere(
                    (o) => o.orderId == change.doc.id);
            modOrder.updateFromDocument(change.doc);
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
      notifyListeners();
    });

  }

  void setUserFilter(UserData user){
    userFilter = user;
    notifyListeners();
  }

  void setStatusFilter({Status status, bool enabled}){
    if(enabled){
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

}