import 'package:ecommerce_app/common/custom_drawer/costum_drawer.dart';
import 'package:ecommerce_app/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/models/page_manager.dart';

class BaseScreen extends StatelessWidget {
  static final pageController = PageController();

  const BaseScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          LoginScreen(),
          Scaffold(
            drawer: const CostumDrawer(),
            appBar: AppBar(
              title: const Text('Prazeres de Vênus'),
            ),
          ),
          Container(
            key: const Key('page1'),
            color: Colors.red,
            child: ElevatedButton(
              child: const Text('Page 1'),
              onPressed: () {
                pageController.jumpToPage(0);
              },
            ),
          ),
          Container(
            color: Colors.green,
          ),
          Container(
            color: Colors.blue,
          ),
        ]
      ),
    );
  }
}
