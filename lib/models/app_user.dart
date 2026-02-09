import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:ortho_waiting_list/models/speciality.dart';

class AppUser extends Equatable {
  final String id;
  final RecordAuth? auth;
  final Speciality speciality;
  final String name;

  const AppUser({
    required this.id,
    required this.auth,
    required this.speciality,
    required this.name,
  });

  AppUser copyWith({
    String? id,
    RecordAuth? auth,
    Speciality? speciality,
    String? name,
  }) {
    return AppUser(
      id: id ?? this.id,
      auth: auth ?? this.auth,
      speciality: speciality ?? this.speciality,
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        auth,
        speciality,
        name,
      ];

  factory AppUser.fromRecordAuth(RecordAuth auth) {
    return AppUser(
      id: auth.record.id,
      auth: auth,
      speciality: Speciality.fromJson(
          auth.record.get<RecordModel>('expand.speciality_id').toJson()),
      name: auth.record.getStringValue('name'),
    );
  }

  factory AppUser.fromRecordModel(RecordModel record) {
    return AppUser(
      id: record.id,
      auth: null,
      speciality: Speciality.fromJson(
          record.get<RecordModel>('expand.speciality_id').toJson()),
      name: record.getStringValue('name'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': auth?.record.id,
      'auth': auth?.toJson(),
      'speciality': speciality.toJson(),
      'name': name,
    };
  }
}
