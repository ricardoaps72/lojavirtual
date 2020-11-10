import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:lojavirtual/helpers/firebase_errors.dart';
import 'package:lojavirtual/models/user.dart';


class UserManager extends ChangeNotifier {

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User user;
  UserData userData;

  bool _loading = false;
  bool get loading => _loading;

  set setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;

  set setLoadingFace(bool value){
    _loadingFace = value;
    notifyListeners();
  }

  bool get isLoggedIn => userData != null;
  bool get adminEnabled => userData != null && userData.admin;

  Future<void> signIn({user, Function onFail, Function onSuccess}) async {
    _loading = true;
    try {
      final result = await auth.signInWithEmailAndPassword(email: user.email, password: user.password);
      // await Future.delayed(Duration(seconds: 4));
      //this.user = result.user;

      await _loadCurrentUser(user : result.user);

      onSuccess();
    } catch (e) {
      //onFail(e.code);
      onFail(getErrorString(e.code));
    }
    _loading = false;
  }

  Future<void> facebookLogin({Function onFail, Function onSuccess}) async {
    _loadingFace = true;
    final result = await FacebookLogin().logIn(['email', 'public_profile']);
    switch(result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.credential(result.accessToken.token);
        final authResult =  await auth.signInWithCredential(credential);
        if(authResult.user != null) {
          final firebaseUser = authResult.user;

          userData = UserData(
            id: firebaseUser.uid,
            name : firebaseUser.displayName,
            email : firebaseUser.email
          );

          await userData.saveData();
          userData.saveToken();

          onSuccess();

        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }
    _loadingFace = false;
  }

  Future<void> signUp({user, Function onFail, Function onSuccess}) async {
   _loading = true;
   try  {
     final result = await auth.createUserWithEmailAndPassword(email : user.email, password : user.password);

     user.id = result.user.uid;
     //this.user = result.user;

     user.id = result.user.uid;

     await user.saveData();
     user.saveToken();

     onSuccess();

   } catch (e) {
     //onFail(e.code);
     onFail(getErrorString(e.code));
   }
   _loading = false;
  }

  void signOut(){
    auth.signOut();
    userData = null;
    user = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User user}) async {
  final currentUser = user ?? auth.currentUser;

  if (currentUser != null){
    //user = currentUser;
    final DocumentSnapshot docUser = await firestore.collection('users').doc(currentUser.uid).get();

    UserData user = UserData.fromDocument(docUser);
    user.saveToken();

    // testar se pegou os dados
    debugPrint(user.id);
    debugPrint(user.email);
    debugPrint(user.name);

    userData = user;

    final docAdmin = await firestore.collection('admins').doc(user.id).get();
    if (docAdmin.exists){
      user.admin = true;
    }
    //print(user.admin);
    notifyListeners();
  }
  //notifyListeners();
  }
  //bool get adminEnabled => user != null && userData.admin;
}