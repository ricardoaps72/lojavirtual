import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custon_drawer/custon_drawer.dart';
import 'package:lojavirtual/common/empty_card.dart';
import 'package:lojavirtual/common/login_card.dart';
import 'package:lojavirtual/models/orders_manager.dart';
import 'package:provider/provider.dart';

import 'components/order_tile.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustonDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
          builder: (_, ordersManager, __){
            if(ordersManager.user == null){
              return LoginCard();
            }
            if (ordersManager.orders.isEmpty){
              return EmptyCard(
                title : 'Nenhuma compra encontrada!',
                iconData: Icons.border_clear,
              );
          }
          return ListView.builder(
          itemCount: ordersManager.orders.length,
          itemBuilder: (_, index){
            return OrderTile(
              ordersManager.orders.reversed.toList()[index]
            );
              }
              );
        })
    );
  }
}