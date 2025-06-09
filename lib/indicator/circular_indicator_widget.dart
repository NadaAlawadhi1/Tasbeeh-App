import 'package:flutter/material.dart';
import 'package:sub7a/indicator/circular_indicator_painter.dart';

class CircularIndicatorWidget extends StatefulWidget {
  const CircularIndicatorWidget({
    Key? key,
    required this.current,
    this.height,
    this.width,
    this.selectedColor,
    this.unselectedColor,
    this.child,
    this.gradientColor,
    this.maxStep = 100,
    this.widthLine = 3,
    this.heightLine = 20,
    this.curve = Curves.easeInOutQuint,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  final double current;
  final double maxStep;
  final double widthLine;
  final double heightLine;
  final double? height;
  final double? width;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Widget? child;
  final Gradient? gradientColor;
  final Curve curve;
  final Duration duration;

  @override
  _CircularIndicatorWidgetState createState() =>
      _CircularIndicatorWidgetState();
}

class _CircularIndicatorWidgetState extends State<CircularIndicatorWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _animationController;
  Animation? _animation;
  double _current = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween(begin: 0.0, end: widget.current).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: widget.curve,
      ),
    )..addListener(() {
        setState(() {
          _current = _animation!.value;
        });
      });

    _animationController!.forward();
  }

  @override
  void didUpdateWidget(CircularIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.current != widget.current) {
      if (_animationController != null) {
        _animation = Tween(
          begin: oldWidget.current,
          end: widget.current,
        ).animate(
          CurvedAnimation(
            parent: _animationController!,
            curve: widget.curve,
          ),
        );
        _animationController?.forward(from: 0.0);
      } else {
        _updateProgress();
      }
    }
  }

  _updateProgress() {
    setState(() => _current = widget.current);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: widget.height ?? constraints.maxHeight,
          width: widget.width ?? constraints.maxWidth,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-90 / 360),
            child: CustomPaint(
              painter: CircularIndicatorPainter(
                currentStep: _current,
                selectedColor: widget.selectedColor,
                unselectedColor: widget.unselectedColor,
                gradientColor: widget.gradientColor,
                maxStep: widget.maxStep,
                widthLine: widget.widthLine,
                heightLine: widget.heightLine,
              ),
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(90 / 360),
                child: Padding(
                  padding: EdgeInsets.all(widget.heightLine),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
