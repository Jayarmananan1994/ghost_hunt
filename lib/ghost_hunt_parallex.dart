import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

gameParallexBackground() async {
  final layers = [
    ParallaxLayer.load(
      ParallaxImageData('background/background_layer_1.png'),
      velocityMultiplier: Vector2(1.4, 1.0),
      fill: LayerFill.height,
    ),
    ParallaxLayer.load(
      ParallaxImageData('background/background_layer_2.png'),
      velocityMultiplier: Vector2(2.8, 2.0),
      fill: LayerFill.height,
    ),
    ParallaxLayer.load(
      ParallaxImageData('background/background_layer_3.png'),
      velocityMultiplier: Vector2(4.2, 3.0),
      fill: LayerFill.height,
    ),
    ParallaxLayer.load(
      ParallaxImageData('background/ground.png'),
      velocityMultiplier: Vector2(4.2, 3.0),
      fill: LayerFill.none,
    )
  ];
  final parallax = Parallax(
    await Future.wait(layers),
    baseVelocity: Vector2.zero(), //Vector2(50, 0),
  );

  //  loadParal
  return ParallaxComponent<GhostHuntGame>(parallax: parallax);
}
