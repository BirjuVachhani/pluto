enum BackgroundMode {
  flat,
  gradient,
  image;

  bool get isColor => this == BackgroundMode.flat;

  bool get isGradient => this == BackgroundMode.gradient;

  bool get isImage => this == BackgroundMode.image;
}
