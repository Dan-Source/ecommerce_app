import 'package:ecommerce_app/models/order/order.dart';
import 'package:flutter/material.dart';

class CancelOrderDialog extends StatefulWidget {
  final Order order;

  const CancelOrderDialog(this.order);

  @override
  _CancelOrderDialogState createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        title: Text('Cancelar ${widget.order.formattedId}?'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loading
                ? 'Cancelando...'
                : 'Esta ação não poderá ser desfeita!'),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  error ?? '',
                  style: const TextStyle(color: Colors.red),
                ),
              )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: !loading
                ? () {
                    Navigator.of(context).pop();
                  }
                : null,
            child: const Text('Voltar'),
          ),
          ElevatedButton(
            onPressed: !loading
                ? () async {
                    setState(() {
                      loading = true;
                    });
                    try {
                      await widget.order.cancel();
                      Navigator.of(context).pop();
                    } catch (e) {
                      setState(() {
                        loading = false;
                        error = e.toString();
                      });
                    }
                  }
                : () {},
            style:ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text('Cancelar Pedido'),
          )
        ],
      ),
    );
  }
}
