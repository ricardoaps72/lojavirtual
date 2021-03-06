import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:lojavirtual/helpers/validators.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(onPressed: (){
            Navigator.of(context).pushReplacementNamed('/signup');
            },
              textColor: Colors.white,
              child: const Text(
            'CRIAR CONTA',
            style: TextStyle(fontSize: 14),
          ))
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key : formKey,
            child: Consumer<UserManager>(
                builder: (_, userManager, __){
                  if(userManager.loadingFace){
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                       valueColor: AlwaysStoppedAnimation(
                         Theme.of(context).primaryColor
                       ),
                      ),
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: <Widget>[
                    TextFormField(
                    controller: emailController,
                    enabled: !userManager.loading,
                    decoration: const InputDecoration(hintText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (email){
                    if (!emailValid(email))
                      return 'E-mail inválido';
                    return null;
                    }
                    ,
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                    controller: passController,
                    enabled: !userManager.loading,
                    decoration: const InputDecoration(hintText: 'senha'),
                    autocorrect: false,
                    obscureText: true,
                    validator: (pass){
                    if (pass.isEmpty || pass.length < 6)
                      return 'Senha inválida';
                    return null;
                    }
                    ,
                    ),
                    Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(onPressed: (){

                    },
                    child: const Text(
                    'Esqueci minha senha'
                    )
                    ),
                    ),
                    const SizedBox(height: 16,),
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: userManager.loading ? null : (){
                    if (formKey.currentState.validate()){
                    context.read<UserManager>().signIn(
                      user : UserData(
                      email: emailController.text,
                      password: passController.text
                      ),
                    onFail: (e){
                    scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                      content: Text(('Falha ao entrar : $e')),
                      backgroundColor: Colors.red,
                      )
                    );
                      },
                    onSuccess: (){
                        Navigator.of(context).pop();

                    }

                    );

                    //debugPrint('email:' + emailController.text);
                    //debugPrint('senha:' + passController.text);
                    }
                    },
                      color: Theme.of(context).primaryColor,
                      disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      child: userManager.loading ?
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ) :
                    const Text(
                    'Entrar',
                    style: TextStyle(
                    fontSize: 15
                    ),
                    ),
                    ),
                    SignInButton(
                          Buttons.Facebook,
                          text: 'Entrar com Facebook',
                          onPressed: (){
                            userManager.facebookLogin(
                                onFail: (e){
                                  scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(('Falha ao entrar : $e')),
                                        backgroundColor: Colors.red,
                                      )
                                  );
                                },
                                onSuccess: (){
                                  Navigator.of(context).pop();

                                }
                            );
                          }
                    ),
                    ],
                    );
          }),
        ),
      ),
     ),
    );
  }



}