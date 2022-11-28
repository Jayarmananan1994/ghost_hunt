import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

class GhostHuntGame extends FlameGame {
  late final SpriteAnimationComponent flyingBeast;

  GhostHuntGame() {
    //   final size = Vector2.all(150.0);
    //   final data = SpriteAnimationData.sequenced(
    //       amount: 2, stepTime: 0.1, textureSize: size);
    //   flyingBeast = SpriteAnimationComponent.fromFrameData(await images.load('player.png'),
    // data,);
  }

  @override
  Future<void>? onLoad() async {
    final sprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        .map((i) => Sprite.load('demon_attack/Bringer-of-Death_Attack_$i.png'));
    final animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.05,
    );
    final player = SpriteAnimationComponent(
      animation: animation,
      size: Vector2.all(64.0),
    );

    player.scale = Vector2.all(1.5);
    player.flipHorizontallyAroundCenter();
    final parallaxComponent = await loadParallaxComponent(
      [
        ParallaxImageData('background_layer_1.png'),
        ParallaxImageData('background_layer_2.png'),
        ParallaxImageData('background_layer_3.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );
    add(parallaxComponent);
    add(player);
  }
}
