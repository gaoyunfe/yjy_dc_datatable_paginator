//Botao
import 'package:flutter/material.dart';

class DcButton extends StatelessWidget {
  /// Callback for button press.
  final VoidCallback? onPressed;

  /// The child of the button.
  final Widget child;

  /// Whether the button is currently selected.
  final bool selected;

  /// Creates an instance of [DcButton].
  const DcButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: _backgroundColor(context, selected),
          ),
          child: child,
        ),
      ),
    );
  }

  Color? _backgroundColor(BuildContext context, bool selected) =>
      selected ? Theme.of(context).colorScheme.primary : Colors.grey[300];
}
