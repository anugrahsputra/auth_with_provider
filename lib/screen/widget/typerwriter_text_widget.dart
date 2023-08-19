import 'package:flutter/material.dart';

class Typertext extends StatefulWidget {
  const Typertext({
    Key? key,
    required this.text,
    required this.duration,
    required this.style,
    this.repeat = false,
    this.pauseDuration = const Duration(milliseconds: 1000),
  }) : super(key: key);
  final String text;
  final Duration duration;
  final TextStyle style;
  final bool repeat;
  final Duration pauseDuration;

  @override
  State<Typertext> createState() => _TypertextState();
}

class _TypertextState extends State<Typertext>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  late String? _displayedText;

  _TypertextState() : _displayedText = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration + widget.pauseDuration,
    );

    _animation = IntTween(
      begin: 0,
      end: widget.text.length * 2,
    ).animate(_controller);

    _controller.forward();

    _animation.addListener(() {
      setState(() {
        final int textLength = _animation.value;
        if (textLength <= widget.text.length) {
          _displayedText = widget.text.substring(0, textLength);
        } else {
          int reverseTextLength = 2 * widget.text.length - textLength;
          _displayedText = widget.text.substring(0, reverseTextLength);
        }
      });
    });
    _controller.addStatusListener((status) {
      if (widget.repeat) {
        if (status == AnimationStatus.completed) {
          Future.delayed(widget.pauseDuration, () {
            _controller.reverse(from: 1.0);
          });
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward(from: 0.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        _displayedText!,
        style: widget.style,
      ),
      if (_animation.value < widget.text.length * 2) const SizedBox(width: 8.0),
      Icon(
        Icons.accessible_forward_sharp,
        color: widget.style.color,
      )
    ]);
  }
}
