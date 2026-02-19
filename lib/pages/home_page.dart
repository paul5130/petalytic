import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/gemini_analysis_provider.dart';
import 'gemini_result_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _pickAndAnalyze(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    final imageBytes = await picked.readAsBytes();
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final analysis = await ref
          .read(geminiAnalysisProvider.notifier)
          .analyzeImage(imageBytes);

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              GeminiResultPage(imageBytes: imageBytes, analysis: analysis),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).maybePop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('分析失敗：$error')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset('assets/images/cat_main.png', fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '拍下你的寵物',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  // shadows: [
                  //   Shadow(
                  //     blurRadius: 10,
                  //     color: Colors.black.withOpacity(0.5),
                  //     offset: Offset(1, 2),
                  //   ),
                  // ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (BuildContext sheetContext) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('使用相機'),
                              onTap: () {
                                Navigator.pop(sheetContext);
                                _pickAndAnalyze(
                                  context,
                                  ref,
                                  ImageSource.camera,
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('從相簿選擇'),
                              onTap: () {
                                Navigator.pop(sheetContext);
                                _pickAndAnalyze(
                                  context,
                                  ref,
                                  ImageSource.gallery,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('開始拍照/選擇照片'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
