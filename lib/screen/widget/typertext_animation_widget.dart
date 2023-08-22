import 'package:flutter/material.dart';

class TyperTextAnimaton extends StatefulWidget {
  const TyperTextAnimaton({
    Key? key,
    required this.text,
    required this.durationMsPerCharacter,
    required this.pauseMsPerCharacter,
    required this.repeatAnimation,
    this.style = const TextStyle(fontSize: 32),
  }) : super(key: key);
  final String text;
  final int durationMsPerCharacter;
  final int pauseMsPerCharacter;
  final bool repeatAnimation;
  final TextStyle style;

  @override
  State<TyperTextAnimaton> createState() => _TyperTextAnimatonState();
}

class _TyperTextAnimatonState extends State<TyperTextAnimaton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _displayedString = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
          milliseconds: widget.text.length * widget.durationMsPerCharacter),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          final percent = _controller.value;
          final index = (widget.text.length * percent).round();
          _displayedString = widget.text.substring(0, index);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: widget.pauseMsPerCharacter),
              () {
            if (widget.repeatAnimation) {
              _controller.reverse();
            }
          });
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(Duration(milliseconds: widget.pauseMsPerCharacter),
              () {
            if (widget.repeatAnimation) {
              _controller.forward();
            }
          });
        }
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayedString, style: widget.style);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
