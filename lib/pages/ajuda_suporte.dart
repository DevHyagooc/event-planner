import 'package:flutter/material.dart';

class AjudaSuporte extends StatefulWidget {
  const AjudaSuporte({super.key});

  @override
  State<AjudaSuporte> createState() => _AjudaSuporteState();
}

class _AjudaSuporteState extends State<AjudaSuporte> {
  final List<Map<String, String>> perguntas = const [
    {
      'pergunta': 'Como criar um novo evento?',
      'resposta':
          'Na tela inicial, toque no botão "+" no centro da barra inferior, '
              'preencha as informações do evento e confirme.',
    },
    {
      'pergunta': 'Posso editar um evento depois de criado?',
      'resposta':
          'Sim. Abra o evento na agenda e toque em "Editar" para alterar '
              'os dados.',
    },
    {
      'pergunta': 'Como recebo notificações dos meus eventos?',
      'resposta':
          'As notificações são enviadas automaticamente próximas ao horário '
              'do evento. Você pode visualizá-las na seção Notificações.',
    },
    {
      'pergunta': 'Como excluir minha conta?',
      'resposta':
          'Entre em contato com o nosso suporte pelo e-mail '
              'suporte@eventplanner.com solicitando a exclusão.',
    },
    {
      'pergunta': 'O aplicativo é gratuito?',
      'resposta':
          'Sim. Todas as funcionalidades atuais do EventPlanner são '
              'gratuitas.',
    },
  ];

  int? abertoIndex;

  @override
  Widget build(BuildContext context) {
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
                    'Ajuda e Suporte',
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
                  itemCount: perguntas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = perguntas[index];
                    final aberto = abertoIndex == index;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                abertoIndex = aberto ? null : index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['pergunta']!,
                                      style: const TextStyle(
                                        fontFamily: 'SpaceGrotesk',
                                        color: Color(0xFF000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    aberto
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: const Color(0xFFE76E50),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (aberto)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 0, 16, 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item['resposta']!,
                                  style: const TextStyle(
                                    fontFamily: 'SpaceGrotesk',
                                    color: Color(0xFF666666),
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
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
