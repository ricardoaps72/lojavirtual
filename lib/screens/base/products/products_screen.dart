import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custon_drawer/custon_drawer.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/screens/base/products/components/product_list_tile.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';

class ProductsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustonDrawer(),
      appBar: AppBar(
        title: Consumer<ProductManager>(
            builder: (_, productManager, __){
              if (productManager.search.isEmpty){
                return const Text('Produtos');
              } else {
                return LayoutBuilder(
                    builder: (_, constraints){
                      return GestureDetector(
                        onTap: () async {
                          final search = await showDialog<String>(context: context, builder: (_) => SearchDialog(
                            productManager.search
                          ));
                          if (search != null){
                            productManager.search = search;
                          }
                        },
                        child: Container(
                         width: constraints.biggest.width,
                          child: Text(
                              productManager.search,
                            textAlign: TextAlign.center,
                          )
                        ),
                      );
                    },
                );
              }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ProductManager>(
              builder: (_, productManager, __){
                if (productManager.search.isEmpty){
                  return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      final search = await showDialog<String>(context: context, builder: (_) => SearchDialog(
                        productManager.search
                      ));
                      if (search != null){
                        productManager.search = search;
                      }
                    },
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () async {
                        productManager.search = '';
                      },
                  );
                }
              },
              )
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __){
          final filteredProducts = productManager.filteredProducts;
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredProducts.length,
              itemBuilder: (_, index){
               return ProductListTile(filteredProducts[index]);
              }
          );
        },
      ),
    );
  }

}