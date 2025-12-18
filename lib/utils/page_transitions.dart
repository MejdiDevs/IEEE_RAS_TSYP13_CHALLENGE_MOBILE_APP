import 'package:flutter/material.dart';

/// Modern fade + slide transition
/// Clean, smooth animation with subtle slide effect
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final SlideDirection direction;

  SlidePageRoute({
    required this.child,
    this.direction = SlideDirection.rightToLeft,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin;
            Offset end = Offset.zero;

            switch (direction) {
              case SlideDirection.rightToLeft:
                begin = const Offset(0.05, 0.0);
                break;
              case SlideDirection.leftToRight:
                begin = const Offset(-0.05, 0.0);
                break;
              case SlideDirection.bottomToTop:
                begin = const Offset(0.0, 0.05);
                break;
              case SlideDirection.topToBottom:
                begin = const Offset(0.0, -0.05);
                break;
            }

            final slideAnimation = Tween<Offset>(
              begin: begin,
              end: end,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ));

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
        );
}

enum SlideDirection {
  rightToLeft,
  leftToRight,
  bottomToTop,
  topToBottom,
}

/// Modern fade transition
/// Clean fade in/out without scaling or sliding
class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  ScalePageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ));

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        );
}

