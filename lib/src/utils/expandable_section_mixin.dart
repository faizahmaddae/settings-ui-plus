import 'package:flutter/material.dart';

/// Shared expand/collapse animation logic for platform settings sections.
///
/// Provides [isExpanded], [expandController], [expandAnimation], and
/// [toggleExpanded] so that both Material and iOS sections stay in sync.
mixin ExpandableSectionMixin<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  late bool isExpanded;
  late final AnimationController expandController;
  late final Animation<double> expandAnimation;

  void initExpandable({
    required bool initiallyExpanded,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    isExpanded = initiallyExpanded;
    expandController = AnimationController(
      duration: duration,
      vsync: this,
      value: isExpanded ? 1.0 : 0.0,
    );
    expandAnimation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOut,
    );
  }

  void disposeExpandable() {
    expandController.dispose();
  }

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        expandController.forward();
      } else {
        expandController.reverse();
      }
    });
  }
}
