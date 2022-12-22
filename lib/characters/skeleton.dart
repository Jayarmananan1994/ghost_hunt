import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ghost_hunt/characters/damagable.dart';
import 'package:ghost_hunt/characters/hunter.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';
import 'dart:async' as async;

enum SkeletonState {
  attack,
  walk,
  death,
  takehit,
}

class Skeleton extends SpriteAnimationGroupComponent
    with HasGameRef<GhostHuntGame>, CollisionCallbacks, Damagable {
  static const double damageRate = 2;
  double _life = 35;
  bool _isAttackMode = false;
  late final SpriteAnimation attackAnimation;
  async.Timer? _attackTimer;

  Skeleton() : super(size: Vector2.all(160));
  @override
  Future<void>? onLoad() async {
    add(CircleHitbox(radius: 30, position: size / 2, anchor: Anchor.center));
    final data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(150.0),
      amount: 2,
      stepTime: 0.1,
    );

    attackAnimation = SpriteAnimation.fromFrameData(
        await gameRef.images.load('skeleton/attack.png'),
        SpriteAnimationData.sequenced(
          textureSize: Vector2.all(150.0),
          amount: 3,
          stepTime: 0.1,
          loop: false,
        ));
    final walk = SpriteAnimation.fromFrameData(
        await gameRef.images.load('skeleton/walk.png'), data);
    final death = SpriteAnimation.fromFrameData(
        await gameRef.images.load('skeleton/death.png'),
        SpriteAnimationData.sequenced(
            textureSize: Vector2.all(150.0),
            amount: 3,
            stepTime: 0.3,
            loop: false));
    death.onComplete = () => removeFromParent();
    final takeHit = SpriteAnimation.fromFrameData(
        await gameRef.images.load('skeleton/take_hit.png'), data);

    animations = {
      SkeletonState.attack: attackAnimation,
      SkeletonState.death: death,
      SkeletonState.walk: walk,
      SkeletonState.takehit: takeHit
    };
    position = Vector2(gameRef.size[0] - 75, gameRef.size[1] - 135);
    current = SkeletonState.walk;
    flipHorizontallyAroundCenter();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Hunter) {
      attack();
      _isAttackMode = true;
      _attackTimer =
          async.Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (other.isAlive() && isAlive()) {
          attack();
          other.damageBy(damageRate);
        }
      });
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (current != SkeletonState.death) {
      super.onCollisionEnd(other);
      current = SkeletonState.walk;
    }
    if (_attackTimer != null) _attackTimer?.cancel();
  }

  bool isAlive() {
    return current != SkeletonState.death;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isAlive()) {
      position.x -= gameRef.hunter.isRunning()
          ? 4.5
          : (_isAttackMode)
              ? 0
              : .5;
      if (position.x < -200) {
        gameRef.remove(this);
      }
    }
  }

  @override
  void damageBy(double damageValue) {
    _life -= damageValue;
    if (_life <= 0) {
      death();
    }
  }

  void attack() {
    attackAnimation.reset();
    current = SkeletonState.attack;
  }

  void death() {
    current = SkeletonState.death;
  }
}
