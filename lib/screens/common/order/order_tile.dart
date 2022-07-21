import 'package:ecommerce_app/models/order/order.dart';
import 'package:ecommerce_app/screens/common/order/cancel_order_dialog.dart';
import 'package:ecommerce_app/screens/common/order/order_product_tile.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final bool showControls;

  const OrderTile(this.order, {this.showControls = false});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.formattedId,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: primaryColor),
                ),
                Text(
                  'R\$ ${order.price!.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14),
                )
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: order.status == Status.canceled
                      ? Colors.red
                      : primaryColor,
                  fontSize: 14),
            )
          ],
        ),
        children: [
          Column(
            children: order.items!.map((e) {
              return OrderProductTile(e);
            }).toList(),
          ),
          if (showControls && order.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => CancelOrderDialog(order));
                    },
                    style:ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: order.back,
                    child: const Text('Recuar'),
                  ),
                  ElevatedButton(
                    onPressed: order.advance,
                    child: const Text('Avançar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                    },
                    style:ElevatedButton.styleFrom(
                      primary: primaryColor,
                    ),
                    child: const Text('Endereço'),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
