import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SliderButton extends StatefulWidget {
  final double radius;
  final double height;
  final double width;
  final double buttonSize;
  final Color backgroundColor;
  final Color baseColor;
  final Color highlightedColor;
  final Color buttonColor;
  final Text label;
  final Alignment alignLabel;
  final BoxShadow boxShadow;
  final Widget icon;
  final Function action;
  final bool shimmer;
  final bool dismissible;
  final LinearGradient linearGradient;
  final Alignment alignButton;
  SliderButton({
    @required this.action,
    this.linearGradient = const LinearGradient(
        colors: [
        Colors.white,
        Colors.white,
      ]
    ),
    this.radius = 0,
    this.boxShadow = const BoxShadow(
      color: Colors.black,
      blurRadius: 4,
    ),
    this.shimmer = true,
    this.height = 70,
    this.buttonSize = 60,
    this.width = 250,
    this.alignLabel = const Alignment(0.4, 0),
    this.backgroundColor = const Color(0xffe0e0e0),
    this.baseColor = Colors.teal,
    this.buttonColor = Colors.white,
    this.highlightedColor = Colors.black,
    this.label = const Text(
      "Slide to cancel !",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
    ),
    this.icon = const Icon(
      Icons.power_settings_new,
      color: Colors.red,
      size: 30.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),
    this.alignButton = Alignment.centerLeft,
    this.dismissible = true,
  });

  @override
  _SliderButtonState createState() => _SliderButtonState();
}

class _SliderButtonState extends State<SliderButton> {
  bool flag;

  @override
  void initState() {
    super.initState();
    flag = true;
  }

  @override
  Widget build(BuildContext context) {
    return flag == true
        ? _control()
        : widget.dismissible == true
        ? Container()
        : Container(
      child: _control(),
    );
  }

  Widget _control() => Container(
    height: widget.height,
    width: widget.width,
    decoration: BoxDecoration(
        gradient: widget.linearGradient,
        color: widget.backgroundColor
      ,),
    alignment: Alignment.centerLeft,
    child: Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 30.0),
          alignment: widget.alignLabel,
          child: widget.shimmer
              ? Shimmer.fromColors(
            baseColor: widget.baseColor,
            highlightColor: widget.highlightedColor,
            child: widget.label,
          ): widget.label,
        ),
        Dismissible(
          key: Key("cancel"),
          direction: DismissDirection.startToEnd,
          onDismissed: (dir) async {
            setState(() {
              if (widget.dismissible) {
                flag = false;
              } else {
                flag = !flag;
              }
            });
            widget.action();
          },
          child: Container(
            width: widget.width - 60,
            height: widget.height,
            alignment: widget.alignButton,
            child: Container(
              height: widget.height,
              width: widget.buttonSize*2,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                  color: widget.buttonColor,),
              child: Center(
                  child: widget.icon
              ),
            ),
          ),
        ),
      ],
    ),
  );
}