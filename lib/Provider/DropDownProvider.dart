import 'package:flutter/foundation.dart';
import 'package:pfc/utility/global.dart';

class DropdownProvider with ChangeNotifier {
  String _dropdownValue = 'item1';

  String get dropdownValue => _dropdownValue;

  void setDropdownValue() {
    _dropdownValue = GlobalClass.dropdownValue;
    notifyListeners();
  }
}
