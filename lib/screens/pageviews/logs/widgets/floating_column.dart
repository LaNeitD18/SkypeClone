import 'package:SkypeClone/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class FloatingColumn extends StatelessWidget {
  const FloatingColumn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: UniversalVariables.fabGradient,
          ),
          child: Icon(
            Icons.dialpad,
            color: Colors.white,
            size: 25,
          ),
          padding: EdgeInsets.all(15),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: UniversalVariables.blackColor,
            border: Border.all(
              width: 2,
              color: UniversalVariables.gradientColorEnd,
            ),
          ),
          child: Icon(
            Icons.add_call,
            color: UniversalVariables.gradientColorEnd,
            size: 25,
          ),
          padding: EdgeInsets.all(15),
        ),
      ],
    );
  }
}
