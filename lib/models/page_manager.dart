import 'package:flutter/cupertino.dart';

class PageManager {
  final PageController _pageController;
  int page = 0;

  PageManager(this._pageController);

  void setPage(int page) {
    if(page == page) {
      return;
    }
    page = page;
    _pageController.jumpToPage(page);
  }
}
