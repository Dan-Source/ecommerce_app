import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/cart/cart_manager.dart';
import 'package:ecommerce_app/models/cart/cart_product.dart';
import 'package:ecommerce_app/models/user/address.dart';
import 'package:ecommerce_app/services/cielo_payment.dart';

enum Status { canceled, preparing, transporting, delivered }

class Order {
  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;

    items = (doc['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc['price'] as num;
    userId = doc['user'] as String;
    address = Address.fromMap(doc['address'] as Map<String, dynamic>);
    date = doc['date'] as Timestamp;

    status = Status.values[doc['status'] as int];

    payId = doc['payId'] as String;
  }

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user!.id!;
    address = cartManager.address!;
    status = Status.preparing;
  }

  String? orderId;
  String? payId;

  List<CartProduct>? items;
  num? price;
  String? userId;
  Address? address;
  late Status status;
  Timestamp? date;

  String get formattedId => '#${orderId!.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparação';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef =>
      firestore.collection('orders').doc(orderId);

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc['status'] as int];
  }

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set({
      'items': items!.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address!.toMap(),
      'status': status.index,
      'date': Timestamp.now(),
      'payId': payId
    });
  }

  Function() get back {
    return status.index >= Status.transporting.index
        ? () {
            status = Status.values[status.index - 1];
            firestoreRef.update({'status': status.index});
          }
        : () {};
  }

  Function() get advance {
    return status.index <= Status.transporting.index
        ? () {
            status = Status.values[status.index + 1];
            firestoreRef.update({'status': status.index});
          }
        : () {};
  }

  Future<void> cancel() async {
    try {
      // await CieloPayment().cancel(payId);
      // status = Status.canceled;
      // firestoreRef.updateData({'status': status.index});
    } catch (e) {
      return Future.error("Falha ao cancelar");
    }
  }

  @override
  String toString() {
    return 'Order{orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
