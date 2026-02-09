import 'package:flutter/material.dart';
import 'package:urology_waiting_list/api/waiting_list/waiting_list_api.dart';
import 'package:urology_waiting_list/models/_api_result.dart';
import 'package:urology_waiting_list/models/operation_dto.dart';
import 'package:urology_waiting_list/models/operation_expanded.dart';

class PxOperations extends ChangeNotifier {
  final WaitingListApi api;

  PxOperations({required this.api}) {
    init();
  }

  ApiResult<List<OperationExpanded>>? _operations;
  ApiResult<List<OperationExpanded>>? get operations => _operations;

  DateTime _date = DateTime.now().copyWith(day: 1);
  DateTime get date => _date;

  Future<void> init() async {
    _operations = await api.fetchOperationsOfDateRange(
      from: _date,
      to: _date.copyWith(month: _date.month + 1),
    );
    notifyListeners();
  }

  Future<void> setDate(DateTime value) async {
    _date = DateTime(value.year, value.month, 1);
    notifyListeners();
    await init();
  }

  Future<void> createOperation(OperationDTO dto) async {
    await api.createOperation(dto);
    await init();
  }

  Future<void> updateAttendance(OperationExpanded operation) async {
    await api.updateAttendance(operation: operation);
    await init();
  }

  Future<void> rescheduleOperation(
    OperationExpanded operation,
    DateTime operativeDate,
  ) async {
    await api.postponeOperation(
      operation: operation,
      operative_date: operativeDate,
    );
    await init();
  }

  Future<void> changeConsultant(
    String operation_id,
    String consultant_id,
  ) async {
    await api.changeConsultant(
      operation_id: operation_id,
      consultant_id: consultant_id,
    );
    await init();
  }
}
