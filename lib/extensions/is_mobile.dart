import 'package:flutter/material.dart';

extension IsMobile on BuildContext {
  bool get isMobile => View.of(this).physicalSize.width <= 600;
}
