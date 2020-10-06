import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custon_drawer/custon_drawer_header.dart';
import 'package:lojavirtual/common/custon_drawer/drawer_title.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget> [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 203, 236, 241),
                    Colors.white,
              ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
          ),
          ListView(
            children: <Widget>[
              CustonDrawerHeader(),
              const Divider(),
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
              Consumer<UserManager>(
                  builder: (_, userManager, __){
                    if (userManager.adminEnabled){
                      return Column(
                        children: <Widget>[
                        const Divider(),
                            DrawerTitle(
                              iconData: Icons.settings,
                              title: 'Usuários',
                              page: 4,
                            ),
                            DrawerTitle(
                              iconData: Icons.settings,
                              title: 'Pedidos',
                              page: 5,
                            ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
              )
            ],
          ),
        ],
      ),
    );
  }
}
