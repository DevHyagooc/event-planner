import 'package:flutter/material.dart';

class Notificacoes extends StatelessWidget {
  const Notificacoes({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notificacoes = [
      {
        'titulo': 'Novo evento criado',
        'descricao': 'Você criou o evento "Reunião de equipe".',
        'tempo': 'há 5 min',
      },
      {
        'titulo': 'Lembrete de evento',
        'descricao': 'O evento "Aniversário do João" começa em 1 hora.',
        'tempo': 'há 1 h',
      },
      {
        'titulo': 'Tarefa concluída',
        'descricao': 'Você concluiu a tarefa "Comprar bolo".',
        'tempo': 'ontem',
      },
      {
        'titulo': 'Convite recebido',
        'descricao': 'Maria te convidou para o evento "Churrasco".',
        'tempo': '2 dias',
      },
      {
        'titulo': 'Atualização do app',
        'descricao': 'EventPlanner foi atualizado para a versão 1.0.0.',
        'tempo': '3 dias',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF000000),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Notificações',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: Color(0xFF000000),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: notificacoes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = notificacoes[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFE76E50).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Color(0xFFE76E50),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['titulo']!,
                                        style: const TextStyle(
                                          fontFamily: 'SpaceGrotesk',
                                          color: Color(0xFF000000),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['tempo']!,
                                      style: const TextStyle(
                                        fontFamily: 'SpaceGrotesk',
                                        color: Color(0xFF666666),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['descricao']!,
                                  style: const TextStyle(
                                    fontFamily: 'SpaceGrotesk',
                                    color: Color(0xFF666666),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
