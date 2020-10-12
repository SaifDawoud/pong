import 'package:flutter/material.dart';
import 'dart:math';

import './ball.dart';
import './bat.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double randX = 1;
  double randY = 1;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  Animation<double> animation;
  AnimationController controller;
  double avilablewidth;
  double avilableheight;
  double posX;
  double posY;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  double increment = 4;
  int score = 0;

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller =
        AnimationController(duration: Duration(minutes: 1), vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += (increment * randX).round()
            : posX -= (increment * randX).round();
        (vDir == Direction.down)
            ? posY += (increment * randY).round()
            : posY -= (increment * randY).round();
      });
      checkBorders();
    });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        avilableheight = constraints.maxHeight;
        avilablewidth = constraints.maxWidth;
        batHeight = avilableheight / 20;
        batWidth = avilablewidth / 5;
        return Stack(children: [
          Positioned(
            top: 0,
            right: 24,
            child: Text('Score:  ${score.toString()}'),
          ),
          Positioned(
            child: Ball(),
            top: posY,
            left: posX,
          ),
          Positioned(
            child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) =>
                    moveBat(update),
                child: Bat(width: batWidth, height: batHeight)),
            bottom: 0,
            left: batPosition,
          ),
        ]);
      },
    );
  }

  void checkBorders() {
    double diameter = 50;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= avilablewidth - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
    if (posY >= avilableheight - diameter - batHeight &&
        vDir == Direction.down) {
//check if the bat is here, otherwise loose
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        setState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessege(context);
      }
    }
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  double randomNumber() {
//this is a number between 0.5 and 1.5;
    var ran = new Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void showMessege(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('would you want to play again?'),
        title: Text('Game Over'),
        actions: [
          FlatButton(
            child: Text('yes'),
            onPressed: () {
              setState(() {
                posX = 0;
                posY = 0;
                score = 0;
              });
              controller.repeat();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('no'),
            onPressed: () {
              Navigator.of(context).pop();
              dispose();
            },
          ),
        ],
      ),
    );
  }
}
