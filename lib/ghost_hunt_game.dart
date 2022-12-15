import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:ghost_hunt/characters/hunter.dart';
import 'package:ghost_hunt/controls/controll_button.dart';
import 'package:ghost_hunt/ghost_hunt_manager.dart';
import 'package:ghost_hunt/ghost_hunt_parallex.dart';

class GhostHuntGame extends FlameGame with HasTappables, HasCollisionDetection {
  late final ParallaxComponent ghostHuntParallax;
  late final Hunter hunter;
  late final GhostHuntManager ghostHuntManager;

  @override
  Future<void>? onLoad() async {
    ghostHuntParallax = await gameParallexBackground();
    var runningButton = runButton();
    var attackBtn = attackButton();
    ghostHuntManager = GhostHuntManager();

    hunter = Hunter();
    hunter.position = Vector2(70, size[1] - 110);

    add(ghostHuntParallax);
    add(hunter);
    add(ghostHuntManager);

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
      //ghostHuntManager.
    }
  }

  attackWithArch() {
    ghostHuntParallax.parallax?.baseVelocity = Vector2.zero();
    hunter.attack();
  }
}
