import 'package:flutter/material.dart';

class BotaoLogin extends StatelessWidget {
  final String texto;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;
  final bool isGoogle;
  final VoidCallback onPressed;

  const BotaoLogin({
    super.key,
    required this.texto,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFE76E50),
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.isGoogle = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = isGoogle
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                texto,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset('assets/images/google.png', height: 28),
              ),
            ],
          )
        : Text(
            texto,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          );

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF1EEEA),
                foregroundColor: textColor,
                side: const BorderSide(color: Color(0xFFE6E1DC)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: child,
            ),
    );
  }
}
