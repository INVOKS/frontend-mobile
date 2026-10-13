import 'package:flutter/foundation.dart';

class SidebarController extends ChangeNotifier {
  bool _isOpen = false;
  int _selectedMenuIndex = 0;

  bool get isOpen => _isOpen;
  int get selectedMenuIndex => _selectedMenuIndex;

  void openSidebar() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  void closeSidebar() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  void toggleSidebar() {
    _isOpen = !_isOpen;
    notifyListeners();
  }

  void selectMenu(int index) {
    if (index == _selectedMenuIndex) return;
    _selectedMenuIndex = index;
    notifyListeners();
  }
}
