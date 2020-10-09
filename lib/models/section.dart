import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/section_item.dart';

class Section extends ChangeNotifier {

  Section({this.id, this.name, this.items, this.type}) {
    items = items ?? [];
  }

  Section.formDocument(DocumentSnapshot document){
    id = document.id;
    name = document.get('name') as String;
    type = document.get('type') as String;
    items = (document.get('items') as List).map(
            (i) => SectionItem.fromMap(i as Map<String, dynamic>)).toList();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firetoreRef => firestore.doc('home/$id');

  String id;
  String name;
  String type;
  List<SectionItem> items;

  String _error;
  String get error => _error;
  set error(String value){
    _error = value;
    notifyListeners();
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item){
    items.remove(item);
    notifyListeners();
  }

  bool valid(){
   if(name == null || name.isEmpty){
     error = 'Título inválido';
   } else if (items.isEmpty) {
     error = 'Insira ao menos uma imagem';
   } else {
     error = null;
   }
   return error == null;
  }

  Future<void> save() async {
    final Map<String, dynamic> data = {
      'name' : name,
      'type' : type,
    };

    if(id == null){
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firetoreRef.update(data);
    }
  }

  Section clone() {
      return Section(
        id: id,
        name: name,
        type: type,
        items: items.map((e) => e.clone()).toList(),
      );
  }

    @override
    String toString() {
      return 'Section{name: $name, type: $type, items: $items}';
    }
  }
