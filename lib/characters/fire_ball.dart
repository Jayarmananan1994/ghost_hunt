import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ghost_hunt/characters/damagable.dart';
import 'package:ghost_hunt/characters/death_ghost.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

enum FireBallState { fly, hit }

class FireBall extends SpriteAnimationGroupComponent
    with HasGameRef<GhostHuntGame>, CollisionCallbacks {
  final fireballSpeed = 1.75;
  static const double damageValue = 10;
  FireBall() : super(size: Vector2.all(30.0));

  @override
  Future<void>? onLoad() async {
    add(CircleHitbox(radius: 1));
    final flySprites = [for (var i = 1; i <= 5; i++) i]
        .map((i) => Sprite.load('fireball/fireball_$i.png'));
    final flyAnimation = await createAnimationForSprites(flySprites, true);

    final hitSprites = [for (var i = 2; i <= 4; i++) i]
        .map((i) => Sprite.load('fireball/fireball_hit_$i.png'));
    final hitAnimation = await createAnimationForSprites(hitSprites, false);
    hitAnimation.onComplete = () => removeFromParent();

    animations = {
      FireBallState.fly: flyAnimation,
      FireBallState.hit: hitAnimation
    };

    current = FireBallState.fly;
  }

  @override
  void update(double dt) async {
    if (current == FireBallState.fly) {
      _moveFireball();
    }
    super.update(dt);
  }

  hit() {
    current = FireBallState.hit;
  }

  createAnimationForSprites(Iterable<Future<Sprite>> sprites, bool loop) async {
    return SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.1,
      loop: loop,
    );
  }

  _moveFireball() {
    if (position.x < gameRef.size.x) {
      position.x += fireballSpeed;
    } else {
      gameRef.remove(this);
    }
  }

  @override
  void onCollisionStart(intersectionPoints, other) {
    if (other is Damagable) {
      hit();
      Damagable damagable = other as Damagable;
      damagable.damageBy(damageValue);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
