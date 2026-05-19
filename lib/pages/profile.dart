import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
              const SizedBox(height: 60),

              const Text(
                'Perfil',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: Color(0xFF000000),
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                  letterSpacing: -0.68,
                ),
              ),

              const SizedBox(height: 32),

              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7E8E3),
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Color(0xFFE76E50),
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Nome do Usuário',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    color: Color(0xFF000000),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  'email@exemplo.com',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    color: Color(0xFF666666),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 42),

              _ItemPerfil(
                icone: Icons.person_outline,
                texto: 'Editar perfil',
                onTap: () {},
              ),
              _ItemPerfil(
                icone: Icons.notifications_outlined,
                texto: 'Notificações',
                onTap: () {},
              ),
              _ItemPerfil(
                icone: Icons.lock_outline,
                texto: 'Privacidade',
                onTap: () {},
              ),
              _ItemPerfil(
                icone: Icons.logout,
                texto: 'Sair',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemPerfil extends StatelessWidget {
  final IconData icone;
  final String texto;
  final VoidCallback onTap;

  const _ItemPerfil({
    required this.icone,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icone, color: const Color(0xFFE76E50), size: 24),
            const SizedBox(width: 16),
            Text(
              texto,
              style: const TextStyle(
                fontFamily: 'SpaceGrotesk',
                color: Color(0xFF000000),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF666666),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
