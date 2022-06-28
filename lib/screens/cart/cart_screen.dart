import 'package:ecommerce_app/models/cart/cart_manager.dart';
import 'package:ecommerce_app/screens/cart/components/cart_tile.dart';
import 'package:ecommerce_app/screens/common/empty_card.dart';
import 'package:ecommerce_app/screens/common/login_card.dart';
import 'package:ecommerce_app/screens/common/price_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          if (cartManager.user == null) {
            return LoginCard();
          }

          if (cartManager.items.isEmpty) {
            return const EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum produto no carrinho!',
            );
          }

          print(cartManager.isAddressValid);
          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct: cartProduct))
                    .toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para Entrega',
                onPressed: !cartManager.isCartValid
                    ? () {
                        Navigator.of(context).pushNamed('/address');
                      }
                    : () {},
              ),
            ],
          );
        },
      ),
    );
  }
}