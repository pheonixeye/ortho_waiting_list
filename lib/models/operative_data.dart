// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

import 'package:equatable/equatable.dart';

class OperativeData extends Equatable {
  final String id;
  final String patient_name;
  final String patient_rank;
  final String patient_phone;
  final String diagnosis;
  final String operation;
  final String consultant_name;
  final String added_by;
  final int day;
  final int month;
  final int year;
  final bool attended;
  final int postponed_times;

  const OperativeData({
    required this.id,
    required this.patient_name,
    required this.patient_rank,
    required this.patient_phone,
    required this.diagnosis,
    required this.operation,
    required this.consultant_name,
    required this.added_by,
    required this.day,
    required this.month,
    required this.year,
    required this.attended,
    required this.postponed_times,
  });

  OperativeData copyWith({
    String? id,
    String? patient_name,
    String? patient_rank,
    String? patient_phone,
    String? diagnosis,
    String? operation,
    String? consultant_name,
    String? added_by,
    int? day,
    int? month,
    int? year,
    bool? attended,
    int? postponed_times,
  }) {
    return OperativeData(
      id: id ?? this.id,
      patient_name: patient_name ?? this.patient_name,
      patient_rank: patient_rank ?? this.patient_rank,
      patient_phone: patient_phone ?? this.patient_phone,
      diagnosis: diagnosis ?? this.diagnosis,
      operation: operation ?? this.operation,
      consultant_name: consultant_name ?? this.consultant_name,
      added_by: added_by ?? this.added_by,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      attended: attended ?? this.attended,
      postponed_times: postponed_times ?? this.postponed_times,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'patient_name': patient_name,
      'patient_rank': patient_rank,
      'patient_phone': patient_phone,
      'diagnosis': diagnosis,
      'operation': operation,
      'consultant_name': consultant_name,
      'added_by': added_by,
      'day': day,
      'month': month,
      'year': year,
      'attended': attended,
      'postponed_times': postponed_times,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return <String, dynamic>{
      'patient_name': patient_name,
      'patient_rank': patient_rank,
      'patient_phone': patient_phone,
      'diagnosis': diagnosis,
      'operation': operation,
      'consultant_name': consultant_name,
      'added_by': added_by,
      'day': day,
      'month': month,
      'year': year,
      'attended': attended,
      'postponed_times': postponed_times,
    };
  }

  factory OperativeData.fromJson(Map<String, dynamic> map) {
    return OperativeData(
      id: map['id'] as String,
      patient_name: map['patient_name'] as String,
      patient_rank: map['patient_rank'] as String,
      patient_phone: map['patient_phone'] as String,
      diagnosis: map['diagnosis'] as String,
      operation: map['operation'] as String,
      consultant_name: map['consultant_name'] as String,
      added_by: map['added_by'] as String,
      day: map['day'] as int,
      month: map['month'] as int,
      year: map['year'] as int,
      attended: map['attended'] as bool,
      postponed_times: map['postponed_times'] as int,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      patient_name,
      patient_rank,
      patient_phone,
      diagnosis,
      operation,
      consultant_name,
      added_by,
      day,
      month,
      year,
      attended,
      postponed_times,
    ];
  }
}
