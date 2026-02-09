import 'package:flutter/material.dart';
import 'package:urology_waiting_list/api/doctors/doctors_api.dart';
import 'package:urology_waiting_list/models/_api_result.dart';
import 'package:urology_waiting_list/models/doctor.dart';

class PxDoctors extends ChangeNotifier {
  final DoctorsApi api;

  PxDoctors({required this.api}) {
    init();
  }

  ApiResult<List<Doctor>>? _doctors;
  ApiResult<List<Doctor>>? get doctors => _doctors;

  Future<void> init() async {
    _doctors = await api.fetchDoctors();
    notifyListeners();
  }
}
