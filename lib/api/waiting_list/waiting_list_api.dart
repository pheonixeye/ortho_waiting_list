import 'package:intl/intl.dart';
import 'package:ortho_waiting_list/api/constants/pocketbase_helper.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/operation_dto.dart';
import 'package:ortho_waiting_list/models/operation_expanded.dart';

class WaitingListApi {
  const WaitingListApi();

  static const List<String> _expList = [
    'added_by',
    'added_by.speciality_id',
    'consultant',
    'consultant.speciality_id',
    'subspeciality',
    'rank',
  ];
  static final String _expand = _expList.join(',');

  static const String _collection = 'waiting_list';

  Future<void> createOperation(
    OperationDTO dto,
  ) async {
    await PocketbaseHelper.pb.collection(_collection).create(
          body: dto.toJson(),
          expand: _expand,
        );
  }

  Future<ApiResult<List<OperationExpanded>>> fetchOperationsOfDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    final _dateOfOperation = DateFormat('yyyy-MM-dd', 'en').format(from);
    final _dateAfterOperation = DateFormat('yyyy-MM-dd', 'en').format(to);

    late final List<OperationExpanded> _operations;
    try {
      final _response =
          await PocketbaseHelper.pb.collection(_collection).getFullList(
                expand: _expand,
                filter:
                    "operative_date >= '$_dateOfOperation' && operative_date <= '$_dateAfterOperation' && operative_date != ''",
              );
      try {
        _operations =
            _response.map((e) => OperationExpanded.fromRecordModel(e)).toList();
      } catch (e) {
        print('parsing Error => ${e.toString()}');
      }

      return ApiDataResult<List<OperationExpanded>>(data: _operations);
    } catch (e) {
      return ApiErrorResult<List<OperationExpanded>>(
        errorCode: 1,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<OperationExpanded>>> fetchUnregisteredOperations({
    required int page,
  }) async {
    late final List<OperationExpanded> _operations;
    try {
      final _response =
          await PocketbaseHelper.pb.collection(_collection).getList(
                expand: _expand,
                filter: "operative_date = ''",
                sort: '-created',
                page: page,
              );
      try {
        _operations = _response.items
            .map((e) => OperationExpanded.fromRecordModel(e))
            .toList();
      } catch (e) {
        print('parsing Error => ${e.toString()}');
      }

      return ApiDataResult<List<OperationExpanded>>(data: _operations);
    } catch (e) {
      return ApiErrorResult<List<OperationExpanded>>(
        errorCode: 1,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> postponeOperation({
    required OperationExpanded operation,
    required DateTime operative_date,
  }) async {
    await PocketbaseHelper.pb.collection(_collection).update(
          operation.id,
          body: {
            'operative_date': operative_date.toIso8601String(),
            'postponed': operation.postponed + 1,
          },
          expand: _expand,
        );
  }

  Future<void> scheduleOperation({
    required String operation_id,
    required DateTime operative_date,
  }) async {
    await PocketbaseHelper.pb.collection(_collection).update(
          operation_id,
          body: {
            'operative_date': operative_date.toIso8601String(),
          },
          expand: _expand,
        );
  }

  Future<void> changeConsultant({
    required String operation_id,
    required String consultant_id,
  }) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      operation_id,
      body: {
        'consultant': consultant_id,
      },
    );
  }

  Future<void> updateAttendance({
    required OperationExpanded operation,
  }) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      operation.id,
      body: {
        'attended': !operation.attended,
      },
    );
  }

  Future<void> addImageToOperation({
    required String operationId,
    required String imagePublicId,
  }) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      operationId,
      body: {
        'case_images_urls+': imagePublicId,
      },
    );
  }
}
