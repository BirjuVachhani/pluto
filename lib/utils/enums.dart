enum BackgroundMode {
  flat('Flat'),
  gradient('Gradient'),
  image('Image');

  const BackgroundMode(this.label);

  final String label;

  bool get isColor => this == BackgroundMode.flat;

  bool get isGradient => this == BackgroundMode.gradient;

  bool get isImage => this == BackgroundMode.image;
}
