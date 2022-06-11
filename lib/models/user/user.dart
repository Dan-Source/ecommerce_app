
import 'package:cloud_firestore/cloud_firestore.dart';

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


  @override
  String toString() {
    return 'User{email: $email}';
  }

  User.fromDocument(DocumentSnapshot document) {
    id = document.id;
    email = document.get('email') as String;
    name = document.get('name') as String;
  }

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.collection("users").doc(id);

  Future<void> saveData() async {
      await FirebaseFirestore.instance.collection("users").add(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
    };
  }
}
