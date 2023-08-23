
import 'package:flutter/material.dart';


class FragmentsNotifier extends ChangeNotifier {
  int FragmentVariable = 0;


  void changeFragmentVariable(int SelectedFragmentVariable) {
    FragmentVariable = SelectedFragmentVariable;
    notifyListeners();
  }
}