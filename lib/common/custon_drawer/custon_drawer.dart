import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custon_drawer/drawer_title.dart';

class CustonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerTitle(
            iconData: Icons.home,
            title: 'Inicio',
            page: 0,
          ),
          DrawerTitle(
            iconData: Icons.list,
            title: 'Produtos',
            page: 1,
          ),
          DrawerTitle(
            iconData: Icons.playlist_add_check,
            title: 'Meus Pedidos',
            page: 2,
          ),
          DrawerTitle(
            iconData: Icons.location_on,
            title: 'Lojas',
            page: 3,
          ),
        ],
      ),
    );
  }
}
