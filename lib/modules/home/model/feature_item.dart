import 'package:flutter/material.dart';

class FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final bool isAvailable;
  final String? route;

  const FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    this.isAvailable = false,
    this.route,
  });
}
