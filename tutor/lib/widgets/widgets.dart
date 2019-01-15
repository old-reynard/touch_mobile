import 'package:flutter/material.dart';
import 'package:tutor/data/constants.dart';

class Misc {

  static regButtonEmpty({String text, VoidCallback onTap, bool active}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: getButtonColor(active),
            border: active ? null : Border.all(color: regButtonColor),
            borderRadius: BorderRadius.circular(8.0)),
        child: FlatButton(
          onPressed: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: getButtonColor(!active),
                fontSize: 20
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget separator() {
    return Container(
      height: 1,
      decoration: BoxDecoration(color: Colors.blue.withAlpha(100)),
    );
  }

  static Color getButtonColor(bool active) {
    return active ? regButtonColor : Colors.white;
  }
}
