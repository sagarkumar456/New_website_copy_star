import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class EmailConfig {
  //  EmailJS credentials
  static const String serviceId = 'service_y64js2r';     
  static const String templateId = 'template_fjzrtba';   
  static const String publicKey = '5pLP9u1jZ7zWZG3zC';     

  static Future<bool> sendEmail({
    required String name,
    required String email,
    required String message,
    String phoneNumber = '',
  }) async {
    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'from_name': name,
            'from_email': email,
            'phone_number': phoneNumber,
            'message': message,
          }
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Email Error: $e");
      return false;
    }
  }
}