import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../components/botao.dart';
import '../components/cadastro/campo_texto_cadastro.dart';
import '../components/cadastro/card_cadastro.dart';
import '../components/card_erro.dart';
import '../backend/auth/auth_service.dart';

class EsqueciSenha extends StatefulWidget {
  const EsqueciSenha({super.key});

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  final _authService = AuthService();
  final emailController = TextEditingController();
  bool linkEnviado = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> enviarLink() async {
    debugPrint(
      '[EsqueciSenha] Solicitando envio de recuperacao para ${emailController.text}.',
    );

    final resultado = await _authService.enviarRecuperacaoSenha(
      emailController.text,
    );

    if (!mounted) return;

    if (!resultado.sucesso) {
      debugPrint(
        '[EsqueciSenha] Falha ao enviar recuperacao: ${resultado.mensagem}',
      );
      mostrarMensagem(resultado.mensagem ?? 'Nao foi possivel enviar o link.');
      return;
    }

    debugPrint('[EsqueciSenha] Recuperacao enviada com sucesso para o sender.');

    setState(() {
      linkEnviado = true;
    });
  }

  void mostrarMensagem(String mensagem) {
    showDialog(
      context: context,
      builder: (_) => CardErro(mensagem: mensagem),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2421)),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.23),
              CardCadastro(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAE2DC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.logout_outlined,
                        color: Color(0xFFE76E50),
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      linkEnviado
                          ? 'Enviamos um e-mail de redefinicao.'
                          : 'Digite seu e-mail para receber o link\nde redefinicao de senha.',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8A8580),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (linkEnviado)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF8F6),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFE6E1DC)),
                        ),
                        child: Text.rich(
                          TextSpan(
                            text: 'Um link de recuperacao foi enviado para\n',
                            style: const TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF9A948F),
                              height: 1.05,
                            ),
                            children: [
                              TextSpan(
                                text: emailController.text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF8C7B73),
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      CampoTextoCadastro(
                        controller: emailController,
                        label: 'E-mail',
                        placeholder: 'Digite seu email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 18),
                      BotaoLogin(
                        texto: 'Enviar link de redefinicao',
                        onPressed: enviarLink,
                        backgroundColor: const Color(0xFFE76E50),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text.rich(
                          TextSpan(
                            text: 'Lembrou a senha? ',
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 15,
                              color: Color(0xFF9A948F),
                            ),
                            children: [
                              TextSpan(
                                text: 'Voltar para o login',
                                style: TextStyle(
                                  color: Color(0xFFE76E50),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 42),
            ],
          ),
        ),
      ),
    );
  }
}
