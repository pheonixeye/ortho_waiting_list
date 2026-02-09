enum WaitingType {
  eswl(ar: 'تفتيت'),
  operative(ar: "عملية");

  final String ar;

  const WaitingType({required this.ar});

  factory WaitingType.fromString(String value) {
    return switch (value) {
      'eswl' => eswl,
      'operative' => operative,
      _ => throw UnimplementedError(),
    };
  }
}
