import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftPeriod {
  final String id;
  final String name;
  final int startHour;
  final int startMinute;
  final int durationMinutes;
  final Color color;

  ShiftPeriod({
    required this.id,
    required this.name,
    required this.startHour,
    required this.startMinute,
    required this.durationMinutes,
    required this.color,
  });

  factory ShiftPeriod.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShiftPeriod(
      id: doc.id,
      name: data['name'] as String? ?? '',
      startHour: (data['startHour'] as num?)?.toInt() ?? 0,
      startMinute: (data['startMinute'] as num?)?.toInt() ?? 0,
      durationMinutes: (data['durationMinutes'] as num?)?.toInt() ?? 0,
      color: Color(data['color'] as int? ?? 0xFF000000),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startHour': startHour,
      'startMinute': startMinute,
      'durationMinutes': durationMinutes,
      'color': color.value,
    };
  }
}
