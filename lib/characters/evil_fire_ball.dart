import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ghost_hunt/characters/hunter.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';
import 'package:ghost_hunt/util/sprite_util.dart';

enum EvilFireBallState { fly, hit }

class EvilFireBall extends SpriteAnimationGroupComponent
    with HasGameRef<GhostHuntGame>, CollisionCallbacks {
  static const double damageValue = 15;
  final double fireballSpeed = 1.75;
  final ShapeHitbox hitbox = CircleHitbox(radius: 1);

  EvilFireBall() : super(size: Vector2.all(30.0));

  @override
  Future<void>? onLoad() async {
    add(hitbox);
    final flySprites = [for (var i = 1; i <= 5; i++) i]
        .map((i) => Sprite.load('fireball/fireball_$i.png'));
    final flyAnimation = await createAnimationForSprites(flySprites, true);

    final hitSprites = [for (var i = 2; i <= 4; i++) i]
        .map((i) => Sprite.load('fireball/fireball_hit_$i.png'));
    final hitAnimation = await createAnimationForSprites(hitSprites, false);
    hitAnimation.onComplete = () => removeFromParent();

    animations = {
      EvilFireBallState.fly: flyAnimation,
      EvilFireBallState.hit: hitAnimation
    };

    current = EvilFireBallState.fly;
    flipHorizontallyAroundCenter();
  }

  @override
  void update(double dt) async {
    if (current == EvilFireBallState.fly) {
      _moveFireball();
    }
    super.update(dt);
  }

  hit() {
    current = EvilFireBallState.hit;
  }

  _moveFireball() {
    if (position.x < gameRef.size.x) {
      position.x -= fireballSpeed;
    } else {
      gameRef.remove(this);
    }
  }

  @override
  void onCollisionStart(intersectionPoints, other) {
    if (other is Hunter) {
      hit();
      other.damageBy(damageValue);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
