import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HealthResultPage extends StatelessWidget {
  const HealthResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Center(
              child: SizedBox(
                height: 240,
                width: 240,
                child: RadarChart(
                  RadarChartData(
                    radarShape: RadarShape.polygon,
                    tickCount: 3,
                    ticksTextStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                    titleTextStyle: const TextStyle(fontSize: 14),
                    getTitle: (index, angle) {
                      const titles = ['木', '火', '土', '金', '水'];

                      return RadarChartTitle(text: titles[index]);
                    },
                    dataSets: [
                      RadarDataSet(
                        fillColor: Colors.blue.withValues(alpha: .4),
                        borderColor: Colors.blue,
                        entryRadius: 3,
                        dataEntries: [
                          RadarEntry(value: 3),
                          RadarEntry(value: 4),
                          RadarEntry(value: 2.5),
                          RadarEntry(value: 3.5),
                          RadarEntry(value: 2),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ElementIcon(label: '木', icon: Icons.forest),
                _ElementIcon(label: '火', icon: Icons.whatshot),
                _ElementIcon(label: '土', icon: Icons.landscape),
                _ElementIcon(label: '金', icon: Icons.attach_money),
                _ElementIcon(label: '水', icon: Icons.water),
              ],
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  leading: CircleAvatar(child: Icon(Icons.pets)),
                  title: Text('Kurt'),
                  subtitle: Text('4 yro, Male'),
                ),
                const Divider(height: 32),
                const Text(
                  'Health Suggestions:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const ListTile(
                  leading: Icon(Icons.monitor_heart),
                  title: Text(
                    'Maintain a balanced diet to support heart health.',
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.directions_run),
                  title: Text(
                    'Encourage regular activity to avoid weight gain.',
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.water_drop),
                  title: Text(
                    'Ensure proper hydration, especially in hot weather.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: () {}, child: const Text('Share')),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _ElementIcon extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ElementIcon({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Icon(icon, size: 32), const SizedBox(height: 4), Text(label)],
    );
  }
}
