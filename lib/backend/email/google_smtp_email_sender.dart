import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'email_message.dart';
import 'email_sender.dart';

class GoogleSmtpConfig {
  const GoogleSmtpConfig({
    required this.username,
    required this.appPassword,
    this.displayName = 'Event Planner',
    this.host = 'smtp.gmail.com',
    this.port = 587,
    this.useSsl = false,
  });

  static const defaultAccount = GoogleSmtpConfig(
    username: 'eventplannerunit@gmail.com',
    appPassword: 'eewb htez iosg vnmo',
  );

  factory GoogleSmtpConfig.fromEnvironment() {
    const username = String.fromEnvironment(
      'SMTP_USERNAME',
      defaultValue: 'eventplannerunit@gmail.com',
    );
    const appPassword = String.fromEnvironment(
      'SMTP_APP_PASSWORD',
      defaultValue: 'eewb htez iosg vnmo',
    );
    const displayName = String.fromEnvironment(
      'SMTP_DISPLAY_NAME',
      defaultValue: 'Event Planner',
    );
    const host = String.fromEnvironment(
      'SMTP_HOST',
      defaultValue: 'smtp.gmail.com',
    );
    const port = int.fromEnvironment('SMTP_PORT', defaultValue: 587);
    const useSsl = bool.fromEnvironment('SMTP_SSL', defaultValue: false);

    return const GoogleSmtpConfig(
      username: username,
      appPassword: appPassword,
      displayName: displayName,
      host: host,
      port: port,
      useSsl: useSsl,
    );
  }

  final String username;
  final String appPassword;
  final String displayName;
  final String host;
  final int port;
  final bool useSsl;
}

class GoogleSmtpEmailSender extends EmailSender {
  const GoogleSmtpEmailSender(this.config);

  final GoogleSmtpConfig config;

  @override
  Future<void> sendEmail(EmailMessage message) async {
    debugPrint('[GoogleSmtpEmailSender] SMTP real iniciado.');
    debugPrint('[GoogleSmtpEmailSender] Conta: ${config.username}');
    debugPrint('[GoogleSmtpEmailSender] Host: ${config.host}:${config.port}');
    debugPrint('[GoogleSmtpEmailSender] Para: ${message.to}');
    debugPrint('[GoogleSmtpEmailSender] Assunto: ${message.subject}');
    final smtpServer = SmtpServer(
      config.host,
      port: config.port,
      username: config.username,
      password: config.appPassword,
      ssl: config.useSsl,
      allowInsecure: !config.useSsl,
    );

    final email = Message()
      ..from = Address(config.username, config.displayName)
      ..recipients.add(message.to)
      ..subject = message.subject
      ..text = message.body;

    final htmlBody = message.htmlBody;
    if (htmlBody != null && htmlBody.isNotEmpty) {
      email.html = htmlBody;
    }

    final sendReport = await send(email, smtpServer);
    debugPrint(
      '[GoogleSmtpEmailSender] E-mail enviado com sucesso: ${sendReport.toString()}',
    );
  }
}
