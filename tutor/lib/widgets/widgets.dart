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

  static Widget bottomBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today,), //BadIcons.calendarIcon,
          title: Text(
              'one'
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sort,),
          title: Text(
              'two'
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline,),
          title: Text(
              'three'
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings,),
          title: Text(
              'four'
          ),
        ),
      ],
    );
  }

  static Widget bottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('one'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('two'),
          )
        ],
      ),

    );
  }
}
