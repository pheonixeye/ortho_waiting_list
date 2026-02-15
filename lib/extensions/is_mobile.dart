import 'package:flutter/material.dart';

extension IsMobile on BuildContext {
  bool get isMobile => MediaQuery.widthOf(this) <= 600;
}
