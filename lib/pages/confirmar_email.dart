import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../backend/auth/auth_service.dart';
import '../components/botao.dart';
import '../components/cadastro/campo_codigo.dart';
import '../components/cadastro/card_cadastro.dart';
import '../components/card_erro.dart';
import 'home.dart';

class ConfirmarEmail extends StatefulWidget {
  final String email;
  final String codigoConfirmacao;

  const ConfirmarEmail({
    super.key,
    required this.email,
    required this.codigoConfirmacao,
  });

  @override
  State<ConfirmarEmail> createState() => _ConfirmarEmailState();
}

class _ConfirmarEmailState extends State<ConfirmarEmail> {
  final _authService = AuthService();
  final controllers = List.generate(5, (_) => TextEditingController());
  late String codigoConfirmacao;

  @override
  void initState() {
    super.initState();
    codigoConfirmacao = widget.codigoConfirmacao;
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> reenviarCodigo() async {
    debugPrint('[ConfirmarEmail] Reenviando codigo para ${widget.email}.');

    final resultado = await _authService.enviarConfirmacaoEmail(widget.email);

    if (!mounted) return;

    if (!resultado.sucesso) {
      debugPrint(
        '[ConfirmarEmail] Falha ao reenviar codigo: ${resultado.mensagem}',
      );
      mostrarErro(resultado.mensagem ?? 'Nao foi possivel reenviar o codigo.');
      return;
    }

    debugPrint('[ConfirmarEmail] Codigo reenviado com sucesso para o sender.');

    setState(() {
      codigoConfirmacao = resultado.codigoConfirmacao ?? codigoConfirmacao;
      for (final controller in controllers) {
        controller.clear();
      }
    });
  }

  void confirmarCodigo() {
    final codigoDigitado = controllers
        .map((controller) => controller.text)
        .join();

    if (codigoDigitado != codigoConfirmacao) {
      mostrarErro('Codigo de confirmacao invalido.');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Home()),
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
                        'Digite o codigo enviado para\n${widget.email}.',
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
                        'Codigo de confirmacao',
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
                      Center(
                        child: GestureDetector(
                          onTap: reenviarCodigo,
                          child: const Text(
                            'Nao recebeu o codigo? Reenvie o e-\nmail de confirmacao.',
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
