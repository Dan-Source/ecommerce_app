import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ecommerce_app/models/product/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager(){
    _loadAllProducts();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Product> allProducts = [];

  String _search = '';

  String get search => _search;

  set search(String value) {
    _search = value;
    print(_search);
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(allProducts
          .where((p) => p.name!.toLowerCase().contains(search.toLowerCase())));
    }
    return filteredProducts;
  }


  Future<void> _loadAllProducts() async {
    try {
      final QuerySnapshot snapProducts = await firestore
          .collection('products')
          .where('deleted', isEqualTo: false)
          .get();
      print(snapProducts.docs);
      allProducts = snapProducts.docs
        .map((doc) => Product.fromDocument(doc))
        .toList();
      notifyListeners();
    } on Exception catch (e) {
      // TODO
    }
  }

}
