class IconConstant {
  IconConstant._init();
  static IconConstant? _instace;
  static IconConstant get instance => _instace ??= IconConstant._init();

  String getIconPath(String iconName) => 'assets/icons/$iconName.png';

  String get add => getIconPath('add');
  String get camera => getIconPath('camera');
  String get contact => getIconPath('contact');
  String get picture => getIconPath('picture');
  String get success => getIconPath('success');
}
