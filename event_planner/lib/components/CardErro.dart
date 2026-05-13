import 'package:flutter/material.dart';
import 'BotaoLogin.dart';

class CardErro extends StatelessWidget {
  final String mensagem;

  const CardErro({super.key, required this.mensagem});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Erro!',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            mensagem,
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 16,
              color: Color(0xFF8C7B73),
            ),
          ),

          const SizedBox(height: 24),

          BotaoLogin(
            texto: 'Ok',
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: const Color(0xFFE76E50),
          ),
        ],
      ),
    );
  }
}
