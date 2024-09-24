// states/notification_state.dart
import 'package:equatable/equatable.dart';

abstract class HealthrecordMainState extends Equatable {
  @override
  List<Object> get props => [];
}

class HealthrecordMainInitial extends HealthrecordMainState {}

class HealthrecordMainAddedState extends HealthrecordMainState {}

class NewsFeedAdviceAddedState extends HealthrecordMainState {}
