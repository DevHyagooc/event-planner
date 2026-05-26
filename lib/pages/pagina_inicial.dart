import 'package:flutter/material.dart';
import '../components/botao.dart';
import 'cadastro.dart';
import 'login.dart';

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),

              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7E8E3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFFE76E50),
                  size: 24,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'EventPlanner',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: Color(0xFFE76E50),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  letterSpacing: -0.32,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Organize eventos\nsem complicação',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: Color(0xFF000000),
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                  letterSpacing: -0.68,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Entre ou crie sua conta para acessar agenda,\ntarefas e seus eventos em um só lugar.',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: Color(0xFF000000),
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  height: 1.0,
                  letterSpacing: -0.22,
                ),
              ),

              // const Spacer(),
              const SizedBox(height: 100),

              BotaoLogin(
                texto: 'Entrar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                  );
                },
                backgroundColor: const Color(0xFFE76E50),
              ),

              const SizedBox(height: 12),

              BotaoLogin(
                texto: 'Cadastrar-se',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Cadastro()),
                  );
                },
                backgroundColor: const Color(0xFFF1EEEA),
                textColor: Colors.black,
              ),

              const SizedBox(height: 12),

              BotaoLogin(
                texto: 'Entrar com o Google',
                onPressed: () {},
                isOutlined: true,
                isGoogle: true,
                backgroundColor: const Color(0xFFF1EEEA),
                textColor: Colors.black,
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
