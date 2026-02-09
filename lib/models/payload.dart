// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:urology_waiting_list/models/notification_type.dart';
import 'package:urology_waiting_list/models/operation_expanded.dart';

class Payload extends Equatable {
  final NotificationType type;
  final OperationExpanded operation;
  final OperationExpanded? newOperation;

  const Payload({
    required this.type,
    required this.operation,
    this.newOperation,
  });

  @override
  List<Object?> get props => [
        type,
        operation,
        newOperation,
      ];
}
