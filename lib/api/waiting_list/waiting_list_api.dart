import 'package:intl/intl.dart';
import 'package:urology_waiting_list/api/constants/pocketbase_helper.dart';
import 'package:urology_waiting_list/api/notify/sms_sender.dart';
import 'package:urology_waiting_list/logic/sms_generator.dart';
import 'package:urology_waiting_list/models/_api_result.dart';
import 'package:urology_waiting_list/models/notification_type.dart';
import 'package:urology_waiting_list/models/operation_dto.dart';
import 'package:urology_waiting_list/models/operation_expanded.dart';
import 'package:urology_waiting_list/models/payload.dart';
import 'package:urology_waiting_list/models/waiting_type.dart';

class WaitingListApi {
  const WaitingListApi();

  static const List<String> _expList = [
    'added_by',
    'added_by.speciality_id',
    'consultant',
    'consultant.speciality_id',
  ];
  static final String _expand = _expList.join(',');

  static const String _collection = 'urology_waiting_list';

  Future<void> createOperation(
    OperationDTO dto,
  ) async {
    final _result = await PocketbaseHelper.pb.collection(_collection).create(
          body: dto.toJson(),
          expand: _expand,
        );

    final _operation = OperationExpanded.fromRecordModel(_result);

    final payload = Payload(
      type: NotificationType.create,
      operation: _operation,
    );

    final sms = switch (_operation.type) {
      WaitingType.eswl => SmsGenerator(payload: payload).generateESWLSms(),
      WaitingType.operative =>
        SmsGenerator(payload: payload).generateOperativeSms(),
    };

    await SmsSender(
      phone: _operation.phone,
      sms: sms,
    ).sendSms();
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
                    "operative_date >= '$_dateOfOperation' && operative_date <= '$_dateAfterOperation'",
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

  Future<void> postponeOperation({
    required OperationExpanded operation,
    required DateTime operative_date,
  }) async {
    final _result = await PocketbaseHelper.pb.collection(_collection).update(
          operation.id,
          body: {
            'operative_date': operative_date.toIso8601String(),
            'postponed': operation.postponed + 1,
          },
          expand: _expand,
        );

    final newOperation = OperationExpanded.fromRecordModel(_result);

    final payload = Payload(
      type: NotificationType.update,
      operation: operation,
      newOperation: newOperation,
    );

    final sms = switch (newOperation.type) {
      WaitingType.eswl => SmsGenerator(payload: payload).generateESWLSms(),
      WaitingType.operative =>
        SmsGenerator(payload: payload).generateOperativeSms(),
    };

    await SmsSender(
      phone: operation.phone,
      sms: sms,
    ).sendSms();
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
}
