// =======================================================
//                    AEVYRON DEV
//                 DREAM BIG. CODE BIGGER.
// =======================================================
//
// PROJECT: AI BACKEND INTEGRATION
// DEVELOPER: AEVYRON DEV
// COUNTRY: UGANDA
// LANGUAGE: DART
// TECHNOLOGY: HTTP / REST API / JSON
//
// Demonstration based on the CCF mobile application.
//
// =======================================================

import 'dart:convert';
import 'dart:io';

class ApiResult {
  const ApiResult({
    required this.success,
    this.data,
    this.message,
  });

  final bool success;
  final dynamic data;
  final String? message;
}

class AevyronAIService {
  AevyronAIService({HttpClient? client})
      : _client = client ?? HttpClient();

  final HttpClient _client;

  static const String baseUrl =
      'https://your-api.example.com';

  Future<ApiResult> sendMessage(String message) async {
    try {
      final request = await _client.postUrl(
        Uri.parse('$baseUrl/api/ccf-chat'),
      );

      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/json',
      );

      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/json',
      );

      request.write(jsonEncode({
        'message': message.trim(),
      }));

      final response = await request.close();

      final body = await response
          .transform(utf8.decoder)
          .join();

      dynamic decoded;

      try {
        decoded = jsonDecode(body);
      } catch (_) {
        decoded = null;
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          decoded is Map<String, dynamic>) {
        return ApiResult(
          success: decoded['success'] == true,
          data: decoded,
          message: decoded['reply']?.toString() ??
              decoded['message']?.toString(),
        );
      }

      return ApiResult(
        success: false,
        data: decoded,
        message: 'Unable to contact the AI service.',
      );
    } catch (error) {
      return ApiResult(
        success: false,
        message: error.toString(),
      );
    }
  }

  void close() {
    _client.close();
  }
}
