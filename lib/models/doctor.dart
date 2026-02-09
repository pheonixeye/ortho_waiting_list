import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:urology_waiting_list/models/speciality.dart';

class Doctor extends Equatable {
  final String id;
  final String name;
  final Speciality speciality;

  const Doctor({
    required this.id,
    required this.name,
    required this.speciality,
  });

  Doctor copyWith({
    String? id,
    String? name,
    Speciality? speciality,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      speciality: speciality ?? this.speciality,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'speciality': speciality.toJson(),
    };
  }

  factory Doctor.fromJson(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String,
      name: map['name'] as String,
      speciality:
          Speciality.fromJson(map['speciality'] as Map<String, dynamic>),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, speciality];

  factory Doctor.fromRecordModel(RecordModel record) {
    return Doctor(
      id: record.id,
      name: record.getStringValue('name'),
      speciality: Speciality.fromJson(
          record.get<RecordModel>('expand.speciality_id').toJson()),
    );
  }
}
