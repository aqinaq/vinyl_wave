import 'package:flutter/material.dart';

class AnimatedCartButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool enabled;

  const AnimatedCartButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  State<AnimatedCartButton> createState() => _AnimatedCartButtonState();
}

class _AnimatedCartButtonState extends State<AnimatedCartButton> {
  bool added = false;

  Future<void> handleTap() async {
    if (!widget.enabled) {
      return;
    }

    widget.onPressed();

    setState(() {
      added = true;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    setState(() {
      added = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: widget.enabled ? handleTap : null,
      tooltip: widget.enabled ? 'Add to cart' : 'Sold out',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          added ? Icons.check : Icons.add_shopping_cart,
          key: ValueKey<bool>(added),
        ),
      ),
    );
  }
}