import 'package:ortho_waiting_list/api/constants/pocketbase_helper.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/speciality.dart';
import 'package:pocketbase/pocketbase.dart';

class SpecApi {
  const SpecApi();

  Future<ApiResult<List<Speciality>>> fetchSpecialities() async {
    try {
      final _result =
          await PocketbaseHelper.pb.collection('specialities').getFullList();

      final _specs =
          _result.map((e) => Speciality.fromJson(e.toJson())).toList();

      return ApiDataResult<List<Speciality>>(data: _specs);
    } on ClientException catch (e) {
      return ApiErrorResult<List<Speciality>>(
        errorCode: 1,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
