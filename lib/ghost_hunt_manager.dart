import 'package:flame/components.dart';
import 'package:ghost_hunt/characters/death_ghost.dart';
import 'package:ghost_hunt/characters/flying_eye.dart';
import 'package:ghost_hunt/characters/goblin.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

class GhostHuntManager extends Component with HasGameRef<GhostHuntGame> {
  int gameLevel = 1;
  int noOfEnemyInScreen = 0;

  @override
  Future<void>? onLoad() {
    initiateAttack();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // print("On mount of manager");
    // super.onMount()X;
    // initiateAttack();

    // if (gameRef.hunter.isHunterRunning()) {
    //   position.x -= 4.2;
    // } else if (position.x < (-gameRef.size.x)) {
    //   print("enemy Removing itself from game");
    //   gameRef.remove(this);
    // }
  }

  Component _getMeNewEnemy() {
    //return DeathBringer();
    return Goblin();
  }

  initiateAttack() {
    final enemy = _getMeNewEnemy();
    print("enemy: ${enemy.runtimeType}");
    if (noOfEnemyInScreen < gameLevel) {
      gameRef.add(enemy);
      noOfEnemyInScreen += 1;
    }
  }

  spawnEnemy() {}
}
