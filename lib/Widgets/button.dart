import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? icon;
  final double? iconSize;
  final Color? iconcolor;
  final Color? iconbgcolor;


  CustomIconButton({
    this.onTap,
     this.icon,
     this.iconSize,
    this.iconcolor,
    this.iconbgcolor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Ink(
          decoration: ShapeDecoration(
            color: iconbgcolor,
            shape: CircleBorder(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              icon,
              size: iconSize,
              color: iconcolor,
            ),
          ),
        ),
      ),
    );
  }
}

