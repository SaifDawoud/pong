import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  final double width;
  final double height;
  Bat({this.height, this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(color: Colors.blue[900]),
    );
  }
}
