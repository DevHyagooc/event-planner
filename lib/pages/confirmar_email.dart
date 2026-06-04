import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/botao.dart';
import '../components/cadastro/card_cadastro.dart';
import '../components/cadastro/campo_codigo.dart';
import '../components/card_erro.dart';
import 'home.dart';

class ConfirmarEmail extends StatefulWidget {
  final String nome;
  final String cpf;
  final String email;
  final String senha;
  final String codigo;

  const ConfirmarEmail({
    super.key,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.codigo,
  });

  @override
  State<ConfirmarEmail> createState() => _ConfirmarEmailState();
}

class _ConfirmarEmailState extends State<ConfirmarEmail> {
  final controllers = List.generate(5, (_) => TextEditingController());

  Future<void> confirmarCodigo() async {
    final codigoDigitado = controllers.map((c) => c.text).join();

    if (codigoDigitado.length < 5) {
      mostrarErro('Digite o código completo.');
      return;
    }

    if (codigoDigitado != widget.codigo) {
      mostrarErro('Código de confirmação inválido.');
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.senha,
      );

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('cadastro_usuarios')
          .doc(uid)
          .set({
        'uid': uid,
        'nome': widget.nome,
        'cpf': widget.cpf,
        'email': widget.email,
        'emailConfirmado': true,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        mostrarErro('Este e-mail já está cadastrado.');
      } else if (e.code == 'weak-password') {
        mostrarErro('A senha precisa ter pelo menos 6 caracteres.');
      } else {
        mostrarErro('Não foi possível concluir o cadastro.');
      }
    } catch (e) {
      mostrarErro('Erro inesperado ao confirmar cadastro.');
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
                      color: Color(0xFF2C2421),
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
                          color: const Color(0xFFFAE2DC),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8C7B73),
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
                      CamposCodigo(controllers: controllers),
                      const SizedBox(height: 18),
                      BotaoLogin(
                        texto: 'Confirmar e entrar',
                        onPressed: confirmarCodigo,
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
                const SizedBox(height: 42),
              ],
            ),
          ),
        ),
      ),
    );
  }
}