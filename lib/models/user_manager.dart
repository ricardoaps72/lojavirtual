import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/helpers/firebase_errors.dart';
import 'package:lojavirtual/models/user.dart' as u;


class UserManager extends ChangeNotifier {

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User user ;
  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn({user, Function onFail, Function onSuccess}) async {
    _loading = true;
    try {
      final result = await auth.signInWithEmailAndPassword(email: user.email, password: user.password);
      // await Future.delayed(Duration(seconds: 4));

      //this.user = result.user;
      _loadCurrentUser(user : result.user);

      onSuccess();
    } catch (e) {
      //onFail(e.code);
      onFail(getErrorString(e.code));
    }
    _loading = false;
  }

  Future<void> signUp({user, Function onFail, Function onSuccess}) async {
   _loading = true;
   try  {
     final result = await auth.createUserWithEmailAndPassword(email : user.email, password : user.password);

     user.id = result.user.uid;
     this.user = result.user;

     user.id = result.user.uid;
     user.saveData();

     onSuccess();
   } catch (e) {
     //onFail(e.code);
     onFail(getErrorString(e.code));
   }
   _loading = false;
  }

  set setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  void _loadCurrentUser({User user}) async {
  final currentUser = user ?? auth.currentUser;
  if (currentUser != null){
    //user = currentUser;
    final DocumentSnapshot docUser = await firestore.collection('users').doc(currentUser.uid).get();
    var user = u.User.fromDocument(docUser);

    // testar se pegou os dados
    debugPrint(user.id);
    debugPrint(user.email);
    debugPrint(user.name);

    notifyListeners();
  }
  notifyListeners();
  }
}