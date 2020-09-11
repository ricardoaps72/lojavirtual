import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/base/base_screen.dart';
import 'package:lojavirtual/screens/base/signup/signup_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

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
    return ChangeNotifierProvider(
      create: (_) => UserManager(),
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
            case '/signup' :
              return MaterialPageRoute(builder: (_) => SignupScreen());
            case '/base' :
            default:
              return MaterialPageRoute(builder: (_) => BaseScreen());
          }
        },
      ),
    );
  }
}
