import 'package:ecommerce_app/common/custom_drawer/costom_drawer.dart';
import 'package:ecommerce_app/models/user/user_manager.dart';
import 'package:ecommerce_app/screens/login/login_screen.dart';
import 'package:ecommerce_app/screens/products/products_screen.dart';
import 'package:ecommerce_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/models/home/page_manager.dart';
class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              ProductsScreen(),
              // OrdersScreen(),
              // StoresScreen(),
              // if (userManager.adminEnabled) ...[
              //   AdminUsersScreen(),
              //   AdminOrdersScreen()
              // ]
            ],
          );
        },
      ),
    );
  }
}
