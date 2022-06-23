import 'package:flutter/cupertino.dart';

class PageManager {
  final PageController _pageController;
  int page = 0;

  PageManager(this._pageController);

  void setPage(int value) {
    if(page == value) {
      return;
    }
    page = value;
    _pageController.jumpToPage(value);
  }
}
