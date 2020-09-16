import 'package:cloud_firestore/cloud_firestore.dart';

class UserData{

  UserData({this.email, this.password,this.name,this.confirmPassword, this.id});

  UserData.fromDocument(DocumentSnapshot document){
    id = document.id;
    name = document.get('name') as String;
    email = document.get('email') as String;

  }

  String id;
  String name;
  String email;
  String password;
  String confirmPassword;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  Future<void> saveData() async {
    //await FirebaseFirestore.instance.collection('users').doc(id).set(toMap());
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'email' : email,
    };
  }

}