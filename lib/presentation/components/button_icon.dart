import 'package:flutter/material.dart';

class IconInteractive extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const IconInteractive({Key? key, required this.icon, required this.onTap})
      : super(key: key);

  @override
  _IconInteractiveState createState() => _IconInteractiveState();
}

class _IconInteractiveState extends State<IconInteractive> {
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(widget.icon, color: color),
      onTapDown: (x) {
        setState(() {
          color = Colors.grey;
        });
      },
      onTapUp: (x) {
        widget.onTap.call();
        setState(() {
          color = Colors.white;
        });
      },
    );
  }
}
