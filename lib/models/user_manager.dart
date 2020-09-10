import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/helpers/firebase_errors.dart';

class UserManager extends ChangeNotifier {

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn({user, Function onFail, Function onSuccess}) async {
    _loading = true;
    try {
      final result = await auth.signInWithEmailAndPassword(email: user.email, password: user.password);

      // await Future.delayed(Duration(seconds: 4));

      this.user = result.user;

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

  void _loadCurrentUser() {
  final currentUser = auth.currentUser;
  if (currentUser != null){
    user = currentUser;
    print(user.uid);
  }
  notifyListeners();
  }
}