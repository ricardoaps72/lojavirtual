import 'package:cloud_firestore/cloud_firestore.dart';

class Product{

  Product.fromDocument(DocumentSnapshot doc){
   id = doc.id;
   name = doc.get('name') as String;
   description = doc.get('description') as String;
   images = List<String>.from(doc.get('images') as List<dynamic>);
  }

  String id;
  String name;
  String description;
  List<String> images;


}