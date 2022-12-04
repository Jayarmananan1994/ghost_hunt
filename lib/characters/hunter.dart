import 'package:flame/components.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

enum HunterState {
  death,
  highattack,
  idle,
  run,
  lowattack,
  normalattack,
}

class Hunter extends SpriteAnimationGroupComponent
    with HasGameRef<GhostHuntGame> {
  Hunter() : super(size: Vector2.all(100.0));

  @override
  Future<void>? onLoad() async {
    // assets/images/hunter/hunter_normal_attack_0.png
    // assets/images/hunter/hunter_normal_atttack_0.png
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

    var idleSprite = [for (var i = 1; i <= 2; i++) i]
        .map((i) => Sprite.load('hunter/idle_$i.png'));
    final idleAnimation = await createAnimationForSprites(idleSprite, false);

    var runSprite = [for (var i = 1; i <= 8; i++) i]
        .map((i) => Sprite.load('hunter/run_$i.png'));
    final runAnimation = await createAnimationForSprites(runSprite, true);

    var normalAttackSprites = List.generate(16, (i) => i + 1)
        .map((i) => Sprite.load('hunter/normal_attack_$i.png'));
    final normalAttack =
        await createAnimationForSprites(normalAttackSprites, true);

    animations = {
      HunterState.highattack: highAttackAnimation,
      HunterState.lowattack: lowAttackAnimation,
      HunterState.normalattack: normalAttack,
      HunterState.death: deathAnimation,
      HunterState.idle: idleAnimation,
      HunterState.run: runAnimation,
    };
    current = HunterState.idle;
  }

  Future<SpriteAnimation> createAnimationForSprites(
      Iterable<Future<Sprite>> sprites, bool loop) async {
    return SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.1,
      loop: loop,
    );
  }

  void run() {
    current = HunterState.run;
  }

  void idle() {
    current = HunterState.idle;
    print("reset player back to idle");
  }

  void attack() {
    current = HunterState.normalattack;
  }

  HunterState currentState() {
    return current;
  }
}
