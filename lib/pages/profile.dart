import 'package:flutter/material.dart';
import 'ajuda_suporte.dart';
import 'aparencia.dart';
import 'configuracoes.dart';
import 'notificacoes.dart';
import 'pagina_inicial.dart';
import 'privacidade.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perfil',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: Color(0xFF000000),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE76E50).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFFE76E50),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Organizador',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: Color(0xFF000000),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Gerencie seus eventos',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: Color(0xFF666666),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      icone: Icons.calendar_today_outlined,
                      valor: '0',
                      texto: 'Eventos',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icone: Icons.checklist_outlined,
                      valor: '0',
                      texto: 'Concluídos',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      icone: Icons.check_box_outlined,
                      valor: '0',
                      texto: 'Tarefas',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icone: Icons.check_box_outlined,
                      valor: '0',
                      texto: 'Finalizadas',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const _TituloSecao(texto: 'GERAL'),
              const SizedBox(height: 8),
              _Grupo(
                itens: [
                  _ItemPerfil(
                    icone: Icons.settings_outlined,
                    texto: 'Configurações',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Configuracoes(),
                        ),
                      );
                    },
                  ),
                  _ItemPerfil(
                    icone: Icons.notifications_outlined,
                    texto: 'Notificações',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Notificacoes(),
                        ),
                      );
                    },
                  ),
                  _ItemPerfil(
                    icone: Icons.dark_mode_outlined,
                    texto: 'Aparência',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Aparencia(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const _TituloSecao(texto: 'SUPORTE'),
              const SizedBox(height: 8),
              _Grupo(
                itens: [
                  _ItemPerfil(
                    icone: Icons.shield_outlined,
                    texto: 'Privacidade',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Privacidade(),
                        ),
                      );
                    },
                  ),
                  _ItemPerfil(
                    icone: Icons.help_outline,
                    texto: 'Ajuda e Suporte',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AjudaSuporte(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _Grupo(
                itens: [
                  _ItemPerfil(
                    icone: Icons.logout,
                    texto: 'Sair',
                    corDestaque: true,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaginaInicial(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'EventPlanner v1.0.0',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icone;
  final String valor;
  final String texto;

  const _StatCard({
    required this.icone,
    required this.valor,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          Icon(icone, color: const Color(0xFFE76E50), size: 20),
          const SizedBox(height: 6),
          Text(
            valor,
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: Color(0xFF000000),
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            texto,
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: Color(0xFF666666),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TituloSecao extends StatelessWidget {
  final String texto;
  const _TituloSecao({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        texto,
        style: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          color: Color(0xFF666666),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _Grupo extends StatelessWidget {
  final List<Widget> itens;
  const _Grupo({required this.itens});

  @override
  Widget build(BuildContext context) {
    final List<Widget> filhos = [];
    for (int i = 0; i < itens.length; i++) {
      filhos.add(itens[i]);
      if (i < itens.length - 1) {
        filhos.add(const Divider(height: 1, color: Color(0xFFE5E5E5)));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(children: filhos),
      ),
    );
  }
}

class _ItemPerfil extends StatelessWidget {
  final IconData icone;
  final String texto;
  final VoidCallback onTap;
  final bool corDestaque;

  const _ItemPerfil({
    required this.icone,
    required this.texto,
    required this.onTap,
    this.corDestaque = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color cor =
        corDestaque ? const Color(0xFFE53935) : const Color(0xFF666666);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icone, color: cor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: corDestaque
                      ? const Color(0xFFE53935)
                      : const Color(0xFF000000),
                  fontSize: 14,
                  fontWeight:
                      corDestaque ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            if (!corDestaque)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF666666),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

