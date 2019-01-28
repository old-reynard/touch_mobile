import 'package:flutter/material.dart';

class Backdrop extends StatefulWidget  {

  final Widget backLayer;
  final AnimationController controller;


  Backdrop({this.controller, this.backLayer,});

  @override
  State<StatefulWidget> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    flingBackdrop();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: bothPanels);
  }


  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final backPanelHeight = constraints.biggest.height;
    final frontPanelHeight = constraints.biggest.height - 250;

    return RelativeRectTween(
        begin: RelativeRect.fromLTRB(0.0, backPanelHeight, 0.0, 0.0),
        end: RelativeRect.fromLTRB(0.0, frontPanelHeight, 0.0, 0.0))
        .animate(
        CurvedAnimation(parent: widget.controller, curve: Curves.linear));
  }



  Widget bothPanels(BuildContext context, BoxConstraints constraints) {


    return Container(
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          widget.backLayer,
          PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: GestureDetector(
              onDoubleTap: () => flingBackdrop(),
              child: Container(color: Colors.orange,),
            ),
          )
        ],
      ),
    );
  }

  bool get isBackdropVisible {
    final AnimationStatus status = widget.controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void flingBackdrop() =>
      widget.controller.fling(velocity: isBackdropVisible ? -1.0 : 1.0);
}