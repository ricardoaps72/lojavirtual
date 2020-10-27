import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/common/custon_drawer/custon_drawer.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/admin_orders/admin_orders_screen.dart';
import 'package:lojavirtual/screens/admins_users/admin_users_screen.dart';
import 'package:lojavirtual/screens/base/login/login_screen.dart';
import 'package:lojavirtual/screens/base/products/products_screen.dart';
import 'package:lojavirtual/screens/home/home_screen.dart';
import 'package:lojavirtual/screens/orders/orders_screen.dart';
import 'package:lojavirtual/screens/stores/stores_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();


  @override
  void initState() {
    super.initState();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp
      ]);
  }

  @override
  Widget build(BuildContext context) {

    return Provider(
        create: (_) => PageManager(pageController),
        child : Consumer<UserManager>(
          builder: (_, userManager, __){
            return PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                // LoginScreen(),
                HomeScreen(),
                ProductsScreen(),
                OrdersScreen(),
                StoresScreen(),
                if(userManager.adminEnabled)
                  ...[
                    AdminUsersScreen(),
                    AdminOrdersScreen(),
                  ]
              ],
            );
          } ,
        ),
    );
  }
}
