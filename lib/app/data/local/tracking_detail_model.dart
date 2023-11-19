import 'package:flutter/material.dart';

class TrackingDetailModel {
  TrackingDetailModel({
    required this.icon,
    required this.title,
    required this.detail,
    required this.unit,
  });
  final IconData icon;
  final String title;
  final String detail;
  final String unit;
}
