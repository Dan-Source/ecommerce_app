
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app/models/user/address.dart';

class User {

  User({
    this.email,
    this.password,
    this.name,
  });
  String? id;
  String? email;
  String? password;
  String? name;
  String? confirmPassword;
  bool admin = false;
  Address? address;

  @override
  String toString() {
    return 'User{email: $email}';
  }

  User.fromDocument(DocumentSnapshot document) {
    id = document.id;
    email = document.get('email') as String;
    name = document.get('name') as String;
    Map<String, dynamic> dataMap = document.data() as Map<String, dynamic>;
    if (dataMap.containsKey('address')) {
      address =
          Address.fromMap(document['address'] as Map<String, dynamic>);
    }
  }

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.collection("users").doc(id);
  CollectionReference get cartReference => firestoreRef.collection('cart');


  Future<void> saveData() async {
      await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      if (address != null) 'address': address!.toMap(),
    };
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }

}
