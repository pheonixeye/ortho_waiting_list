import 'package:equatable/equatable.dart';

class OperationDTO extends Equatable {
  final String id;
  final String name;
  final String rank;
  final String phone;
  final String diagnosis;
  final String operation;
  final String operative_date;
  final bool attended;
  final String added_by;
  final String type;
  final String consultant;
  final num postponed;

  const OperationDTO({
    required this.id,
    required this.name,
    required this.rank,
    required this.phone,
    required this.diagnosis,
    required this.operation,
    required this.operative_date,
    required this.attended,
    required this.added_by,
    required this.type,
    required this.consultant,
    required this.postponed,
  });

  OperationDTO copyWith({
    String? id,
    String? name,
    String? rank,
    String? phone,
    String? diagnosis,
    String? operation,
    String? operative_date,
    bool? attended,
    String? added_by,
    String? type,
    String? consultant,
    num? postponed,
  }) {
    return OperationDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      rank: rank ?? this.rank,
      phone: phone ?? this.phone,
      diagnosis: diagnosis ?? this.diagnosis,
      operation: operation ?? this.operation,
      operative_date: operative_date ?? this.operative_date,
      attended: attended ?? this.attended,
      added_by: added_by ?? this.added_by,
      type: type ?? this.type,
      consultant: consultant ?? this.consultant,
      postponed: postponed ?? this.postponed,
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
      'operative_date': operative_date,
      'attended': attended,
      'added_by': added_by,
      'type': type,
      'consultant': consultant,
      'postponed': postponed,
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
      type,
      consultant,
      postponed,
    ];
  }
}
