import 'package:flame/components.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

enum FlyingEyeState {
  attack,
  flight,
  death,
  takehit,
}

class FlyingEye extends SpriteAnimationGroupComponent
    with HasGameRef<GhostHuntGame> {
  FlyingEye() : super(size: Vector2.all(100.0));

  @override
  Future<void>? onLoad() async {
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
            loop: true));
    final takeHit = SpriteAnimation.fromFrameData(
        await gameRef.images.load('flying_eye/take_hit.png'), data);

    animations = {
      FlyingEyeState.attack: attack,
      FlyingEyeState.death: death,
      FlyingEyeState.flight: flight,
      FlyingEyeState.takehit: takeHit
    };
    current = FlyingEyeState.flight;
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
}
