import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ghost_hunt/characters/damagable.dart';
import 'package:ghost_hunt/characters/evil_fire_ball.dart';
import 'package:ghost_hunt/characters/hunter.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';
import 'package:ghost_hunt/util/sprite_util.dart';
import 'dart:async' as async;

enum DeathBringerState { attack, idle, hurt, death, cast }

class DeathBringer extends SpriteAnimationGroupComponent
    with HasGameRef<GhostHuntGame>, CollisionCallbacks, Damagable {
  late final ShapeHitbox observantHitBox;
  late final ShapeHitbox vulnerableHitBox;
  late final SpriteAnimation attackAnimation;
  late Function? onDeath;
  double _life = 100;
  DeathBringer() : super(size: Vector2.all(100.0));

  @override
  Future<void>? onLoad() async {
    observantHitBox = RectangleHitbox(
      size: Vector2(300, 70),
      anchor: Anchor.centerRight,
      position: size / 1.5,
    );
    observantHitBox.onCollisionStartCallback = handleHunterEntry;
    vulnerableHitBox = CircleHitbox(
      radius: 35,
      anchor: Anchor.center,
      position: size / 1.5,
    );
    vulnerableHitBox.collisionType = CollisionType.passive;
    add(vulnerableHitBox);
    add(observantHitBox);
    position = Vector2(gameRef.size[0] - 50, gameRef.size[1] - 125);

    final attackSprites = [
      for (var i = 1; i <= 10; i++) i
    ].map((i) => Sprite.load('death_bringer/Bringer-of-Death_Attack_$i.png'));
    attackAnimation = await createAnimationForSprites(attackSprites, false);

    attackAnimation.onFrame = (index) {
      if (index == 9) {
        var fireball = EvilFireBall();
        fireball.position = position;
        fireball.position.y += 30;
        gameRef.add(fireball);
      }
    };

    final deathSprites = [for (var i = 1; i <= 10; i++) i]
        .map((i) => Sprite.load('death_bringer/Bringer-of-Death_Death_$i.png'));
    final deathAnimation = await createAnimationForSprites(deathSprites, false);
    deathAnimation.onComplete = () => removeFromParent();
    final idleSprites = [for (var i = 1; i <= 8; i++) i]
        .map((i) => Sprite.load('death_bringer/Bringer-of-Death_Idle_$i.png'));
    final idleAnimation = await createAnimationForSprites(idleSprites, true);

    final hurtSprites = [for (var i = 1; i <= 3; i++) i]
        .map((i) => Sprite.load('death_bringer/Bringer-of-Death_Hurt_$i.png'));
    final hurtAnimation = await createAnimationForSprites(hurtSprites, false);

    animations = {
      DeathBringerState.attack: attackAnimation,
      DeathBringerState.death: deathAnimation,
      DeathBringerState.hurt: hurtAnimation,
      DeathBringerState.idle: idleAnimation,
    };
    current = DeathBringerState.idle;
    debugMode = true;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.hunter.isRunning()) {
      position.x -= 4.2;
    } else if (position.x < -200) {
      gameRef.remove(this);
    }
  }

  void handleHunterEntry(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ShapeHitbox && other.hitboxParent is Hunter) {
      async.Timer.periodic(const Duration(seconds: 5), (timer) {
        var hunter = other.hitboxParent as Hunter;
        if (hunter.isAlive() && isAlive()) attack();
      });
    }
  }

  void attack() {
    attackAnimation.reset();
    current = DeathBringerState.attack;
  }

  bool isAlive() {
    return current != DeathBringerState.death;
  }

  @override
  void damageBy(double damageValue) {
    _life -= damageValue;
    if (_life <= 0) {
      current = DeathBringerState.death;
      onDeath!();
    }
  }
}
