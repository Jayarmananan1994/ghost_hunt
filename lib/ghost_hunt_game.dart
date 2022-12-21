import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:ghost_hunt/characters/death_ghost.dart';
import 'package:ghost_hunt/characters/flying_eye.dart';
import 'package:ghost_hunt/characters/hunter.dart';
import 'package:ghost_hunt/characters/skeleton.dart';
import 'package:ghost_hunt/controls/controll_button.dart';
import 'package:ghost_hunt/ghost_hunt_parallex.dart';
import 'dart:async' as async;

enum GhostHuntGameState { active, paused, gameOver, gameFinish }

class GhostHuntGame extends FlameGame with HasTappables, HasCollisionDetection {
  late final ParallaxComponent ghostHuntParallax;
  late final Hunter hunter;
  late final TextComponent hunterLife;
  late async.Timer enemySpawnTimer;
  GhostHuntGameState gameState = GhostHuntGameState.active;
  int level = 1;
  int flyeEyeCount = 0, skeletonCount = 0, deathBringerCount = 0;

  @override
  Future<void>? onLoad() async {
    ghostHuntParallax = await gameParallexBackground();
    var runningButton = runButton();
    var attackBtn = attackButton();
    final style =
        TextStyle(color: BasicPalette.yellow.color, fontFamily: 'Valorax');
    final regular = TextPaint(style: style);

    hunter = Hunter();
    hunter.position = Vector2(70, size[1] - 110);

    add(ghostHuntParallax);
    add(hunter);
    hunterLife =
        TextComponent(text: 'LIFE - ${hunter.life()}', textRenderer: regular);
    add(hunterLife
      ..x = 50
      ..y = 32);

    runningButton
      ..size = Vector2(65.0, 65.0)
      ..position = Vector2(30, size[1] - 75);

    attackBtn
      ..size = Vector2(65.0, 65.0)
      ..position = Vector2(size[0] - 125, size[1] - 75);

    add(runningButton);
    add(attackBtn);
    iniitateAttack();
    overlays.add('pauseButton');
  }

  ControllButton runButton() {
    return ControllButton(
        pressSpritePath: "button/run.png",
        unpressSpritePath: "button/run_2.png",
        pressDown: runPlayer,
        pressUp: resetPlayerToIdle);
  }

  ControllButton attackButton() {
    return ControllButton(
        pressSpritePath: "button/attack.png",
        unpressSpritePath: "button/attack_2.png",
        pressDown: attackWithArch,
        pressUp: resetPlayerToIdle);
  }

  resetPlayerToIdle() {
    ghostHuntParallax.parallax?.baseVelocity = Vector2.zero();
    hunter.idle();
  }

  runPlayer() {
    print("${enemySpawnTimer?.isActive}");
    if (hunter.current == HunterState.idle) {
      ghostHuntParallax.parallax?.baseVelocity = Vector2(50, 0);
      hunter.run();
    }
  }

  attackWithArch() {
    ghostHuntParallax.parallax?.baseVelocity = Vector2.zero();
    hunter.attack();
  }

  void iniitateAttack() {
    print("INITIALETE ATTACK FROM LEVEL $level");

    enemySpawnTimer = async.Timer.periodic(const Duration(seconds: 8), (timer) {
      if (level == 1) {
        flyeEyeCount++;
        add(FlyingEye());
        if (flyeEyeCount == 10) level = 2;
      } else if (level == 2) {
        skeletonCount++;
        add(Skeleton());
        if (skeletonCount == 5) level = 3;
      } else if (level == 3) {
        deathBringerCount++;
        var deathBringer = DeathBringer();
        add(deathBringer);
        if (deathBringerCount == 2) {
          endEnemySpawn();
          deathBringer.onDeath = () => endGame();
        }
      }
    });
  }

  void endEnemySpawn() {
    enemySpawnTimer.cancel();
  }

  void pauseGame() {
    gameState = GhostHuntGameState.paused;
    overlays.add('menu');
    enemySpawnTimer.cancel();

    pauseEngine();
    overlays.remove('pauseButton');
  }

  void playGame() {
    gameState = GhostHuntGameState.active;
    overlays.remove('menu');
    if (!enemySpawnTimer.isActive) iniitateAttack();
    resumeEngine();
    overlays.add('pauseButton');
  }

  endGame() {
    gameState = GhostHuntGameState.gameFinish;
    overlays.add('menu');
    pauseEngine();
  }

  void gameOver() {
    gameState = GhostHuntGameState.gameOver;
    overlays.add('menu');
    pauseEngine();
  }
}
