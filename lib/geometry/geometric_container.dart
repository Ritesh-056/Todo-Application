import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/const.dart';
import 'package:flutter_app/geometry/custom_clipper.dart';

class ScreenGeometricCurve extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size  = MediaQuery.of(context).size;

    return Container(
          child: Transform.rotate(
              angle: pi/5,
            child: ClipPath(
              clipper:CustomScreenShape(),
              child: Container(
                height:size.height * .3,
                width: size.width,
                decoration:BoxDecoration(
                    gradient:LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:[colorsName!, colorsName!],
                  )
                )
                ),
              ),
            ),
          );
  }
}