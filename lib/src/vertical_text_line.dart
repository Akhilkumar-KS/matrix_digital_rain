import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

const kGreen = Color(0xFF00FF66);

class VerticalTextLine extends StatefulWidget {
  const VerticalTextLine(
      {Key? key,
      required this.speed,
      required this.maxLength,
      required this.onFinished})
      : super(key: key);
  final double speed;
  final int maxLength;
  final VoidCallback onFinished;

  @override
  State<VerticalTextLine> createState() => _VerticalTextLineState();
}

class _VerticalTextLineState extends State<VerticalTextLine> {
  late int _maxLength;
  late Duration _stepInterval;
  final List<String> _characters = [];
  late Timer timer;

  @override
  void initState() {
    _maxLength = widget.maxLength;
    _stepInterval = Duration(milliseconds: (500 ~/ widget.speed));
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    timer = Timer.periodic(_stepInterval, (timer) {
      final random = Random();
      String characters =
          'qwertyuiopasdfghjklzxcvbnm.:"*<>|123457890-_=+QWERTY ';
      List chars = characters.split('');
      String element = chars[random.nextInt(chars.length)];

      final box = context.findRenderObject() as RenderBox;

      if (box.size.height > MediaQuery.of(context).size.height * 2) {
        widget.onFinished();
        return;
      }

      setState(() {
        _characters.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<double> stops = [];
    List<Color> colors = [];

    double greenStart = (_characters.length - _maxLength) / _characters.length;
    double greenEnd = (_characters.length - 1) / (_characters.length);
    colors = [
      Colors.transparent,
      kGreen.withOpacity(0.3),
      kGreen.withOpacity(0.5)
    ];
    stops = [0, greenStart, greenEnd];

    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: stops,
            colors: colors,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: _getCharacters(),
        ));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  List<Widget> _getCharacters() {
    List<Widget> textWidgets = [];

    for (var character in _characters) {
      textWidgets.add(GlowText(character,
          style: const TextStyle(fontFamily: "Monospace", fontSize: 18)));
    }
    return textWidgets;
  }
}
