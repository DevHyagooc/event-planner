import 'package:flutter/material.dart';
import '../components/botao.dart';
import '../components/cadastro/card_cadastro.dart';
import '../components/cadastro/campo_codigo.dart';
import 'tarefas/tarefas_page.dart';

class ConfirmarEmail extends StatefulWidget {
  final String email;

  const ConfirmarEmail({
    super.key,
    required this.email,
  });

  @override
  State<ConfirmarEmail> createState() => _ConfirmarEmailState();
}

class _ConfirmarEmailState extends State<ConfirmarEmail> {
  final controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F1),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Column(
              children: [
                const SizedBox(height: 18),

                Align(
                  alignment: Alignment.centerLeft,

                  child: IconButton(
                    onPressed: () => Navigator.pop(context),

                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                CardCadastro(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Container(
                        width: 42,
                        height: 42,

                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE6E0),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Icon(
                          Icons.person_add_alt_1_outlined,
                          color: Color(0xFFE76E50),
                          size: 22,
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Confirmar e-mail',

                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Digite o código enviado para\n${widget.email}.',

                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8A8580),
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'Código de confirmação',

                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 12),

                      CamposCodigo(
                        controllers: controllers,
                      ),

                      const SizedBox(height: 18),

                      BotaoLogin(
                        texto: 'Confirmar e entrar',
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TarefasPage(),
                            ),
                            (_) => false,
                          );
                        },
                        backgroundColor: const Color(0xFFE76E50),
                      ),

                      const SizedBox(height: 16),

                      const Center(
                        child: Text(
                          'Não recebeu o código? Reenvie o e-\nmail de confirmação.',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF9A948F),
                            height: 1.1,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),

                          child: const Text(
                            'Voltar para cadastro',

                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE76E50),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
