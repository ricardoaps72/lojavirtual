import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/store.dart';

class StoresManager extends ChangeNotifier {

  StoresManager(){
    _loadStoresList();
  }

  Timer _timer;

  List<Store> stores = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _loadStoresList() async {

    final snapshot = await firestore.collection('stores').get();

    stores = snapshot.docs.map((e) => Store.formDocument(e)).toList();

    notifyListeners();
  }

  void _startTimer(){
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening(){
    for(final store in stores)
      store.updateStatus();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}