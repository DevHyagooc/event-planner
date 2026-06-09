import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/botao.dart';
import '../components/cadastro/campo_texto_cadastro.dart';
import '../components/cadastro/card_cadastro.dart';
import '../components/card_erro.dart';
import '../services/validacao.dart';

class EsqueciSenha extends StatefulWidget {
  const EsqueciSenha({super.key});

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  final emailController = TextEditingController();
  bool linkEnviado = false;
  bool carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> enviarLink() async {
    debugPrint('RESET SENHA: clique em enviar link recebido.');

    if (carregando) {
      debugPrint('RESET SENHA: chamada ignorada porque ja esta carregando.');
      return;
    }

    if (emailController.text.isEmpty) {
      debugPrint('RESET SENHA: campo de e-mail vazio.');
      mostrarMensagem('Digite seu e-mail para receber o link.');
      return;
    }

    if (!Validators.emailValido(emailController.text)) {
      debugPrint(
        'RESET SENHA: e-mail invalido pela validacao do app: '
        '${emailController.text}',
      );
      mostrarMensagem('Digite um e-mail valido.');
      return;
    }

    final email = emailController.text.trim().toLowerCase();

    debugPrint('RESET SENHA: e-mail normalizado para envio: $email');

    setState(() {
      carregando = true;
    });

    try {
      debugPrint('RESET SENHA: chamando FirebaseAuth.sendPasswordResetEmail.');

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      debugPrint('RESET SENHA: Firebase confirmou envio do link para $email.');

      setState(() {
        linkEnviado = true;
      });
    } on FirebaseAuthException catch (e, s) {
      debugPrint('ERRO RESET SENHA FIREBASE: ${e.code} - ${e.message}');
      debugPrint('STACK RESET SENHA FIREBASE: $s');

      if (!mounted) return;

      mostrarMensagem(_mensagemErroFirebase(e));
    } catch (e, s) {
      debugPrint('ERRO RESET SENHA: $e');
      debugPrint('STACK RESET SENHA: $s');

      if (!mounted) return;

      mostrarMensagem('Nao foi possivel enviar o e-mail. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  String _mensagemErroFirebase(FirebaseAuthException erro) {
    switch (erro.code) {
      case 'invalid-email':
        return 'Digite um e-mail valido.';
      case 'user-not-found':
        return 'Nao encontramos uma conta com este e-mail.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Sem conexao com a internet. Verifique sua rede.';
      default:
        return 'Nao foi possivel enviar o e-mail. Tente novamente.';
    }
  }

  Future<void> mostrarMensagem(String mensagem) {
    return showDialog(
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
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF2C2421),
                  ),
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
                        Icons.lock_reset_outlined,
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
                      style: const TextStyle(
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
                          border: Border.all(
                            color: const Color(0xFFE6E1DC),
                          ),
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
                                text: emailController.text.trim().toLowerCase(),
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
                        texto: carregando
                            ? 'Enviando...'
                            : 'Enviar link de redefinicao',
                        onPressed: enviarLink,
                        backgroundColor: carregando
                            ? const Color(0xFFE7A18F)
                            : const Color(0xFFE76E50),
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
