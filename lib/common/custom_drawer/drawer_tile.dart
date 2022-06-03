import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/models/page_manager.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.page,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    final int currentPage = context.watch<PageManager>().page;
    final Color primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: () {
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
      height: 60,
      child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                icon,
                size: 32,
                color: currentPage == page ? primaryColor: Colors.grey[500],
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: currentPage == page ? primaryColor: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
