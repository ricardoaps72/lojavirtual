import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {

  List<UserData> users = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription _subscription;

  void updateUser(UserManager userManager){
    _subscription?.cancel();
    if(userManager.adminEnabled){
      _listenToUsers();
    }else{
      users.clear();
      notifyListeners();
    }

  }

  void _listenToUsers(){
      _subscription = firestore.collection('users').snapshots().listen((snapshot) {
      users = snapshot.docs.map((d) => UserData.fromDocument(d)).toList();
      users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });

  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

}