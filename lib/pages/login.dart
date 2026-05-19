import 'package:flutter/material.dart';

import '../components/botao.dart';
import '../components/cadastro/campo_texto_cadastro.dart';
import '../components/cadastro/card_cadastro.dart';
import '../components/card_erro.dart';
import '../services/validacao.dart';
import 'cadastro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void entrar() {
    if (emailController.text.isEmpty || senhaController.text.isEmpty) {
      mostrarErro('Preencha e-mail e senha para entrar.');
      return;
    }

    if (!Validators.emailValido(emailController.text)) {
      mostrarErro('Digite um e-mail valido.');
      return;
    }
  }

  void mostrarErro(String mensagem) {
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
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              const SizedBox(height: 70),
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
                        Icons.login_outlined,
                        color: Color(0xFFE76E50),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Entrar',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Acesse sua conta para continuar organizando seus eventos.',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 15,
                        color: Color(0xFF8A8580),
                      ),
                    ),
                    const SizedBox(height: 22),
                    CampoTextoCadastro(
                      controller: emailController,
                      label: 'E-mail',
                      placeholder: 'Digite seu email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    CampoTextoCadastro(
                      controller: senhaController,
                      label: 'Senha',
                      placeholder: 'Digite sua senha',
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE76E50),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    BotaoLogin(
                      texto: 'Entrar',
                      onPressed: entrar,
                      backgroundColor: const Color(0xFFE76E50),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const Cadastro()),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: 'Nao tem conta? ',
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 14,
                              color: Color(0xFF9A948F),
                            ),
                            children: [
                              TextSpan(
                                text: 'Cadastrar-se',
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
