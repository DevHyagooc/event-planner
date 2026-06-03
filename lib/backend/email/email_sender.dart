import 'dart:developer' as developer;

import 'email_message.dart';
import 'templates/email_templates.dart';

abstract class EmailSender {
  const EmailSender();

  Future<void> sendEmail(EmailMessage message);

  Future<void> sendEmailConfirmation({
    required String to,
    required String codigo,
  }) {
    return sendEmail(EmailTemplates.confirmacaoEmail(to: to, codigo: codigo));
  }

  Future<void> sendPasswordResetEmail({
    required String to,
    required String resetLink,
  }) {
    return sendEmail(
      EmailTemplates.redefinicaoSenha(to: to, resetLink: resetLink),
    );
  }
}

class DebugEmailSender extends EmailSender {
  const DebugEmailSender();

  @override
  Future<void> sendEmail(EmailMessage message) async {
    developer.log(
      'Email simulado para ${message.to}: ${message.subject}\n${message.body}\n${message.htmlBody ?? ''}',
      name: 'EventPlanner.Email',
    );
  }
}
