import 'package:flutter/foundation.dart';

import '../../services/validacao.dart';
import '../email/email_sender.dart';
import '../email/google_smtp_email_sender.dart';

class AuthService {
  AuthService({EmailSender? emailSender})
    : _emailSender =
          emailSender ?? GoogleSmtpEmailSender(GoogleSmtpConfig.fromEnvironment());

  final EmailSender _emailSender;

  final Map<String, String> _usuarios = const {'admin@email.com': '123456'};

  Future<AuthResult> entrar({
    required String email,
    required String senha,
  }) async {
    final emailTratado = email.trim().toLowerCase();

    if (emailTratado.isEmpty || senha.isEmpty) {
      return const AuthResult.erro('Preencha e-mail e senha para entrar.');
    }

    if (!Validators.emailValido(emailTratado)) {
      return const AuthResult.erro('Digite um e-mail valido.');
    }

    if (_usuarios[emailTratado] != senha) {
      return const AuthResult.erro('E-mail ou senha incorretos.');
    }

    return const AuthResult.sucesso();
  }

  Future<AuthResult> enviarRecuperacaoSenha(String email) async {
    final emailTratado = email.trim().toLowerCase();
    debugPrint(
      '[AuthService] Solicitando recuperacao de senha para: $emailTratado',
    );

    if (emailTratado.isEmpty) {
      debugPrint('[AuthService] Recuperacao cancelada: e-mail vazio.');
      return const AuthResult.erro('Digite seu e-mail para receber o link.');
    }

    if (!Validators.emailValido(emailTratado)) {
      debugPrint('[AuthService] Recuperacao cancelada: e-mail invalido.');
      return const AuthResult.erro('Digite um e-mail valido.');
    }

    final resetLink = _gerarLinkRecuperacao(emailTratado);
    debugPrint('[AuthService] Link de recuperacao gerado: $resetLink');

    await _emailSender.sendPasswordResetEmail(
      to: emailTratado,
      resetLink: resetLink,
    );

    debugPrint('[AuthService] Recuperacao enviada para o sender.');
    return const AuthResult.sucesso();
  }

  Future<AuthResult> enviarConfirmacaoEmail(String email) async {
    final emailTratado = email.trim().toLowerCase();
    debugPrint(
      '[AuthService] Solicitando confirmacao de e-mail para: $emailTratado',
    );

    if (emailTratado.isEmpty) {
      debugPrint('[AuthService] Confirmacao cancelada: e-mail vazio.');
      return const AuthResult.erro('Digite seu e-mail para receber o codigo.');
    }

    if (!Validators.emailValido(emailTratado)) {
      debugPrint('[AuthService] Confirmacao cancelada: e-mail invalido.');
      return const AuthResult.erro('Digite um e-mail valido.');
    }

    final codigo = _gerarCodigoConfirmacao();
    debugPrint('[AuthService] Codigo de confirmacao gerado: $codigo');

    await _emailSender.sendEmailConfirmation(to: emailTratado, codigo: codigo);

    debugPrint('[AuthService] Confirmacao enviada para o sender.');
    return AuthResult.sucesso(codigoConfirmacao: codigo);
  }

  String _gerarLinkRecuperacao(String email) {
    final agora = DateTime.now().millisecondsSinceEpoch;
    final token = '${email.hashCode}-$agora';
    return 'eventplanner://reset-password?token=$token';
  }

  String _gerarCodigoConfirmacao() {
    final agora = DateTime.now().millisecondsSinceEpoch;
    return (agora % 100000).toString().padLeft(5, '0');
  }
}

class AuthResult {
  const AuthResult._({
    required this.sucesso,
    this.mensagem,
    this.codigoConfirmacao,
  });

  const AuthResult.sucesso({String? codigoConfirmacao})
    : this._(sucesso: true, codigoConfirmacao: codigoConfirmacao);

  const AuthResult.erro(String mensagem)
    : this._(sucesso: false, mensagem: mensagem);

  final bool sucesso;
  final String? mensagem;
  final String? codigoConfirmacao;
}
