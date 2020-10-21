import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/order.dart';
import 'package:lojavirtual/models/product.dart';

class CheckoutManager extends ChangeNotifier {

  CartManager cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance; 

  void updateCart(CartManager cartManager){
    this.cartManager = cartManager;
    print(cartManager.productsPrice);
  }

  Future<void> checkout({Function onStockFail, Function onSuccess}) async {
    loading = true;
    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e);
      loading = false;
      return;
    }

    //TODO: PROCESSAR PAGAMENTO

    final orderId = await _getOrderId();
    final order = Order.fromCartManager(cartManager);
    order.orderId = orderId.toString();

    await order.save();

    cartManager.clear();

    onSuccess(order);
    loading = false;

  }

  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');
    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc.get('current') as int;
        tx.update(ref, {'current':orderId + 1});
        return {'orderId':orderId};
      });
      return result['orderId'];
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gera número do pedido');
    }
  }

  Future <void> _decrementStock(){
    return firestore.runTransaction((tx) async {

      final List<Product> productsToUpate = [];
      final List<Product> productsWithoutStock = [];

      for(final cartProduct in cartManager.items){
        Product product;
        if (productsToUpate.any((p) => p.id == cartProduct.productId)){
          product = productsToUpate.firstWhere(
                  (p) => p.id == cartProduct.productId);
        } else {
          final doc = await tx.get(
              firestore.doc('products/${cartProduct.productId}')
          );
          product = Product.fromDocument(doc);
        }
        cartProduct.product = product;

        final size = product.findSize(cartProduct.size);
        if (size.stock - cartProduct.quantity < 0) {
          productsWithoutStock.add(product);
        } else {
          size.stock -= cartProduct.quantity;
          productsToUpate.add(product);
        }
      }
      if (productsWithoutStock.isNotEmpty){
        return Future.error('${productsWithoutStock.length} produto(s) sem estoque');
      }
      for (final product in productsToUpate){
        tx.update(
            firestore.doc('products/${product.id}'),
            {'sizes' : product.exportSizeList()});
      }
    });
  }
}