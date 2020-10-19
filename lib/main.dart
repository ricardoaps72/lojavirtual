import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/admin_users_manager.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/address/address_screen.dart';
import 'package:lojavirtual/screens/base/base_screen.dart';
import 'package:lojavirtual/screens/base/cart/cart_screen.dart';
import 'package:lojavirtual/screens/base/edit_product/edit_product_screen.dart';
import 'package:lojavirtual/screens/base/login/login_screen.dart';
import 'package:lojavirtual/screens/base/product/product_screen.dart';
import 'package:lojavirtual/screens/base/select_product/select_product_screen.dart';
import 'package:lojavirtual/screens/base/signup/signup_screen.dart';
import 'package:lojavirtual/screens/checkout/checkout_screen.dart';
import 'package:lojavirtual/services/cepaberto_service.dart';
import 'package:provider/provider.dart';

import 'models/home_manager.dart';
import 'models/product.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  CepAbertoService().getAddressFromCep('13.483-081').then((address) => print(address));

  //FirebaseFirestore.instance.collection('teste').add({'teste': 'teste'});

  //DocumentSnapshot document = await FirebaseFirestore.instance.collection('pedidos').doc('1').get();
  //print(document.get('data'));
  //print(document.get('valor'));
  //print(document.get('pedido_id'));

  /* FirebaseFirestore.instance
      .collection('pedidos')
      .doc('1')
      .snapshots()
      .listen((event) {
    print(event.data());
  });

  FirebaseFirestore.instance
      .collection('pedidos')
      .doc('2')
      .set({'valor': 300, 'pedido_id': 2, 'data': '03/09/2020'});
  FirebaseFirestore.instance
      .collection('pedidos')
      .doc('3')
      .set({'valor': 450, 'pedido_id': 3, 'data': '03/09/2020'});

  //atualizar
  FirebaseFirestore.instance
      .collection('pedidos')
      .doc('3')
      .update({'valor': 850});
  //pega todos documentos da collection
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('pedidos').get();
  for(DocumentSnapshot document in snapshot.docs){
    print(document.data());
  }
  // listar qq alteração na collection
  FirebaseFirestore.instance.collection('pedidos').snapshots().listen((snapshot) {
    for(DocumentSnapshot document in snapshot.docs) {
      print(document.data());
    }
  }); */
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
            create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update:(_, userManager, cartManager) => cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
            create: (_) => AdminUsersManager(),
            lazy: false,
            update: (_, userManager, adminUsersManager) => adminUsersManager..updateUser(userManager),
        )
      ],
      child: MaterialApp(
        title: 'Cloud Loja Virtual',

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //primarySwatch: Colors.blue,
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: const AppBarTheme(
            elevation: 0
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login' :
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/signup' :
              return MaterialPageRoute(builder: (_) => SignupScreen());
            case '/product' :
              return MaterialPageRoute(builder: (_) => ProductScreen(
                settings.arguments as Product
              ));
            case '/cart' :
              return MaterialPageRoute(builder: (_) => CartScreen(),
                settings : settings
              );
            case '/address' :
              return MaterialPageRoute(builder: (_) => AddressScreen());
            case '/checkout' :
              return MaterialPageRoute(builder: (_) => CheckoutScreen());
            case '/select_product' :
              return MaterialPageRoute(builder: (_) => SelectProductScreen());
            case '/edit_product' :
              return MaterialPageRoute(builder: (_) => EditProductScreen(
                settings.arguments as Product
              ));
            case '/base' :
            default:
              return MaterialPageRoute(builder: (_) => BaseScreen(),
              settings: settings
              );
          }
        },
      ),
    );
  }
}
