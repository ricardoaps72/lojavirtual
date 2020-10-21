import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custon_drawer/custon_drawer.dart';
import 'package:lojavirtual/common/custon_icon_button.dart';
import 'package:lojavirtual/common/empty_card.dart';
import 'package:lojavirtual/models/admin_orders_manager.dart';
import 'package:lojavirtual/models/order.dart';
import 'package:lojavirtual/screens/orders/components/order_tile.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatefulWidget {

  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustonDrawer(),
        appBar: AppBar(
          title: const Text('Todos os Pedidos'),
          centerTitle: true,
        ),
        body: Consumer<AdminOrdersManager>(
            builder: (_, ordersManager, __){
              final filteredOrders = ordersManager.filteredOrders;
              return SlidingUpPanel(
                controller: panelController,
                body: Column(
                  children: <Widget>[
                  if (ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pedidos de ${ordersManager.userFilter.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: (){
                            ordersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                  if (filteredOrders.isEmpty)
                    Expanded(
                      child: EmptyCard(
                      title : 'Nenhum pedido encontrado!',
                      iconData: Icons.border_clear,
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, index){
                        return OrderTile(
                        filteredOrders[index],
                        showControls: true,
                        );
                      }
                      ),
                    ),
                    const SizedBox(height: 120,),
                  ],
                  ),
                minHeight: 40,
                maxHeight: 240,
                panel: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        if (panelController.isPanelClosed){
                          panelController.open();
                        } else {
                          panelController.close();
                        }
                      },
                      child: Container(
                        height: 40,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Text('Filtros',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: Status.values.map((s){
                            return CheckboxListTile(
                              title: Text(Order.getStatusText(s)),
                              dense: true,
                              activeColor: Theme.of(context).primaryColor,
                              value: ordersManager.statusFilter.contains(s),
                              onChanged: (v){
                                ordersManager.setStatusFilter(
                                  status : s,
                                  enabled : v
                                );
                              },
                            );
                          }).toList(),
                        )
                    )
                  ],
                ),
              );
         })
    );
  }
}
