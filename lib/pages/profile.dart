import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  static const Color _bg = Color(0xFFF5F3F1);
  static const Color _card = Color(0xFFFFFFFF);
  static const Color _border = Color(0xFFE8E2DE);
  static const Color _primary = Color(0xFFE76E50);
  static const Color _primarySoft = Color(0xFFFADED6);
  static const Color _foreground = Color(0xFF2C2421);
  static const Color _muted = Color(0xFF8C7B73);
  static const Color _destructive = Color(0xFFEB5757);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    'Perfil',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: _foreground,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildHeaderUsuario(),
                const SizedBox(height: 24),
                _buildGridEstatisticas(),
                const SizedBox(height: 24),
                _buildSecao(
                  titulo: 'Geral',
                  itens: [
                    _ItemConfig(
                      icone: Icons.settings_outlined,
                      texto: 'Configurações',
                      onTap: () {},
                    ),
                    _ItemConfig(
                      icone: Icons.notifications_outlined,
                      texto: 'Notificações',
                      onTap: () {},
                    ),
                    _ItemConfig(
                      icone: Icons.dark_mode_outlined,
                      texto: 'Aparência',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSecao(
                  titulo: 'Suporte',
                  itens: [
                    _ItemConfig(
                      icone: Icons.shield_outlined,
                      texto: 'Privacidade',
                      onTap: () {},
                    ),
                    _ItemConfig(
                      icone: Icons.help_outline,
                      texto: 'Ajuda e Suporte',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildBotaoSair(),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'EventPlanner v1.0.0',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderUsuario() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: _primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: _primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Organizador',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: _foreground,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Gerencie seus eventos',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: _muted,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridEstatisticas() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: const [
        _CardEstatistica(
          icone: Icons.calendar_today_outlined,
          valor: '0',
          rotulo: 'Eventos',
        ),
        _CardEstatistica(
          icone: Icons.checklist_outlined,
          valor: '0',
          rotulo: 'Concluídos',
        ),
        _CardEstatistica(
          icone: Icons.check_box_outlined,
          valor: '0',
          rotulo: 'Tarefas',
        ),
        _CardEstatistica(
          icone: Icons.task_alt_outlined,
          valor: '0',
          rotulo: 'Finalizadas',
        ),
      ],
    );
  }

  Widget _buildSecao({
    required String titulo,
    required List<_ItemConfig> itens,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            titulo.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (int i = 0; i < itens.length; i++) ...[
                itens[i],
                if (i < itens.length - 1)
                  const Divider(height: 1, thickness: 1, color: _border),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBotaoSair() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.logout, color: _destructive, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Sair',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    color: _destructive,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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

class _CardEstatistica extends StatelessWidget {
  final IconData icone;
  final String valor;
  final String rotulo;

  const _CardEstatistica({
    required this.icone,
    required this.valor,
    required this.rotulo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Profile._card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Profile._border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, color: Profile._primary, size: 20),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: Profile._foreground,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            rotulo,
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: Profile._muted,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemConfig extends StatelessWidget {
  final IconData icone;
  final String texto;
  final VoidCallback onTap;

  const _ItemConfig({
    required this.icone,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icone, color: Profile._muted, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: Profile._foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Profile._muted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
