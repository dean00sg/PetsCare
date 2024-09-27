import 'package:equatable/equatable.dart';
import 'package:frontend/admin/models/historyrec.dart';

abstract class AddHistoryRecEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitHistoryRecForm extends AddHistoryRecEvent {
  final AddHistoryRec record;

  SubmitHistoryRecForm(this.record);

  @override
  List<Object?> get props => [record];
}
