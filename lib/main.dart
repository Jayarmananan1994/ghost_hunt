import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ghost_hunt/controls/menu_button.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  runApp(const Home());
  //runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GhostHuntGame _game;
  @override
  Widget build(BuildContext context) {
    _game = GhostHuntGame();
    return MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: _game,
          overlayBuilderMap: {
            'pauseButton': (BuildContext context, GhostHuntGame game) =>
                Positioned(
                  right: 30,
                  top: 50,
                  child: Material(
                    color: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.pause, color: Colors.white),
                      onPressed: () => game.pauseGame(),
                    ),
                  ),
                ),
            'menu': (context, GhostHuntGame game) {
              var gameStateTxt = '';
              if (game.gameState == GhostHuntGameState.gameOver) {
                gameStateTxt = 'Game Over';
              } else if (game.gameState == GhostHuntGameState.gameFinish) {
                gameStateTxt = 'You Won!!';
              } else if (game.gameState == GhostHuntGameState.paused) {
                gameStateTxt = 'Paused';
              }
              return Center(
                child: Card(
                  color: Colors.black.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('GHOST HUNT',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Valorax')),
                        const SizedBox(height: 30),
                        Text(
                          gameStateTxt,
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: 'Valorax'),
                        ),
                        const SizedBox(height: 20),
                        if (game.gameState != GhostHuntGameState.gameOver)
                          MenuButton(
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.white),
                            label: 'Resume',
                            action: () => game.playGame(),
                          ),
                        const SizedBox(height: 20),
                        MenuButton(
                          icon:
                              const Icon(Icons.play_arrow, color: Colors.white),
                          label: 'Restart',
                          action: () {
                            setState(() {
                              _game = GhostHuntGame();
                            });
                          },
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),
              );
            },
          },
        ),
      ),
    );
  }
}
