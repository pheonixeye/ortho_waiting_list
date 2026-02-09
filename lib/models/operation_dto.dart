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
  final String subspeciality;
  final String consultant;
  final num postponed;
  final List<String> case_images_urls;

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
    required this.subspeciality,
    required this.consultant,
    required this.postponed,
    required this.case_images_urls,
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
    String? subspeciality,
    String? consultant,
    num? postponed,
    List<String>? case_images_urls,
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
      subspeciality: subspeciality ?? this.subspeciality,
      consultant: consultant ?? this.consultant,
      postponed: postponed ?? this.postponed,
      case_images_urls: case_images_urls ?? this.case_images_urls,
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
      'subspeciality': subspeciality,
      'consultant': consultant,
      'postponed': postponed,
      'case_images_urls': case_images_urls,
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
      subspeciality,
      consultant,
      postponed,
      case_images_urls,
    ];
  }
}
