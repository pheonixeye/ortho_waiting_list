import 'package:flutter/material.dart';
import 'package:ortho_waiting_list/api/waiting_list/waiting_list_api.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/case_image.dart';
import 'package:ortho_waiting_list/models/doctor.dart';
import 'package:ortho_waiting_list/models/operation_dto.dart';
import 'package:ortho_waiting_list/models/operation_expanded.dart';
import 'package:ortho_waiting_list/models/rank.dart';
import 'package:ortho_waiting_list/models/speciality.dart';
import 'package:ortho_waiting_list/models/unreg_filter.dart';

class PxOperations extends ChangeNotifier {
  final WaitingListApi api;

  PxOperations({required this.api}) {
    init();
  }

  ApiResult<List<OperationExpanded>>? _operations;
  ApiResult<List<OperationExpanded>>? get operations => _operations;

  ApiResult<List<OperationExpanded>>? _unregisteredOperations;
  ApiResult<List<OperationExpanded>>? get unregistered =>
      _unregisteredOperations;

  DateTime _date = DateTime.now().copyWith(day: 1);
  DateTime get date => _date;

  Future<void> init() async {
    _operations = await api.fetchOperationsOfDateRange(
      from: _date,
      to: _date.copyWith(month: _date.month + 1),
    );
    notifyListeners();
    _unregisteredOperations = await api.fetchUnregisteredOperations(
      page: _page,
    );

    notifyListeners();
    filterUnregBy('');
  }

  int _page = 1;
  int get page => _page;

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

  Future<void> deletescheduleForOperation(
    OperationExpanded operation,
  ) async {
    await api.deleteScheduleForOperation(
      operation: operation,
    );
    await init();
  }

  Future<void> scheduleOperation(
    String operation_id,
    DateTime operativeDate,
  ) async {
    await api.scheduleOperation(
      operation_id: operation_id,
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

  UnregFilter _filterType = UnregFilter.all;
  UnregFilter get filterType => _filterType;

  void selectFilter(UnregFilter value) {
    _filterType = value;
    notifyListeners();
    filterUnregBy('');
  }

  Doctor? _docFilter;
  Doctor? get docFilter => _docFilter;
  Rank? _rankFilter;
  Rank? get rankFilter => _rankFilter;
  Speciality? _specFilter;
  Speciality? get specFilter => _specFilter;

  List<OperationExpanded> _filteredUnreg = [];
  List<OperationExpanded> get filteredUnreg => _filteredUnreg;

  void filterUnregBy(String id) {
    // _filteredUnreg.clear();
    // notifyListeners();
    final _temp =
        (_unregisteredOperations as ApiDataResult<List<OperationExpanded>>)
            .data;
    _filteredUnreg = switch (_filterType) {
      UnregFilter.rank => _temp.where((e) => e.rank.id == id).toList(),
      UnregFilter.spec => _temp.where((e) => e.subspeciality.id == id).toList(),
      UnregFilter.doctor => _temp.where((e) => e.consultant.id == id).toList(),
      _ => _temp,
    };
    // print(_filteredUnreg);
    // print(id);
    notifyListeners();
  }

  Future<void> addImageToOperation({
    required OperationExpanded operationExpanded,
    required CaseImage caseImage,
  }) async {
    await api.addImageToOperation(
      operationExpanded: operationExpanded,
      caseImage: caseImage,
    );

    await init();
  }

  Future<void> removeImageFromOperation({
    required OperationExpanded operationExpanded,
    required CaseImage caseImage,
  }) async {
    await api.removeImageFromOperation(
      operationExpanded: operationExpanded,
      caseImage: caseImage,
    );

    await init();
  }
}
