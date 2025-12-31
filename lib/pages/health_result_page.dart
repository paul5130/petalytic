import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

const List<double> elementValues = [1.2, 4.5, 3.0, 2.2, 4.8];

Color statusColor(double value) {
  if (value < 2.0) return Colors.lightBlue;
  if (value > 4.0) return Colors.redAccent;
  return Colors.green;
}

String statusText(double value) {
  if (value < 2.0) return '虛';
  if (value > 4.0) return '旺';
  return '平衡';
}

const List<String> elementLabels = ['木', '火', '土', '金', '水'];
const List<IconData> elementIcons = [
  Icons.forest,
  Icons.whatshot,
  Icons.landscape,
  Icons.attach_money,
  Icons.water,
];

List<RadarEntry> getRadarEntries(List<double> values) {
  return values.map((value) => RadarEntry(value: value)).toList();
}

class HealthResultPage extends StatelessWidget {
  const HealthResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Health analysis',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Radar Chart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    height: 280,
                    width: 280,
                    child: RadarChart(
                      RadarChartData(
                        radarShape: RadarShape.polygon,
                        tickCount: 5,
                        ticksTextStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                        titleTextStyle: const TextStyle(fontSize: 14),
                        getTitle: (index, angle) =>
                            RadarChartTitle(text: elementLabels[index]),
                        dataSets: [
                          // 標準值線（明顯虛線樣式）
                          RadarDataSet(
                            fillColor: Colors.transparent,
                            borderColor: Colors.orangeAccent,
                            borderWidth: 3.0,
                            // borderDashArray: [8, 4],
                            entryRadius: 0,
                            dataEntries: List.generate(
                              5,
                              (_) => const RadarEntry(value: 3), // 標準值
                            ),
                          ),
                          // 虛 (藍)
                          RadarDataSet(
                            fillColor: Colors.lightBlue.withValues(alpha: .3),
                            borderColor: Colors.lightBlue,
                            borderWidth: 2.0,
                            entryRadius: 2,
                            dataEntries: elementValues
                                .map(
                                  (v) => v < 2
                                      ? RadarEntry(value: v)
                                      : const RadarEntry(value: 0),
                                )
                                .toList(),
                          ),
                          // 平衡 (綠)
                          RadarDataSet(
                            fillColor: Colors.green.withValues(alpha: .3),
                            borderColor: Colors.green,
                            borderWidth: 2.0,
                            entryRadius: 2,
                            dataEntries: elementValues
                                .map(
                                  (v) => (v >= 2 && v <= 4)
                                      ? RadarEntry(value: v)
                                      : const RadarEntry(value: 0),
                                )
                                .toList(),
                          ),
                          // 旺 (紅)
                          RadarDataSet(
                            fillColor: Colors.redAccent.withValues(alpha: .3),
                            borderColor: Colors.redAccent,
                            borderWidth: 2.0,
                            entryRadius: 2,
                            dataEntries: elementValues
                                .map(
                                  (v) => v > 4
                                      ? RadarEntry(value: v)
                                      : const RadarEntry(value: 0),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Elements',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(elementLabels.length, (index) {
                    final value = elementValues[index];
                    return _ElementIcon(
                      label: elementLabels[index],
                      icon: elementIcons[index],
                      color: statusColor(value),
                      status: statusText(value),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Health Suggestions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ListTile(
                        leading: CircleAvatar(child: Icon(Icons.pets)),
                        title: Text('Kurt'),
                        subtitle: Text('4 yro, Male'),
                      ),
                      Divider(height: 32),
                      ListTile(
                        leading: Icon(Icons.monitor_heart),
                        title: Text(
                          'Maintain a balanced diet to support heart health.',
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.directions_run),
                        title: Text(
                          'Encourage regular activity to avoid weight gain.',
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.water_drop),
                        title: Text(
                          'Ensure proper hydration, especially in hot weather.',
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 32),
                // ElevatedButton(onPressed: () {}, child: const Text('Share')),
                // const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ElementIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String status;

  const _ElementIcon({
    required this.label,
    required this.icon,
    required this.color,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: .15),
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(status, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}
