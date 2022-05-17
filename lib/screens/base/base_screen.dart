import 'package:ecommerce_app/common/custom_drawer/costum_drawer.dart';
import 'package:flutter/material.dart';


class BaseScreen extends StatelessWidget {
  static final pageController = PageController();

  const BaseScreen({
    Key? key,
  }) : super(key: key);
  // final PageController pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
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
              pageController.jumpToPage(1);
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
    );
  }
}
