import 'package:ecommerce_app/models/home/home_manager.dart';
import 'package:ecommerce_app/models/home/section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'List', id: '', items: [], name: ''));
            },
            style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
            child: const Text('Adicionar Lista'),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'Staggered', id: '', items: [], name: ''));
            },
            style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
            child: const Text('Adicionar Grade'),
          ),
        )
      ],
    );
  }
}
