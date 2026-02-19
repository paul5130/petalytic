import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class GeminiService {
  GeminiService({required this.apiKey, this.model = 'gemini-2.5-flash'});

  final String apiKey;
  final String model;
  final http.Client _client = http.Client();

  Future<String> analyzePetImage(Uint8List imageBytes) async {
    final key = 'Your API Key Here'; // Replace with your actual API key

    final base64Image = base64Encode(imageBytes);
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$key',
    );

    final body = {
      'contents': [
        {
          'parts': [
            {
              'text':
                  '你是一位資深獸醫。請「直接」給出結論，無需自我介紹與多餘推理。\n'
                  '1. 品種辨識：\n'
                  '2. 健康評估：(重點說明是否有疾病或異常)\n'
                  '3. 照護建議：\n'
                  '請使用繁體中文，總字數 300 字以內。',
            },
            {
              'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image},
            },
          ],
        },
      ],
      'generationConfig': {'temperature': 0.2, 'maxOutputTokens': 4096},
    };

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini error: ${response.statusCode} ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = decoded['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      throw Exception('Gemini response missing candidates');
    }

    final content = candidates.first['content'];
    final parts = content?['parts'];
    if (parts is! List || parts.isEmpty) {
      throw Exception('Gemini response missing parts');
    }

    final text = parts.first['text'];
    if (text is! String || text.trim().isEmpty) {
      throw Exception('Gemini response missing text');
    }

    return text.trim();
  }
}
