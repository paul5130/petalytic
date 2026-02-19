import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/gemini_service.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  const apiKey = String.fromEnvironment('GEMINI_API_KEY');
  return GeminiService(apiKey: apiKey);
});

final geminiAnalysisProvider =
    AsyncNotifierProvider<GeminiAnalysisNotifier, String?>(
  GeminiAnalysisNotifier.new,
);

class GeminiAnalysisNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    return null;
  }

  Future<String> analyzeImage(Uint8List imageBytes) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(geminiServiceProvider);
      final result = await service.analyzePetImage(imageBytes);
      state = AsyncData(result);
      return result;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }
}
