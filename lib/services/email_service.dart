import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        'service_id': 'service_uyo4j2e',
        'template_id': 'template_qpwv7zj',
        'user_id': 't_zQOL2Oxn7bOPnRf',
        'accessToken': 'KPcn9gHeraEvWJrADz8sU',
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