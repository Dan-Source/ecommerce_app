import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/product/item_size.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';


class Product extends ChangeNotifier {

  Product(
    {
      this.id,
      this.name,
      this.description,
      this.images,
      this.sizes,
      this.deleted = false,
    }) {
      images = images ?? [];
      sizes = sizes ?? [];
    }

  String? id;
  String? name = '';
  String? description =  '';
  List<String>? images;
  List<ItemSize>? sizes;
  bool? deleted;


  Product.fromDocument(DocumentSnapshot document) {
    print(document.data());
    id = document.id;
    name = document.get('name') as String;
    description = document.get('description') as String;
    images = List<String>.from(document.get('images') as List<dynamic>);
    sizes = List<dynamic>.from(document.get('sizes') as List<dynamic>)
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
    // deleted = (document.get('deleted') ?? false) as bool;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.collection('products').doc(id);
  Reference get storageRef => storage.ref().child('products').child(id!);

  List<dynamic>? newImages;

  String? get getName => name;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes!) {
      if (size.price! < lowest) {
        lowest = size.price!;
      }
    }
    return lowest.isNaN ? 0 : lowest;
  }

  ItemSize _selectedSize = ItemSize();
  ItemSize get selectedSize => _selectedSize;
  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes!) {
      stock += size.stock!;
    }
    return stock;
  }

  bool get hasStock {
    // return totalStock > 0 && deleted!;
    return totalStock > 0;
  }

  ItemSize? findSize(String name) {
    try {
      return sizes!.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> exportSizeList() {
    return sizes!.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;

    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
      'deleted': deleted
    };

    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      await firestoreRef.set(data);
    }

    final List<String> updateImages = [];

    for (final newImage in newImages!) {
      if (images!.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final UploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);
        final TaskSnapshot snapshot = await task;
        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }

    for (final image in images!) {
      if (!newImages!.contains(image) && image.contains('firebase')) {
        try {
          final ref = await storage.ref(image).getDownloadURL();
          //await ref.delete();
          // ignore: empty_catches
        } catch (e) {}
      }
    }

    await firestoreRef.set({'images': updateImages});
    images = updateImages;

    loading = false;
  }

  void delete() {
    firestoreRef.set({'deleted': true});
  }

  Product clone() {
    return Product(
        id: id,
        name: name,
        description: description,
        images: List.from(images!),
        sizes: sizes!.map((size) => size.clone()).toList(),
        // deleted: deleted
      );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, sizes: $sizes, newImages: $newImages}';
  }
}
