import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final Function action;

  const MenuButton(
      {required this.icon,
      required this.label,
      super.key,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {action()},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: Colors.grey,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(label,
                style:
                    const TextStyle(fontFamily: 'Valorax', color: Colors.white))
          ],
        ),
      ),
    );
  }
}
