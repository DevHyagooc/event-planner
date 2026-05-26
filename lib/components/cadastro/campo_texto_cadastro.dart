import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoTextoCadastro extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  const CampoTextoCadastro({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFFE6E1DC),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 50,

          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,

            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 15,
            ),

            decoration: InputDecoration(
              hintText: placeholder,

              hintStyle: const TextStyle(
                color: Color(0xFF8C7B73),
              ),

              filled: true,
              fillColor: const Color(0xFFF9F7F5),

              border: border,
              enabledBorder: border,

              focusedBorder: border.copyWith(
                borderSide: const BorderSide(
                  color: Color(0xFFE76E50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}