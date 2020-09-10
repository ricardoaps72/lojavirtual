import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custon_drawer/custon_drawer.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:lojavirtual/screens/base/login/login_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {

    return Provider(
        create: (_) => PageManager(pageController),
        child : PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
           LoginScreen(),
            Scaffold(
              drawer: CustonDrawer(),
              appBar: AppBar(
                title: const Text('Home'),
              ),
            ),
            Scaffold(
              drawer: CustonDrawer(),
              appBar: AppBar(
                title: const Text('Home2'),
              ),
            ),
            Scaffold(
              drawer: CustonDrawer(),
              appBar: AppBar(
                title: const Text('Home3'),
              ),
            ),
            Scaffold(
              drawer: CustonDrawer(),
              appBar: AppBar(
                title: const Text('Home4'),
              ),
            ),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.yellow,
            ),
            Container(
              color: Colors.green,
            ),
          ],
        ),
    );
  }
}
