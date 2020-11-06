import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

class UserData{

  UserData({this.email, this.password,this.name,this.confirmPassword, this.id});

  UserData.fromDocument(DocumentSnapshot document){
    id = document.id;
    name = document.get('name') as String;
    email = document.get('email') as String;
    cpf = document.get('cpf') as String;
    if(document.data().containsKey('address')){
      address = Address.fromMap(
          document.get('address') as Map<String, dynamic>);
    }
  }

  String id;
  String name;
  String email;
  String cpf;
  String password;
  String confirmPassword;
  bool admin = false;
  Address address;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference =>
      firestoreRef.collection('cart');

  Future<void> saveData() async {
    //await FirebaseFirestore.instance.collection('users').doc(id).set(toMap());
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'email' : email,
      if(address != null)
        'address' : address.toMap(),
      if(cpf != null)
        'cpf' : cpf
    };
  }

  void setAddress(Address address){
    this.address = address;
    saveData();
  }

  void setCpf(String cpf){
    this.cpf = cpf;
    saveData();
  }

}