import 'package:equatable/equatable.dart';

class CaseImage extends Equatable {
  final String id;
  final String case_id;
  final String image_url;
  final String image_public_id;

  const CaseImage({
    required this.id,
    required this.case_id,
    required this.image_url,
    required this.image_public_id,
  });

  CaseImage copyWith({
    String? id,
    String? case_id,
    String? image_url,
    String? image_public_id,
  }) {
    return CaseImage(
      id: id ?? this.id,
      case_id: case_id ?? this.case_id,
      image_url: image_url ?? this.image_url,
      image_public_id: image_public_id ?? this.image_public_id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'case_id': case_id,
      'image_url': image_url,
      'image_public_id': image_public_id,
    };
  }

  factory CaseImage.fromJson(Map<String, dynamic> map) {
    return CaseImage(
      id: map['id'] as String,
      case_id: map['case_id'] as String,
      image_url: map['image_url'] as String,
      image_public_id: map['image_public_id'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, case_id, image_url, image_public_id];
}
