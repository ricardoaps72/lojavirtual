import 'package:brasil_fields/formatter/cep_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/common/custon_icon_button.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {

  CepInputField(this.address);

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final cartManager = context.watch<CartManager>();

    if (widget.address.zipCode == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepController,
              decoration: const InputDecoration(
              isDense: true,
              labelText: 'Cep',
              hintText: '13.480-000',
            ),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep){
                if (cep.isEmpty)
                  return 'Campo obrigatório';
                else if (cep.length != 10)
                  return 'Cep inválido';
                return null;
            },
          ),
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
              onPressed: !cartManager.loading ? () async {
                if (Form.of(context).validate()){
                  try {
                    await context.read<CartManager>().getAddress(cepController.text);
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$e'),
                          backgroundColor: Colors.red,
                        )
                    );
                  }
                }
              } : null,
            color: Theme.of(context).primaryColor,
            disabledColor: Theme.of(context).primaryColor.withAlpha(100),
            child: Text('Buscar Cep'),
              ),
        ],
      );
    else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget> [
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: Theme.of(context).primaryColor,
              size: 20,
              onTap: (){
                context.read<CartManager>().removeAddress();
              },
            ),
          ],
        ),
      );
    }
  }
}
