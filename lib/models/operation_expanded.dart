import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:urology_waiting_list/models/doctor.dart';
import 'package:urology_waiting_list/models/app_user.dart';
import 'package:urology_waiting_list/models/waiting_type.dart';

class OperationExpanded extends Equatable {
  final String id;
  final String name;
  final String rank;
  final String phone;
  final String diagnosis;
  final String operation;
  final DateTime operative_date;
  final bool attended;
  final AppUser added_by;
  final Doctor consultant;
  final num postponed;
  final WaitingType type;

  const OperationExpanded({
    required this.id,
    required this.name,
    required this.rank,
    required this.phone,
    required this.diagnosis,
    required this.operation,
    required this.operative_date,
    required this.attended,
    required this.added_by,
    required this.consultant,
    required this.postponed,
    required this.type,
  });

  OperationExpanded copyWith({
    String? id,
    String? name,
    String? rank,
    String? phone,
    String? diagnosis,
    String? operation,
    DateTime? operative_date,
    bool? attended,
    AppUser? added_by,
    Doctor? consultant,
    num? postponed,
    WaitingType? type,
  }) {
    return OperationExpanded(
      id: id ?? this.id,
      name: name ?? this.name,
      rank: rank ?? this.rank,
      phone: phone ?? this.phone,
      diagnosis: diagnosis ?? this.diagnosis,
      operation: operation ?? this.operation,
      operative_date: operative_date ?? this.operative_date,
      attended: attended ?? this.attended,
      added_by: added_by ?? this.added_by,
      consultant: consultant ?? this.consultant,
      postponed: postponed ?? this.postponed,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'rank': rank,
      'phone': phone,
      'diagnosis': diagnosis,
      'operation': operation,
      'operative_date': operative_date.toIso8601String(),
      'attended': attended,
      'added_by': added_by.toJson(),
      'consultant': consultant.toJson(),
      'postponed': postponed,
      'type': type.name,
    };
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      rank,
      phone,
      diagnosis,
      operation,
      operative_date,
      attended,
      added_by,
      consultant,
      postponed,
    ];
  }

  factory OperationExpanded.fromRecordModel(RecordModel record) {
    return OperationExpanded(
      id: record.getStringValue('id'),
      name: record.getStringValue('name'),
      rank: record.getStringValue('rank'),
      phone: record.getStringValue('phone'),
      diagnosis: record.getStringValue('diagnosis'),
      operation: record.getStringValue('operation'),
      operative_date: DateTime.parse(record.getStringValue('operative_date')),
      attended: record.getBoolValue('attended'),
      added_by:
          AppUser.fromRecordModel(record.get<RecordModel>('expand.added_by')),
      consultant:
          Doctor.fromRecordModel(record.get<RecordModel>('expand.consultant')),
      postponed: record.getDoubleValue('postponed'),
      type: WaitingType.fromString(record.getStringValue('type')),
    );
  }
}
