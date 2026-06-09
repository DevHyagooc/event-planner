import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../services/firestore_service.dart';

import '../components/botao.dart';
import '../components/cadastro/campo_texto_cadastro.dart';
import '../components/cadastro/card_cadastro.dart';
import '../components/card_erro.dart';
import '../services/validacao.dart';
import '../services/email_service.dart';
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

  Future<void> cadastrar() async {
    if (nomeController.text.isEmpty ||
        cpfController.text.isEmpty ||
        emailController.text.isEmpty ||
        senhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      mostrarErro('Preencha todos os dados para realizar o cadastro!');
      return;
    }

    if (!Validators.emailValido(emailController.text)) {
      mostrarErro('Utilize um e-mail institucional válido (@souunit.com.br).');
      return;
    }

    if (!Validators.senhaValida(
      senhaController.text,
      confirmarSenhaController.text,
    )) {
      mostrarErro('As senhas não coincidem ou possuem menos de 6 caracteres.');
      return;
    }

    if (!Validators.cpfValido(cpfController.text)) {
      mostrarErro('Informe um CPF válido com 11 dígitos.');
      return;
    }

    try {
      final cpfLimpo = cpfController.text
          .replaceAll('.', '')
          .replaceAll('-', '');
      final email = emailController.text.trim().toLowerCase();

      final firestoreService = FirestoreService();

      final cpfJaExiste = await firestoreService.cpfExiste(cpfLimpo);

      if (cpfJaExiste) {
        mostrarErro('Já existe um usuário cadastrado com este CPF.');
        return;
      }

      final emailJaExiste = await firestoreService.emailExiste(email);

      if (emailJaExiste) {
        mostrarErro('Já existe um usuário cadastrado com este e-mail.');
        return;
      }

      final codigo = await EmailService.enviarCodigo(
        nome: nomeController.text.trim(),
        email: email,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmarEmail(
            nome: nomeController.text.trim(),
            cpf: cpfLimpo,
            email: email,
            senha: senhaController.text.trim(),
            codigo: codigo,
          ),
        ),
      );
    } catch (e, s) {
      debugPrint('ERRO CADASTRO: $e');
      debugPrint('STACK: $s');

      mostrarErro('Erro ao enviar código de confirmação.');
    }
  }

  void mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (_) => CardErro(mensagem: mensagem),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
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
                        color: Color(0xFF8C7B73),
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
                      placeholder: 'Digite seu CPF',
                      keyboardType: TextInputType.number,
                      inputFormatters: [cpfFormatter],
                    ),
                    const SizedBox(height: 14),
                    CampoTextoCadastro(
                      controller: emailController,
                      label: 'E-mail',
                      placeholder: 'Digite seu e-mail',
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
                              color: Color(0xFF8C7B73),
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
