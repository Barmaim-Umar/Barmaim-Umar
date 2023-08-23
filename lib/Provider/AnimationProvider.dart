import 'package:flutter/foundation.dart';

class AnimationProvider with ChangeNotifier {
  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  void startAnimation() {
    _isAnimating = true;
    notifyListeners();
  }

  void stopAnimation() {
    _isAnimating = false;
    notifyListeners();
  }
}

//===

// class ButtonProvider with ChangeNotifier {
//   bool _isJumping = false;
//   bool get isJumping => _isJumping;
//
//   void jump() async {
//     _isJumping = true;
//     notifyListeners();
//     await Future.delayed(Duration(milliseconds: 500));
//     _isJumping = false;
//     notifyListeners();
//   }
// }

//===

class ButtonProvider with ChangeNotifier {
  bool _isJumping = false;
  bool get isJumping => _isJumping;

  void startJumping() async {
    while (true) {
      _isJumping = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      _isJumping = false;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void stopJumping() {
    _isJumping = false;
    notifyListeners();
  }
}
