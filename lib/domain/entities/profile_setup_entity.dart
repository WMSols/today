import 'package:flutter/material.dart';

enum WorkoutWindow { morning, afternoon, evening }

enum DeepWorkPreference { earlyBird, midDay, nightOwl }

class ProfileSetupEntity {
  const ProfileSetupEntity({
    required this.wakeTime,
    required this.bedTime,
    required this.officeStart,
    required this.officeEnd,
    required this.workoutWindow,
    required this.deepWorkPreference,
  });

  final TimeOfDay wakeTime;
  final TimeOfDay bedTime;
  final TimeOfDay officeStart;
  final TimeOfDay officeEnd;
  final WorkoutWindow workoutWindow;
  final DeepWorkPreference deepWorkPreference;

  static const defaults = ProfileSetupEntity(
    wakeTime: TimeOfDay(hour: 6, minute: 30),
    bedTime: TimeOfDay(hour: 22, minute: 30),
    officeStart: TimeOfDay(hour: 9, minute: 0),
    officeEnd: TimeOfDay(hour: 17, minute: 0),
    workoutWindow: WorkoutWindow.afternoon,
    deepWorkPreference: DeepWorkPreference.earlyBird,
  );

  ProfileSetupEntity copyWith({
    TimeOfDay? wakeTime,
    TimeOfDay? bedTime,
    TimeOfDay? officeStart,
    TimeOfDay? officeEnd,
    WorkoutWindow? workoutWindow,
    DeepWorkPreference? deepWorkPreference,
  }) {
    return ProfileSetupEntity(
      wakeTime: wakeTime ?? this.wakeTime,
      bedTime: bedTime ?? this.bedTime,
      officeStart: officeStart ?? this.officeStart,
      officeEnd: officeEnd ?? this.officeEnd,
      workoutWindow: workoutWindow ?? this.workoutWindow,
      deepWorkPreference: deepWorkPreference ?? this.deepWorkPreference,
    );
  }
}
