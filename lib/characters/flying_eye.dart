import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ghost_hunt/characters/damagable.dart';
import 'package:ghost_hunt/characters/hunter.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

enum FlyingEyeState {
  attack,
  flight,
  death,
  takehit,
}

class FlyingEye extends SpriteAnimationGroupComponent
    with HasGameRef<GhostHuntGame>, CollisionCallbacks, Damagable {
  static const double damageRate = 30;
  double _life = 20;

  FlyingEye() : super(size: Vector2.all(100.0));

  @override
  Future<void>? onLoad() async {
    add(CircleHitbox(radius: 30, position: size / 2, anchor: Anchor.center));
    final data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(150.0),
      amount: 2,
      stepTime: 0.1,
    );

    final attack = SpriteAnimation.fromFrameData(
        await gameRef.images.load('flying_eye/attack.png'),
        SpriteAnimationData.sequenced(
          textureSize: Vector2.all(150.0),
          amount: 3,
          stepTime: 0.1,
        ));
    final flight = SpriteAnimation.fromFrameData(
        await gameRef.images.load('flying_eye/flight.png'), data);
    final death = SpriteAnimation.fromFrameData(
        await gameRef.images.load('flying_eye/death.png'),
        SpriteAnimationData.sequenced(
            textureSize: Vector2.all(150.0),
            amount: 3,
            stepTime: 0.3,
            loop: false));
    death.onComplete = () => removeFromParent();
    final takeHit = SpriteAnimation.fromFrameData(
        await gameRef.images.load('flying_eye/take_hit.png'), data);

    animations = {
      FlyingEyeState.attack: attack,
      FlyingEyeState.death: death,
      FlyingEyeState.flight: flight,
      FlyingEyeState.takehit: takeHit
    };
    position = Vector2(gameRef.size[0] - 50, gameRef.size[1] - 125);
    current = FlyingEyeState.flight;
    debugMode = true;
    flipHorizontallyAroundCenter();
  }

  fly() {
    current = FlyingEyeState.flight;
  }

  death() {
    current = FlyingEyeState.death;
  }

  takeHit() {
    current = FlyingEyeState.takehit;
  }

  attack() {
    current = FlyingEyeState.attack;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.hunter.isRunning() ? 5 : 1;
    if (position.x < -200) {
      gameRef.remove(this);
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Hunter) {
      attack();
      other.damageBy(damageRate);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (current != FlyingEyeState.death) {
      super.onCollisionEnd(other);
      fly();
    }
  }

  @override
  void damageBy(double damageValue) {
    _life -= damageValue;
    if (_life <= 0) {
      death();
    } else {
      print("Take hit");
      current = FlyingEyeState.takehit;
    }
  }
}
