import 'package:flutter/material.dart';
import 'models/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'widgets/backdrop.dart';
import 'widgets/widgets.dart' show Misc;

class FindMePage extends StatefulWidget {
  FindMePage({Key key, this.owner}) : super(key: key);

  final User owner;

  @override
  _FindMePageState createState() => _FindMePageState();
}

class _FindMePageState extends State<FindMePage>
    with SingleTickerProviderStateMixin{

  AnimationController animationController;
  GoogleMapController mapController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        controller: animationController,
        backLayer: _map(),
      ),
      bottomNavigationBar: Misc.bottomAppBar(),
    );
  }

  bool get isBackdropVisible {
    final AnimationStatus status = animationController.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void flingBackdrop() =>
      animationController.fling(velocity: isBackdropVisible ? -1.0 : 1.0);

  Widget _map() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
            ],
          ),
        )
      ],
    );
  }


}