import 'package:flutter/material.dart';

class Privacidade extends StatelessWidget {
  const Privacidade({super.key});

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
                    'Privacidade',
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
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _Titulo(texto: 'Termo de Privacidade'),
                        SizedBox(height: 8),
                        _Paragrafo(
                          texto:
                              'O EventPlanner respeita a sua privacidade e está '
                              'comprometido em proteger seus dados pessoais. '
                              'Este termo descreve como suas informações são '
                              'coletadas, usadas e armazenadas.',
                        ),
                        SizedBox(height: 16),
                        _Subtitulo(texto: '1. Coleta de Informações'),
                        SizedBox(height: 4),
                        _Paragrafo(
                          texto:
                              'Coletamos apenas as informações necessárias para '
                              'o funcionamento do aplicativo, como nome, e-mail '
                              'e dados dos eventos que você cria.',
                        ),
                        SizedBox(height: 16),
                        _Subtitulo(texto: '2. Uso das Informações'),
                        SizedBox(height: 4),
                        _Paragrafo(
                          texto:
                              'As informações são usadas exclusivamente para '
                              'oferecer e melhorar os serviços do aplicativo, '
                              'enviar notificações e garantir uma boa experiência '
                              'de uso.',
                        ),
                        SizedBox(height: 16),
                        _Subtitulo(texto: '3. Compartilhamento'),
                        SizedBox(height: 4),
                        _Paragrafo(
                          texto:
                              'Não compartilhamos seus dados com terceiros sem '
                              'a sua autorização, exceto quando exigido por lei.',
                        ),
                        SizedBox(height: 16),
                        _Subtitulo(texto: '4. Segurança'),
                        SizedBox(height: 4),
                        _Paragrafo(
                          texto:
                              'Adotamos medidas de segurança para proteger suas '
                              'informações contra acessos não autorizados, '
                              'alterações ou divulgação indevida.',
                        ),
                        SizedBox(height: 16),
                        _Subtitulo(texto: '5. Seus Direitos'),
                        SizedBox(height: 4),
                        _Paragrafo(
                          texto:
                              'Você pode, a qualquer momento, solicitar acesso, '
                              'correção ou exclusão dos seus dados pessoais '
                              'entrando em contato com nossa equipe de suporte.',
                        ),
                        SizedBox(height: 16),
                        _Paragrafo(
                          texto:
                              'Ao utilizar o EventPlanner, você concorda com os '
                              'termos descritos nesta política de privacidade.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  final String texto;
  const _Titulo({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontFamily: 'SpaceGrotesk',
        color: Color(0xFF000000),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Subtitulo extends StatelessWidget {
  final String texto;
  const _Subtitulo({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontFamily: 'SpaceGrotesk',
        color: Color(0xFF000000),
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _Paragrafo extends StatelessWidget {
  final String texto;
  const _Paragrafo({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontFamily: 'SpaceGrotesk',
        color: Color(0xFF333333),
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}
