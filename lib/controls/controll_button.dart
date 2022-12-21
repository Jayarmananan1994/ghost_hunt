import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

class ControllButton extends SpriteGroupComponent<ButtonState>
    with HasGameRef<GhostHuntGame>, Tappable {
  String pressSpritePath;
  String unpressSpritePath;
  Function pressDown;
  Function pressUp;

  ControllButton(
      {required this.pressSpritePath,
      required this.unpressSpritePath,
      required this.pressDown,
      required this.pressUp});

  @override
  Future<void>? onLoad() async {
    final pressedSprite = await gameRef.loadSprite(pressSpritePath);
    final unpressedSprite = await gameRef.loadSprite(unpressSpritePath);

    sprites = {
      ButtonState.down: pressedSprite,
      ButtonState.up: unpressedSprite,
    };

    current = ButtonState.up;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    current = ButtonState.down;
    pressDown();
    return super.onTapDown(info);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    current = ButtonState.up;
    pressUp();
    return super.onTapUp(info);
  }

  // @override
  // bool onTapCancel() {
  //   return super.onTapCancel();
  // }
}
