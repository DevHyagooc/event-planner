import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../components/botao.dart';
import '../components/cadastro/campo_texto_cadastro.dart';
import '../components/cadastro/card_cadastro.dart';
import '../components/card_erro.dart';
import '../services/validacao.dart';
import 'confirmar_email.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void cadastrar() {
    if (nomeController.text.isEmpty ||
        cpfController.text.isEmpty ||
        emailController.text.isEmpty ||
        senhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      mostrarErro('Preencha todos os dados para realizar o cadastro!');
      return;
    }

    if (!Validators.emailValido(emailController.text)) {
      mostrarErro('Digite um e-mail válido.');
      return;
    }

    if (!Validators.senhaValida(
      senhaController.text,
      confirmarSenhaController.text,
    )) {
      mostrarErro('As senhas não coincidem.');
      return;
    }

    if (!Validators.cpfValido(cpfController.text)) {
      mostrarErro('CPF inválido.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmarEmail(email: emailController.text),
      ),
    );
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
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),

              const SizedBox(height: 10),

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
                        Icons.person_add_alt_1_outlined,
                        color: Color(0xFFE76E50),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Criar conta',

                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Monte seu acesso e confirme seu e-mail com o código enviado.',

                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 15,
                        color: Color(0xFF8A8580),
                      ),
                    ),

                    const SizedBox(height: 22),

                    CampoTextoCadastro(
                      controller: nomeController,
                      label: 'Nome',
                      placeholder: 'Digite seu nome',
                    ),

                    const SizedBox(height: 14),

                    CampoTextoCadastro(
                      controller: cpfController,
                      label: 'CPF',
                      placeholder: 'Digite seu cpf',
                      keyboardType: TextInputType.number,
                      inputFormatters: [cpfFormatter],
                    ),

                    const SizedBox(height: 14),

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

                    const SizedBox(height: 14),

                    CampoTextoCadastro(
                      controller: confirmarSenhaController,
                      label: 'Confirmar senha',
                      placeholder: 'Digite sua senha',
                      obscureText: true,
                    ),

                    const SizedBox(height: 18),

                    BotaoLogin(
                      texto: 'Entrar',
                      onPressed: cadastrar,
                      backgroundColor: const Color(0xFFE76E50),
                    ),

                    const SizedBox(height: 14),

                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),

                        child: const Text.rich(
                          TextSpan(
                            text: 'Já tem conta? ',

                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 14,
                              color: Color(0xFF9A948F),
                            ),

                            children: [
                              TextSpan(
                                text: 'Fazer login',

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

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
