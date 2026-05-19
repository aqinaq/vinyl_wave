import 'package:flutter/material.dart';

class FadeSlidePage extends StatefulWidget {
  final Widget child;

  const FadeSlidePage({
    super.key,
    required this.child,
  });

  @override
  State<FadeSlidePage> createState() => _FadeSlidePageState();
}

class _FadeSlidePageState extends State<FadeSlidePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: widget.child,
      ),
    );
  }
}

class BottomUpPage extends StatefulWidget {
  final Widget child;

  const BottomUpPage({
    super.key,
    required this.child,
  });

  @override
  State<BottomUpPage> createState() => _BottomUpPageState();
}

class _BottomUpPageState extends State<BottomUpPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: widget.child,
      ),
    );
  }
}