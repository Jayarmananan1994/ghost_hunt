import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:ghost_hunt/characters/death_ghost.dart';
import 'package:ghost_hunt/characters/flying_eye.dart';
import 'package:ghost_hunt/characters/hunter.dart';
import 'package:ghost_hunt/controls/controll_button.dart';

class GhostHuntGame extends FlameGame with HasTappables {
  late final DeathBringer deathGhost;
  late final ParallaxComponent ghostHuntParallax;
  late final FlyingEye flyingEye;
  late final Hunter hunter;
  HunterState hunterLastState = HunterState.idle;

  @override
  Future<void>? onLoad() async {
    flyingEye = FlyingEye();
    ghostHuntParallax = await gameParallexBackground(); //GhostHuntParallax();
    var runningButton = runButton();
    var attackBtn = attackButton();

    hunter = Hunter();
    hunter.position = Vector2(70, size[1] - 110);
    deathGhost = DeathBringer();
    deathGhost.scale = Vector2.all(1.5);
    deathGhost.flipHorizontallyAroundCenter();
    add(ghostHuntParallax);
    // add(deathGhost);
    add(hunter);
    runningButton
      ..size = Vector2(65.0, 65.0)
      ..position = Vector2(30, size[1] - 75);

    attackBtn
      ..size = Vector2(65.0, 65.0)
      ..position = Vector2(size[0] - 125, size[1] - 75);

    add(runningButton);
    add(attackBtn);
  }

  ControllButton runButton() {
    return ControllButton(
        pressSpritePath: "button/run.png",
        unpressSpritePath: "button/run_2.png",
        pressDown: runPlayer,
        pressUp: resetPlayerToIdle);
  }

  ControllButton attackButton() {
    return ControllButton(
        pressSpritePath: "button/attack.png",
        unpressSpritePath: "button/attack_2.png",
        pressDown: attackWithArch,
        pressUp: resetPlayerToIdle);
  }

  resetPlayerToIdle() {
    ghostHuntParallax.parallax?.baseVelocity = Vector2.zero();
    hunter.idle();
  }

  runPlayer() {
    if (hunter.current == HunterState.idle) {
      ghostHuntParallax.parallax?.baseVelocity = Vector2(50, 0);
      hunter.run();
    }
  }

  attackWithArch() {
    ghostHuntParallax.parallax?.baseVelocity = Vector2.zero();
    hunter.attack();
  }

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
        velocityMultiplier: Vector2(4.3, 3.0),
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
}
