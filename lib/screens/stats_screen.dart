import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/book_service.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas generales')),
      body: StreamBuilder(
        stream: BookService().watchBooks(),
        builder: (context, snapshot) {
          final books = snapshot.data ?? [];
          final totalPages = books.fold<int>(0, (sum, b) => sum + b.currentPage);
          final total = books.fold<int>(0, (sum, b) => sum + b.totalPages);
          final progress = total == 0 ? 0.0 : totalPages / total;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Progreso global: ${(progress * 100).toStringAsFixed(1)}%'),
                const SizedBox(height: 24),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [
                          BarChartRodData(toY: totalPages.toDouble(), width: 24),
                        ]),
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(toY: total.toDouble(), width: 24),
                        ]),
                      ],
                    ),
                  ),
                ),
                const Text('Páginas leídas vs. páginas totales'),
              ],
            ),
          );
        },
      ),
    );
  }
}
