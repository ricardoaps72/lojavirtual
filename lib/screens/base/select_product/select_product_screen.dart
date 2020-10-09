import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:provider/provider.dart';

class SelectProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular produto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Consumer<ProductManager>(
        builder: (_, productManger, __){
          return ListView.builder(
              itemCount: productManger.allProducts.length,
              itemBuilder: (_, index){
                final product = productManger.allProducts[index];
                return ListTile(
                  leading: Image.network(product.images.first),
                  title: Text(product.name),
                  subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
                  onTap: (){
                    Navigator.of(context).pop(product);
                  },
                );
              },
          );
        }
      ),

    );
  }

}