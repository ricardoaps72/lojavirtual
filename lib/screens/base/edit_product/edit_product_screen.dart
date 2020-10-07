import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';

import 'components/images_form.dart';
import 'components/sizes_form.dart';

class EditProductScreen extends StatelessWidget{

  EditProductScreen(this.product);
  final Product product;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Editar anúncio'),
       centerTitle: true,
     ),
     backgroundColor: Colors.white,
     body: Form(
       key: formKey,
       child: ListView(
         children:<Widget> [
           ImagesForm(product),
           Padding(
             padding: const EdgeInsets.all(16),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 TextFormField(
                   initialValue: product.name,
                   decoration: const InputDecoration(
                     hintText: 'Titulo',
                     border: InputBorder.none,
                   ),
                   style: TextStyle(
                     fontSize: 20,
                     fontWeight: FontWeight.w600,
                   ),
                   validator: (name){
                     if (name.length < 6 )
                       return 'Título muito curto';
                     return null;
                   },
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top: 4),
                   child: Text(
                     'A partir de',
                     style: TextStyle(
                       color: Colors.grey[600],
                       fontSize: 13,
                     ),
                   ),
                 ),
                 Text(
                   // :TODO trocar para o preço correto
                   'R\$ ...',
                   style: TextStyle(
                     fontSize: 22.0,
                     fontWeight: FontWeight.bold,
                     color: Theme.of(context).primaryColor,
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top: 16),
                   child: Text(
                     'Descrição',
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.w500,
                     ),
                   ),
                 ),
                 TextFormField(
                   initialValue: product.description,
                   style: const TextStyle(
                       fontSize: 16
                   ),
                   decoration: const InputDecoration(
                     hintText: 'Descrição',
                     border: InputBorder.none,
                   ),
                   maxLines: null,
                   validator: (desc){
                     if(desc.length < 10)
                       return 'Descrição muito curta';
                     return null;
                   },
                 ),
                 SizesForm(product),
                 RaisedButton(onPressed: (){
                   if(formKey.currentState.validate()){

                   }else{

                   }
                  },
                  child: const Text('Salvar'),
                 ),
               ],
             ),
           )
         ],
       ),
     ),
   );
  }
  
}