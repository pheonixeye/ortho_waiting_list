import 'package:equatable/equatable.dart';

class Rank extends Equatable {
  final String id;
  final String rank;

  const Rank({
    required this.id,
    required this.rank,
  });

  Rank copyWith({
    String? id,
    String? rank,
  }) {
    return Rank(
      id: id ?? this.id,
      rank: rank ?? this.rank,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'rank': rank,
    };
  }

  factory Rank.fromJson(Map<String, dynamic> map) {
    return Rank(
      id: map['id'] as String,
      rank: map['rank'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, rank];
}
