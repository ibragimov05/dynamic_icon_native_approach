enum AppIconType {
  main(name: 'main'),
  alternative(name: 'alternative');

  const AppIconType({required this.name});

  final String name;

  bool get isMain => this == main;
  bool get isAlternative => this == alternative;
}
