import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/user/user.dart';
import 'package:ecommerce_app/models/user/user_manager.dart';
import 'package:flutter/cupertino.dart';

class AdminUsersManager extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription? _subscription;
  List<User> users = [];

  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    _subscription =
        firestore.collection('users').snapshots().listen(
          (snapshot) {
            users = snapshot.docs.map(
              (u) => User.fromDocument(u),
            ).toList();
            users
                .sort(
                  (a, b) => a.name!.toLowerCase().compareTo(
                      b.name!.toLowerCase(),
                    ),
                  );
      notifyListeners();
    });
  }

  List<String> get names => List<String>.from(users.map((e) => e.name).toList());

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
