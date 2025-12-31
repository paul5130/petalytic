import 'dart:io';

import 'package:flutter/material.dart';
import 'package:petalytic/pages/health_result_page.dart';

class PhotoResultPage extends StatelessWidget {
  final String imagePath;

  const PhotoResultPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo result')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
              // child: Image.asset(
              //   imagePath,
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              //   height: 300,
              // ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Detection successful',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'The pet\'s tongue was successfully detected in the photo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthResultPage(),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
