import 'package:urology_waiting_list/api/constants/pocketbase_helper.dart';
import 'package:urology_waiting_list/models/_api_result.dart';
import 'package:urology_waiting_list/models/doctor.dart';

class DoctorsApi {
  const DoctorsApi();

  static const String _collection = 'doctors';
  static const String _expand = 'speciality_id';

  Future<ApiResult<List<Doctor>>> fetchDoctors() async {
    late final List<Doctor> _doctors;
    try {
      final _response =
          await PocketbaseHelper.pb.collection(_collection).getFullList(
                expand: _expand,
              );
      try {
        _doctors = _response.map((e) => Doctor.fromRecordModel(e)).toList();
      } catch (e) {
        print('parsing Error => ${e.toString()}');
        return ApiErrorResult<List<Doctor>>(
          errorCode: 2,
          originalErrorMessage: 'Data Parsing Error => ${e.toString()}',
        );
      }

      return ApiDataResult<List<Doctor>>(data: _doctors);
    } catch (e) {
      return ApiErrorResult<List<Doctor>>(
        errorCode: 1,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
