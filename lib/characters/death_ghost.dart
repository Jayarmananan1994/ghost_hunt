import 'package:flame/components.dart';

class DeathBringer extends SpriteAnimationComponent {
  DeathBringer() : super(size: Vector2.all(150.0));

  @override
  Future<void>? onLoad() async {
    final sprites = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
    ].map((i) => Sprite.load('death_bringer/Bringer-of-Death_Attack_$i.png'));
    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.05,
    );
  }
}
