import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce_app/models/user/user.dart' as costum;
import 'package:ecommerce_app/helpers/firebase_erros.dart';

class UserManager extends ChangeNotifier {

  UserManager() {
    _loadCurrentUser();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  User user;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signIn({required costum.User user, required Function onFail, required Function onSuccess }) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
          user = result as costum.User;
      onSuccess();
    } on FirebaseException catch (e) {
      onFail(getErrorString(e.toString()));
    }
    loading = false;
  }

  Future<void> _loadCurrentUser({required UserCredential user}) async {
    this.user = user as User;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

}
