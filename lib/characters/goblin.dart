import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ghost_hunt/characters/damagable.dart';
import 'package:ghost_hunt/characters/hunter.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

enum GoblinState {
  attack,
  run,
  death,
  takehit,
}

class Goblin extends SpriteAnimationGroupComponent
    with HasGameRef<GhostHuntGame>, CollisionCallbacks, Damagable {
  static const double damageRate = 5;
  double _life = 35;

  Goblin() : super(size: Vector2.all(200));
  @override
  Future<void>? onLoad() async {
    add(CircleHitbox());
    final data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(150.0),
      amount: 2,
      stepTime: 0.1,
    );

    final attack = SpriteAnimation.fromFrameData(
        await gameRef.images.load('goblin/attack.png'),
        SpriteAnimationData.sequenced(
          textureSize: Vector2.all(150.0),
          amount: 3,
          stepTime: 0.1,
        ));
    final run = SpriteAnimation.fromFrameData(
        await gameRef.images.load('goblin/run.png'), data);
    final death = SpriteAnimation.fromFrameData(
        await gameRef.images.load('goblin/death.png'),
        SpriteAnimationData.sequenced(
            textureSize: Vector2.all(150.0),
            amount: 3,
            stepTime: 0.3,
            loop: false));
    death.onComplete = () => removeFromParent();
    final takeHit = SpriteAnimation.fromFrameData(
        await gameRef.images.load('goblin/take_hit.png'), data);

    animations = {
      GoblinState.attack: attack,
      GoblinState.death: death,
      GoblinState.run: run,
      GoblinState.takehit: takeHit
    };
    position = Vector2(gameRef.size[0] - 50, gameRef.size[1] - 125);
    current = GoblinState.takehit;
    flipHorizontallyAroundCenter();
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
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.hunter.isRunning() ? 5 : 1;
    if (position.x < -200) {
      gameRef.remove(this);
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
    current = GoblinState.attack;
  }

  void death() {
    current = GoblinState.attack;
  }
}
