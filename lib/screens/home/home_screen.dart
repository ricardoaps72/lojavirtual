import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custon_drawer/custon_drawer.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/models/section.dart';
import 'package:provider/provider.dart';

import 'components/section_list.dart';
import 'components/section_staggered.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustonDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168)
              ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )
            ),
          ),
          CustomScrollView(
            slivers:<Widget> [
              SliverAppBar(
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Loja virtual'),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.shopping_cart),
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ),
                ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __){
                final List<Widget> children = homeManager.sections.map<Widget>((section) {
                  switch(section.type){
                    case 'List':
                      return SectionList(section);
                    case 'Staggered':
                      return SectionStaggered(section);
                    default:
                      return Container();
                  }

                }).toList();
                return SliverList(
                  delegate: SliverChildListDelegate(children),
                );
              },
              )
            ],
          ),
        ],
      ),
    );
  }

}