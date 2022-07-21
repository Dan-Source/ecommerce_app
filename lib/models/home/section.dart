import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/home/section_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {

  late String id;
  late String name;
  late String type;
  late List<SectionItem> items;

  late List<SectionItem> originalItems;

  Section({
    required this.id,
    required this.name,
    required this.type,
    required this.items}) {
    originalItems = List.from(items);
  }

  Section.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    type = document['type'] as String;
    items = (document['items'] as List<dynamic>)
        .map((i) => SectionItem.fromMap(i as Map<String, dynamic>))
        .toList();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('home/$id');
  Reference get storageRef => storage.ref().child('home/$id');


  String _error = '';

  String get error => _error;

  set error(String value) {
    _error = value;
    notifyListeners();
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {'name': name, 'type': type, 'pos': pos};

    if (id.isEmpty) {
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    int count = 0;
    bool updated = false;

    for (final item in items) {
      if (item.image is File) {
        final Reference file = storageRef.child(Uuid().v1());
        UploadTask task = file.putFile(item.image as File);
        task.snapshotEvents.listen((TaskSnapshot snapshot) async {
          if (snapshot.state == TaskState.running) {
            print('Uploading...');
          } else if (snapshot.state == TaskState.success) {
            print('Uploaded');
            final String url = await snapshot.ref.getDownloadURL();
            count++;
            item.image = url;

            if(count == items.length){
              try {
                final Map<String, dynamic> itemsData = {
                  'items': items.map((e) => e.toMap()).toList()
                };
              await firestore.doc('home/$id').update(itemsData);
                print('Fez o upload!');
              } catch (e) {
                debugPrint('Error no upload de imagem do seções!');
              }
            }
          } else {
            count++;
          }
        });
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original) &&
          (original.image as String).contains('firebase')) {
        try {
          final ref = storage.refFromURL(original.image as String);
          await ref.delete();
          // ignore: empty_catches
        } catch (e) {}
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await firestoreRef.update(itemsData);
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      if ((item.image as String).contains('firebase')) {
        try {
          final ref = storage.refFromURL(item.image as String);
          await ref.delete();
          // ignore: empty_catches
        } catch (e) {}
      }
    }
  }

  bool valid() {
    if (name.isEmpty) {
      error = 'Título inválido';
    } else if (items.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = '';
    }

    return error.isEmpty;
  }

  Section clone() {
    return Section(
        id: id,
        name: name,
        type: type,
        items: items.map((e) => e.clone()).toList());
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
