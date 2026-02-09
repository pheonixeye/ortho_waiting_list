import 'package:ortho_waiting_list/api/constants/pocketbase_helper.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/rank.dart';
import 'package:pocketbase/pocketbase.dart';

class RankApi {
  const RankApi();

  Future<ApiResult<List<Rank>>> fetchRanks() async {
    try {
      final _result =
          await PocketbaseHelper.pb.collection('ranks').getFullList();

      final _ranks = _result.map((e) => Rank.fromJson(e.toJson())).toList();

      return ApiDataResult<List<Rank>>(data: _ranks);
    } on ClientException catch (e) {
      return ApiErrorResult<List<Rank>>(
        errorCode: 1,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
