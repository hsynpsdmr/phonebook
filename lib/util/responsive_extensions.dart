import 'dart:math';

import 'package:flutter/material.dart';

extension ResponsiveExtensions on BuildContext {
  MediaQueryData get _mediaQuery => MediaQuery.of(this);
  double get height => _mediaQuery.size.height;
  double get width => _mediaQuery.size.width;
  double get heightScale => height / 932;
  double get widthScale => width / 430;
  double get scaleFactor => min(heightScale, widthScale);

  double getScale(double scale) => scale * scaleFactor;
  double getHeight(double height) => height * scaleFactor;
  double getWidth(double width) => width * scaleFactor;
  double getFontSize(double size) => size * scaleFactor;
  double getPadding(double padding) => padding * scaleFactor;
  double getMargin(double margin) => margin * scaleFactor;
  double getRadius(double radius) => radius * scaleFactor;
  double getIconSize(double size) => size * scaleFactor;
  double getSpacing(double spacing) => spacing * scaleFactor;
  double getElevation(double elevation) => elevation * scaleFactor;
  double getBorderRadius(double borderRadius) => borderRadius * scaleFactor;
  double getBorderWidth(double borderWidth) => borderWidth * scaleFactor;
}
