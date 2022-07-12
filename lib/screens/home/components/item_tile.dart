import 'dart:io';

import 'package:ecommerce_app/models/home/home_manager.dart';
import 'package:ecommerce_app/models/home/section.dart';
import 'package:ecommerce_app/models/home/section_item.dart';
import 'package:ecommerce_app/models/product/product.dart';
import 'package:ecommerce_app/models/product/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {
  final SectionItem item;

  const ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product =
              context.read<ProductManager>().findProductById(item.product!);

          if (product != null) {
            Navigator.of(context).pushNamed('/product', arguments: product);
          }
        }
      },
      onLongPress: homeManager.editing
          ? () {
              showDialog(
                  context: context,
                  builder: (_) {
                    final product;
                    if(item.product != null){
                      product = context
                          .read<ProductManager>()
                          .findProductById(item.product!);
                    } else {
                      product = null;
                    }
                    return AlertDialog(
                      title: const Text('Editar Item'),
                      content: product != null
                          ? ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Image.network(product.images.first as String),
                              title: Text(product.name! as String),
                              subtitle: Text(
                                  'R\$ ${product.basePrice.toStringAsFixed(2)}',),
                            )
                          : null,
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            context.read<Section>().removeItem(item);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            textStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: const Text('Excluir'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (product != null) {
                              item.product = null;
                            } else {
                              final Product product =
                                  await Navigator.of(context)
                                  .pushNamed('/select_product') as Product;
                              item.product = product.id;
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(
                              product != null ? 'Desvincular' : 'Vincular'),
                        )
                      ],
                    );
                  });
            }
          : null,
      child: AspectRatio(
          aspectRatio: 1,
          child: item.image is String
              ? FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: item.image as String,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  item.image as File,
                  fit: BoxFit.cover,
                )),
    );
  }
}
