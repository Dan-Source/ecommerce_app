import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce_app/models/user/user.dart' as costum;
import 'package:ecommerce_app/helpers/firebase_erros.dart';

class UserManager extends ChangeNotifier {

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signIn({required costum.User user, required Function onFail, required Function onSuccess }) async {
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      print(result);
      onSuccess();
    } on FirebaseException catch (e) {
      onFail(getErrorString(e.toString()));
    }
  }

}
