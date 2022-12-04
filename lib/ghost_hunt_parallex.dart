import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

class GhostHuntParallax extends ParallaxComponent<GhostHuntGame> {
  final layers = [
    ParallaxLayer.load(
      ParallaxImageData('background/background_layer_1.png'),
      velocityMultiplier: Vector2(1.8, 1.0),
      fill: LayerFill.height,
    ),
    ParallaxLayer.load(
      ParallaxImageData('background/background_layer_2.png'),
      velocityMultiplier: Vector2(1.8, 1.0),
      fill: LayerFill.height,
    ),
    ParallaxLayer.load(
      ParallaxImageData('background/background_layer_3.png'),
      velocityMultiplier: Vector2(1.8, 1.0),
      fill: LayerFill.height,
    ),
    ParallaxLayer.load(
      ParallaxImageData('background/ground.png'),
      velocityMultiplier: Vector2(1.8, 1.0),
      fill: LayerFill.none,
    )
  ];

  @override
  Future<void>? onLoad() async {
    parallax = Parallax(
      await Future.wait(layers),
      baseVelocity: Vector2.zero(), //Vector2(50, 0),
    );
  }

  move() async {
    print("move");
    parallax?.baseVelocity = Vector2(0, 0);
  }
}
