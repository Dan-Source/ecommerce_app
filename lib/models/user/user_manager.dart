import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ecommerce_app/models/user/user.dart' as costum;
import 'package:ecommerce_app/helpers/firebase_erros.dart';

class UserManager extends ChangeNotifier {
  costum.User? user;

  UserManager() {
    _loadCurrentUser();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  bool _loading = false;
  bool get isLoggedIn => user != null;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signIn({required costum.User user, required Function onFail, required Function onSuccess }) async {
    // loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user.email!, password: user.password!
      );
      await _loadCurrentUser(user: result);
      onSuccess();
    } on FirebaseException catch (e) {
      onFail(getErrorString(e.toString()));
    }
    //loading = false;
  }

  Future<void> signUp({required costum.User user, required Function onFail, required Function onSuccess }) async {
    loading = true;
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!
      );
      user.id = result.user!.uid;
      await user.saveData();
      onSuccess();
    } on FirebaseException catch (e) {
      loading = false;
      onFail(getErrorString(e.toString()));
    }
    loading = false;
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({UserCredential? user}) async {
    User? result;

    if (user == null) {
      result = auth.currentUser;
    } else {
      result = user.user;
    }
    final uid = result!.uid;
    if (result != null) {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
        this.user = costum.User.fromDocument(doc);
    }
    final docAdmin = await FirebaseFirestore.instance
      .collection('admins').doc(this.user!.id).get();
    if (docAdmin.exists){
      this.user!.admin = true;
    }

    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  bool get adminEnabled => user != null && user!.admin;

}
