import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pengajuan_model.dart';

class StatistikLayananPage extends StatelessWidget {
  const StatistikLayananPage({super.key});

  static const List<Color> _warna = [
    Color(0xFF0D47A1),
    Color(0xFF1565C0),
    Color(0xFF1E88E5),
    Color(0xFF42A5F5),
    Color(0xFF90CAF9),
  ];

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PengajuanModel>();
    final bidang = PengajuanModel.daftarBidang;
    final jumlah = bidang.map(model.jumlahBidang).toList();

    final terbesar = jumlah.fold<int>(0, (a, b) => a > b ? a : b);
    final double maxY = (terbesar < 3 ? 3 : terbesar + 1).toDouble();
    final double interval = maxY > 10 ? (maxY / 5).ceilToDouble() : 1;
    final skema = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pengajuan per Bidang Layanan',
                    style: Theme.of(context).textTheme.titleMedium),
                Text('Total ${model.total} pengajuan',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 20),
                SizedBox(
                  height: 280,
                  child: BarChart(
                    BarChartData(
                      minY: 0,
                      maxY: maxY,
                      alignment: BarChartAlignment.spaceAround,
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: interval,
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: interval,
                            getTitlesWidget: (nilai, meta) => Text(
                              nilai.toInt().toString(),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 34,
                            getTitlesWidget: (nilai, meta) {
                              final i = nilai.toInt();
                              if (i < 0 || i >= bidang.length) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                meta: meta,
                                space: 8,
                                child: SizedBox(
                                  width: 56,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(bidang[i],
                                        style: const TextStyle(fontSize: 10)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(bidang.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: jumlah[i].toDouble(),
                              width: 26,
                              color: _warna[i % _warna.length],
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: maxY,
                                color: skema.surfaceContainerHighest
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: List.generate(bidang.length, (i) {
              return ListTile(
                dense: true,
                leading: CircleAvatar(
                    radius: 8, backgroundColor: _warna[i % _warna.length]),
                title: Text(bidang[i]),
                trailing: Text('${jumlah[i]}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            }),
          ),
        ),
      ],
    );
  }
}
