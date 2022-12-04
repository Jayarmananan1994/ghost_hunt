import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ghost_hunt/ghost_hunt_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  runApp(GameWidget(game: GhostHuntGame()));
  //runApp(const Home());
}

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Stack(
//           children: [
//             GameWidget(game: GhostHuntGame()),
//             ElevatedButton(onPressed: (){}, child: child)
//             IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.run_circle, size: 50))
//           ],
//         ),
//       ),
//     );
//   }
// }
