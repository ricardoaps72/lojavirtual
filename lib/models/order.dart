import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/services/cielo_payment.dart';

enum Status {canceled, preparing, transporting, delivered}

class Order {

  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.productsPrice;
    userId = cartManager.userData.id;
    address = cartManager.address;
    status = Status.preparing;
  }

  Order.fromDocument(DocumentSnapshot doc){
    orderId = doc.id;

    items = (doc.get('items') as List<dynamic>).map((e){
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc.get('price') as num;
    userId = doc.get('user') as String;
    address = Address.fromMap(doc.get('address') as Map<String, dynamic>);
    date = doc.get('date') as Timestamp;
    status = Status.values[doc.get('status') as int];
    payId = doc.get('payId') as String;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.collection('orders').doc(orderId);

  void updateFromDocument(DocumentSnapshot doc){
    status = Status.values[doc.get('status') as int];
  }

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set(
      {
        'items' : items.map((e) => e.toOrderItemMap()).toList(),
        'price' : price,
        'user'  : userId,
        'address' : address.toMap(),
        'status' : status.index,
        'date' : Timestamp.now(),
        'payId': payId,
      }
    );
  }

  Function() get back{
    return status.index >= Status.transporting.index ?
        () {
            status = Status.values[status.index - 1];
            firestoreRef.update({'status' : status.index});
    } : null;
  }

  Function() get advance{
    return status.index <= Status.transporting.index ?
        () {
          status = Status.values[status.index + 1];
          firestoreRef.update({'status' : status.index});
    } : null;
  }

  Future<void> cancel() async {
    try {
      await CieloPayment().cancel(payId);
      status = Status.canceled;
      firestoreRef.update({'status': status.index});
    } catch (e) {
      return Future.error('Falha ao cancelar');
    }
  }

  List<CartProduct> items;
  num price;
  String orderId;
  String payId;
  String userId;
  Address address;
  Timestamp date;
  Status status;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  static String getStatusText(Status status){
    switch(status){
      case Status.canceled :
        return 'Cancelado';
      case Status.preparing :
        return 'Em preparação';
      case Status.transporting :
        return 'Em transporte';
      case Status.delivered :
        return 'Entregue';
      default :
        return '';
    }
  }

  String get statusText => getStatusText(status);

  @override
  String toString() {
    return 'Order{firestore: $firestore, items: $items, price: $price, orderId: $orderId, userId: $userId, address: $address, date: $date}';
  }


}