class EmailMessage {
  const EmailMessage({
    required this.to,
    required this.subject,
    required this.body,
    this.htmlBody,
  });

  final String to;
  final String subject;
  final String body;
  final String? htmlBody;
}
