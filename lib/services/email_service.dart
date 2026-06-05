import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  static Future<String> enviarCodigo({
    required String nome,
    required String email,
  }) async {
    final codigo = (10000 + Random().nextInt(90000)).toString();

    final response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': dotenv.env['EMAILJS_SERVICE_ID'],
        'template_id': dotenv.env['EMAILJS_TEMPLATE_ID'],
        'user_id': dotenv.env['EMAILJS_PUBLIC_KEY'],
        'accessToken': dotenv.env['EMAILJS_PRIVATE_KEY'],
        'template_params': {
          'email': email,
          'to_name': nome,
          'codigo': codigo,
        },
      }),
    );

    debugPrint('EMAILJS STATUS: ${response.statusCode}');
    debugPrint('EMAILJS BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao enviar e-mail: ${response.statusCode} - ${response.body}',
      );
    }

    return codigo;
  }
}