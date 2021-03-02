import 'package:SkypeClone/resources/auth_methods.dart';
import 'package:SkypeClone/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringLogo extends StatelessWidget {
  const ShimmeringLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Shimmer.fromColors(
          child: Image.asset("assets/app_logo.png"),
          baseColor: UniversalVariables.blackColor,
          highlightColor: Colors.white),
    );
  }
}
