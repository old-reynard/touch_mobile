import 'package:flutter/material.dart';
import 'package:tutor/data/constants.dart';

class Misc {
  static Widget regButton({String text, VoidCallback onPress}) {
    return Container(
      child: Center(
        child: Material(
          color: regButtonColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: MaterialButton(
              minWidth: double.infinity,
              onPressed: onPress,
              child: Text(
                text,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }
}
