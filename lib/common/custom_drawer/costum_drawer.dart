import 'package:flutter/material.dart';
import 'drawer_tile.dart';

class CostumDrawer extends StatelessWidget {
  const CostumDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const DrawerTile home = DrawerTile(
      icon: Icons.home,
      title: 'Início',
      page: 0,
    );
    const DrawerTile products = DrawerTile(
      icon: Icons.list,
      title: 'Produtos',
      page: 1,
    );
    const DrawerTile order = DrawerTile(
      icon: Icons.playlist_add_check,
      title: 'Meus Pedidos',
      page: 2,
    );
    const DrawerTile shops = DrawerTile(
      icon: Icons.location_on,
      title: 'Lojas',
      page: 3,
    );
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          home,
          products,
          order,
          shops,
        ],
      ),
    );
  }
}
