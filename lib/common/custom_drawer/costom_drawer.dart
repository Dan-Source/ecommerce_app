import 'package:ecommerce_app/common/custom_drawer/costom_drawer_header.dart';
import 'package:ecommerce_app/common/custom_drawer/drawer_tile.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const CustomDrawerHeader customDrawerHeader = CustomDrawerHeader();
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
    const Divider divider = Divider();
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 201, 201),
                  Color.fromARGB(255, 246, 246, 246),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
        ),
        ListView(
          padding: EdgeInsets.zero,
          children: const [
            customDrawerHeader,
            divider,
            home,
            products,
            order,
            shops,
          ],
        ),
        ],
      ),
    );
  }
}
