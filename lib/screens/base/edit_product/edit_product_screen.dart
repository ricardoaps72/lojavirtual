import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';

import 'components/images_form.dart';

class EditProductScreen extends StatelessWidget{

  const EditProductScreen(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Editar anúncio'),
       centerTitle: true,
     ),
     body: ListView(
       children:<Widget> [
         ImagesForm(product),
       ],
     ),
   );
  }
  
}