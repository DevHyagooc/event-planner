import 'package:flutter/material.dart';

class CardCadastro extends StatelessWidget {
  final Widget child;

  const CardCadastro({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E0DC),
        ),
      ),
      child: child,
    );
  }
}