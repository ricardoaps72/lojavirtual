import 'package:brasil_fields/formatter/cep_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/common/custon_icon_button.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatelessWidget {

  CepInputField(this.address);

  final Address address;
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (address.zipCode == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
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
          RaisedButton(
              onPressed: (){
                if (Form.of(context).validate()){
                    context.read<CartManager>().getAddress(cepController.text);
                  }
              },
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
                'CEP: ${address.zipCode}',
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
