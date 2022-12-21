import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ghost_hunt/characters/damagable.dart';
import 'package:ghost_hunt/characters/fire_ball.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';
import 'package:ghost_hunt/util/sprite_util.dart';

enum HunterState {
  death,
  highattack,
  idle,
  run,
  lowattack,
  normalattack,
}

class Hunter extends SpriteAnimationGroupComponent
    with HasGameRef<GhostHuntGame>, Damagable {
  double _life = 100;
  Hunter() : super(size: Vector2.all(100.0));

  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox(
      size: Vector2(20, 70),
      anchor: Anchor.center,
      position: size / 2,
    ));
    final highAttackSprites = [for (var i = 1; i <= 19; i++) i]
        .map((i) => Sprite.load('hunter/high_attack_$i.png'));
    final highAttackAnimation =
        await createAnimationForSprites(highAttackSprites, false);

    final lowAttackSprites = [for (var i = 1; i <= 15; i++) i]
        .map((i) => Sprite.load('hunter/low_attack_$i.png'));
    final lowAttackAnimation =
        await createAnimationForSprites(lowAttackSprites, false);

    final deathSprites = [for (var i = 1; i <= 10; i++) i]
        .map((i) => Sprite.load('hunter/death_$i.png'));
    final deathAnimation = await createAnimationForSprites(deathSprites, false);
    deathAnimation.onComplete = () => gameRef.gameOver();
    var idleSprite = [for (var i = 1; i <= 2; i++) i]
        .map((i) => Sprite.load('hunter/idle_$i.png'));
    final idleAnimation = await createAnimationForSprites(idleSprite, false);

    var runSprite = [for (var i = 1; i <= 8; i++) i]
        .map((i) => Sprite.load('hunter/run_$i.png'));
    final runAnimation = await createAnimationForSprites(runSprite, true);

    var normalAttackSprites = List.generate(16, (i) => i + 1)
        .map((i) => Sprite.load('hunter/normal_attack_$i.png'));
    final normalAttack =
        await createAnimationForSprites(normalAttackSprites, true)
          ..onFrame = (index) {
            if (index == 2 || index == 8 || index == 16) {
              final fireball = FireBall();
              fireball.position = Vector2(150, gameRef.size[1] - 80);
              gameRef.add(fireball);
            }
          };

    animations = {
      HunterState.highattack: highAttackAnimation,
      HunterState.lowattack: lowAttackAnimation,
      HunterState.normalattack: normalAttack,
      HunterState.death: deathAnimation,
      HunterState.idle: idleAnimation,
      HunterState.run: runAnimation,
    };
    current = HunterState.idle;
    debugMode = true;
  }

  void run() {
    if (isAlive()) current = HunterState.run;
  }

  void idle() {
    if (isAlive()) current = HunterState.idle;
  }

  void attack() {
    if (isAlive()) current = HunterState.normalattack;
  }

  bool isRunning() {
    return current == HunterState.run;
  }

  bool isAlive() {
    return current != HunterState.death;
  }

  double life() {
    return _life;
  }

  // @override
  // void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  //   super.onCollision(intersectionPoints, other);
  //   if (other is EvilFireBall) {
  //     _life -= other.damage();
  //     if (_life <= 0) {
  //       current = HunterState.death;
  //     }
  //   }
  // }

  @override
  void damageBy(double damageValue) {
    _life -= damageValue;
    gameRef.hunterLife.text = 'LIFE - ${life()}';
    print("Life: $_life");
    if (_life <= 0) {
      current = HunterState.death;
    }
  }
}
