import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'item_size.dart';

class Product extends ChangeNotifier {

  Product.fromDocument(DocumentSnapshot doc){
   id = doc.id;
   name = doc.get('name') as String;
   description = doc.get('description') as String;
   images = List<String>.from(doc.get('images') as List<dynamic>);
   sizes = (doc.get('sizes') as List<dynamic> ?? []).map((s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();

   //print(sizes);


  }

  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;

  set selectedSize(ItemSize value){
    _selectedSize = value;

    notifyListeners();

  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0;
  }

  num get basePrice {
    num lowest = double.infinity;
    for(final size in sizes){
      if(size.price < lowest && size.hasStock)
        lowest = size.price;
    }
    return lowest;
  }

  ItemSize findSize(String name){
   try {
     return sizes.firstWhere((s) => s.name == name);
   } catch (e){
     return null;
   }

  }

}