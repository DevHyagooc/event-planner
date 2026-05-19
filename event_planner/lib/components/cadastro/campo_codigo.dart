import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CamposCodigo extends StatelessWidget {
  final List<TextEditingController> controllers;

  const CamposCodigo({
    super.key,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: List.generate(
        controllers.length,
        (index) {
          return SizedBox(
            width: 40,
            height: 40,

            child: TextField(
              controller: controllers[index],

              maxLength: 1,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,

              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],

              onChanged: (value) {
                if (value.isNotEmpty &&
                    index < controllers.length - 1) {
                  FocusScope.of(context).nextFocus();
                }
              },

              style: const TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),

              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: const Color(0xFFF8F6F4),
                contentPadding: EdgeInsets.zero,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFE6E1DC),
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFE6E1DC),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFE76E50),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}