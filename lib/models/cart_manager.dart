import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/services/cepaberto_service.dart';

class CartManager extends ChangeNotifier {

  List<CartProduct> items = [];

  UserData userData;
  Address address;

  num productsPrice = 0.0;
  num deliveryPrice;
  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateUser(UserManager userManager){
    userData = userManager.userData;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    if(userData != null){
      _loadCartItems();
      _loadUserAddress();
    }

  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await userData.cartReference.get();
    items = cartSnap.docs.map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)).toList();

  }

  Future<void> _loadUserAddress() async {
    if(userData.address != null
    && await calculateDelivery(userData.address.lat, userData.address.long)){
      address = userData.address;
      notifyListeners();
    }
  }

  void addToCart(Product product){
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      userData.cartReference.add(cartProduct.toCartItemMap()).then((doc) => cartProduct.id = doc.id);
      _onItemUpdated();
    }
    notifyListeners();
  }

  void _onItemUpdated(){
    productsPrice = 0.0;
    for(int i = 0; i<items.length; i++){
      final cartProduct = items[i];

      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
        i--;
        continue;
      }
      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct){
    items.removeWhere((p) => p.id == cartProduct.id);
    userData.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  void clear(){
    for(final cartProduct in  items){
      userData.cartReference.doc(cartProduct.id).delete();
    }
    items.clear();
    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct){
    if(cartProduct.id != null)
      userData.cartReference.doc(cartProduct.id).update(cartProduct.toCartItemMap());
  }

  bool get isCartValid {
    for(final cartProduct in items){
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  Future<void> getAddress(String cep) async {
    loading = true;
    final cepAbertoService = CepAbertoService();
    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);
      if(cepAbertoAddress != null){
          address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          lat: cepAbertoAddress.latitude,
          long: cepAbertoAddress.longitude
        );

      }
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error('Cep inválido');
    }

  }

  Future<void> setAddress(Address address) async {
    loading = true;
    this.address = address;

    if (await calculateDelivery(address.lat, address.long)){
      userData.setAddress(address);
      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega');
    }
  }

  void removeAddress(){
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.doc('aux/delivery').get();

    final latStore = doc.get('lat') as double;
    final longStore = doc.get('long') as double;
    final maxkm = doc.get('maxkm') as num;
    final base = doc.get('base') as num;
    final km = doc.get('km') as num;

    double dis = await Geolocator().distanceBetween(latStore, longStore, lat, long);

    dis /= 1000.0;

    print('Distance $dis');

    if (dis > maxkm){
      return false;
    }

    deliveryPrice = base + dis * km;
    return true;

  }
}