import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = '';
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;

  Timer? stoppableTimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(
        children: [
          const Align(
              alignment: Alignment(0, -0.8),
              child: Text('Test your reaction speed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900))),
          Align(
              alignment: Alignment.center,
              child: ColoredBox(
                color: const Color(0xFF6D6D6D),
                child: SizedBox(
                    height: 160,
                    width: 300,
                    child: Center(
                        child: Text(millisecondsText,
                            style: const TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)))),
              )),
          Align(
            alignment: const Alignment(0, 0.8),
            child: GestureDetector(
              onTap: () => setState(() {
                switch (gameState) {
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondsText = '';

                    _startWaitingTimer();
                    break;
                  case GameState.waiting:
                    gameState = GameState.canBeStopped;

                    break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    stoppableTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox(
                  color: Colors.black12,
                  child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Center(
                          child: Text(_getButtonText(),
                              style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white))))),
            ),
          )
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return 'START';
      case GameState.waiting:
        return 'WAIT';
      case GameState.canBeStopped:
        return 'STOP';
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;

    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = '${timer.tick * 16} ms';
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();

    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
