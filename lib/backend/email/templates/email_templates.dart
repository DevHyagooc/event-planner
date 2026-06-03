import '../email_message.dart';

class EmailTemplates {
  const EmailTemplates._();

  static EmailMessage confirmacaoEmail({
    required String to,
    required String codigo,
  }) {
    return EmailMessage(
      to: to,
      subject: 'Confirme seu e-mail - EventPlanner',
      body:
          '''
EventPlanner

Confirme seu e-mail

Use o codigo abaixo para ativar sua conta:

$codigo

Este codigo expira em alguns minutos. Se voce nao criou uma conta no EventPlanner, ignore este e-mail.
''',
      htmlBody: _layoutHtml(
        title: 'Confirme seu e-mail',
        lead: 'Use o codigo abaixo para ativar sua conta no EventPlanner.',
        highlight: codigo,
        footer:
            'Este codigo expira em alguns minutos. Se voce nao criou uma conta, ignore este e-mail.',
      ),
    );
  }

  static EmailMessage redefinicaoSenha({
    required String to,
    required String resetLink,
  }) {
    return EmailMessage(
      to: to,
      subject: 'Redefinicao de senha - EventPlanner',
      body:
          '''
EventPlanner

Redefinicao de senha

Recebemos uma solicitacao para redefinir sua senha.
Acesse o link abaixo para continuar:

$resetLink

Se voce nao solicitou isso, ignore este e-mail.
''',
      htmlBody: _layoutHtml(
        title: 'Redefinicao de senha',
        lead: 'Recebemos uma solicitacao para redefinir sua senha.',
        highlight: 'Redefinir senha',
        link: resetLink,
        footer: 'Se voce nao solicitou isso, ignore este e-mail.',
      ),
    );
  }

  static String _layoutHtml({
    required String title,
    required String lead,
    required String highlight,
    required String footer,
    String? link,
  }) {
    final destaque = link == null
        ? '<div style="font-size:32px;font-weight:700;letter-spacing:6px;color:#E76E50;margin:22px 0;">$highlight</div>'
        : '<a href="$link" style="display:inline-block;background:#E76E50;color:#ffffff;text-decoration:none;padding:14px 22px;border-radius:10px;font-weight:700;margin:22px 0;">$highlight</a>';

    return '''
<!doctype html>
<html>
  <body style="margin:0;background:#F5F3F1;font-family:Arial,sans-serif;color:#2C2421;">
    <table width="100%" cellpadding="0" cellspacing="0" role="presentation">
      <tr>
        <td align="center" style="padding:32px 16px;">
          <table width="100%" cellpadding="0" cellspacing="0" role="presentation" style="max-width:520px;background:#ffffff;border:1px solid #E6E1DC;border-radius:18px;">
            <tr>
              <td style="padding:28px;">
                <div style="font-size:14px;font-weight:700;color:#E76E50;margin-bottom:18px;">EventPlanner</div>
                <h1 style="font-size:24px;line-height:1.2;margin:0 0 10px;color:#111111;">$title</h1>
                <p style="font-size:15px;line-height:1.5;color:#8C7B73;margin:0;">$lead</p>
                $destaque
                <p style="font-size:13px;line-height:1.5;color:#9A948F;margin:0;">$footer</p>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>
''';
  }
}
