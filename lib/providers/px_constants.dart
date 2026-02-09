import 'package:flutter/material.dart';
import 'package:ortho_waiting_list/api/doctors/doctors_api.dart';
import 'package:ortho_waiting_list/api/rank_api/rank_api.dart';
import 'package:ortho_waiting_list/api/specialities_api/spec_api.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/doctor.dart';
import 'package:ortho_waiting_list/models/rank.dart';
import 'package:ortho_waiting_list/models/speciality.dart';

class PxConstants extends ChangeNotifier {
  final DoctorsApi doctors_api;
  final RankApi ranks_api;
  final SpecApi spec_api;

  PxConstants({
    required this.doctors_api,
    required this.ranks_api,
    required this.spec_api,
  }) {
    init();
  }

  ApiResult<List<Doctor>>? _doctors;
  ApiResult<List<Doctor>>? get doctors => _doctors;

  ApiResult<List<Rank>>? _ranks;
  ApiResult<List<Rank>>? get ranks => _ranks;

  ApiResult<List<Speciality>>? _specs;
  ApiResult<List<Speciality>>? get specs => _specs;

  Future<void> init() async {
    _doctors = await doctors_api.fetchDoctors();
    _ranks = await ranks_api.fetchRanks();
    _specs = await spec_api.fetchSpecialities();
    notifyListeners();
  }
}
