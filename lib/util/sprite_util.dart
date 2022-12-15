import 'package:flame/widgets.dart';

Future<SpriteAnimation> createAnimationForSprites(
    Iterable<Future<Sprite>> sprites, bool loop) async {
  return SpriteAnimation.spriteList(
    await Future.wait(sprites),
    stepTime: 0.1,
    loop: loop,
  );
}

Future<SpriteAnimation> createAnimationForVariableSprites(
    Iterable<Future<Sprite>> sprites, List<double> stepTimes, bool loop) async {
  return SpriteAnimation.variableSpriteList(
    await Future.wait(sprites),
    stepTimes: stepTimes,
    loop: loop,
  );
}
