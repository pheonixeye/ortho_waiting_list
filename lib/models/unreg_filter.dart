enum UnregFilter {
  all(
    en: 'All',
    ar: 'بدون',
  ),
  rank(
    en: 'Rank',
    ar: 'الرتبة',
  ),
  spec(
    en: 'Operative',
    ar: 'العملية',
  ),
  doctor(
    en: 'Consultant',
    ar: 'الاستشاري',
  );

  final String en;
  final String ar;

  const UnregFilter({
    required this.en,
    required this.ar,
  });
}
