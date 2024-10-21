import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sikors/core/design/color.dart';

class DefTypography {
  static const defaultLetterSpacing = 0.0;
  static const iosLetterSpacing = -0.5;

  static final letterSpacing =
      !kIsWeb && Platform.isIOS ? iosLetterSpacing : defaultLetterSpacing;

  static final TextStyle def = TextStyle(
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacing,
    color: DefColor.colorBlack,
    decoration: TextDecoration.none,
  );

  static final TextStyle defB = TextStyle(
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
    letterSpacing: letterSpacing,
    color: DefColor.colorBlack,
    decoration: TextDecoration.none,
  );

  // title
  static TextStyle titleLarge = defB.copyWith(fontSize: 22);
  static TextStyle titleMedium = defB.copyWith(fontSize: 16);
  static TextStyle titleSmall = defB.copyWith(fontSize: 14);

  // body
  static TextStyle bodyLarge = def.copyWith(
    fontSize: 16,
    height: 1.5,
  );
  static TextStyle bodyMedium = def.copyWith(
    fontSize: 14,
    height: 1.5,
  );
  static TextStyle bodySmall = def.copyWith(
    fontSize: 12,
    height: 1.5,
  );

  // headline
  static TextStyle headlineLarge = def.copyWith(fontSize: 32);
  static TextStyle headlineMedium = def.copyWith(fontSize: 28);
  static TextStyle headlineSmall = def.copyWith(fontSize: 24);
}
