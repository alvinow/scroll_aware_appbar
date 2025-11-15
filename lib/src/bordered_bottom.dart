import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Wrapper for custom bottom widget with border
/// Wrapper for custom bottom widget with border
class BorderedBottom extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  final bool isScrolled;
  final Color borderColor;
  final double borderThickness;
  final Duration animationDuration;

  const BorderedBottom({
    Key? key,
    required this.bottom,
    required this.isScrolled,
    required this.borderColor,
    required this.borderThickness,
    required this.animationDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        bottom,
        AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          height: borderThickness,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isScrolled ? borderColor : Colors.transparent,
                width: borderThickness,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    bottom.preferredSize.height + borderThickness,
  );
}