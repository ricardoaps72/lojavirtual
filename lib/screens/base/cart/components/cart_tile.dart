import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custon_icon_button.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {

  const CartTile(this.cartProduct);
  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 80,
                width: 80,
                child: Image.network(cartProduct.product.images.first),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Text(cartProduct.product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('Tamanho: ${cartProduct.size}',
                    style: TextStyle(fontWeight: FontWeight.w300,),
                    ),
                    ),
                    Text('R\$ ${cartProduct.unitPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                    )
                  ],
                ),
              ),
              ),
              Consumer<CartProduct>(
                  builder: (_, cartProduct, __){
                    return Column(
                      children:<Widget> [
                        CustomIconButton(
                          iconData: Icons.add,
                          color: Theme.of(context).primaryColor,
                          onTap: cartProduct.increment,
                        ),
                        Text(
                          '${cartProduct.quantity}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        CustomIconButton(
                          iconData: Icons.remove,
                          color: cartProduct.quantity > 1 ?
                          Theme.of(context).primaryColor : Colors.red,
                          onTap: cartProduct.decrement,
                        ),
                      ],
                    );
                  },
                  )
            ],
          ),
        ),
      ),
    );
  }
  
}
