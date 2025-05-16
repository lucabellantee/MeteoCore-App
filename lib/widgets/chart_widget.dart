import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../services/thingspeak_service.dart';
import '../models/chart_data.dart';
import 'package:intl/intl.dart';

class ChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final Color color;
  final String yAxisTitle;

  const ChartWidget({
    super.key,
    required this.data,
    required this.color,
    required this.yAxisTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text('Nessun dato disponibile')),
      );
    }

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value < 0 || value >= data.length) {
                    return const SizedBox.shrink();
                  }

                  final date = data[value.toInt()].time;
                  String text;

                  // Formatta la data in base alla granularità specificata
                  // Ottieni la granularità corrente dal provider
                  final granularity = Provider.of<ThingSpeakService>(context, listen: false).granularity;

                  if (data.length > 20) {
                    // Mostra meno etichette se ci sono molti dati
                    if (value.toInt() % (data.length ~/ 5) != 0) {
                      return const SizedBox.shrink();
                    }

                    if (granularity == 'hours') {
                      text = DateFormat('HH:mm\ndd/MM').format(date);
                    } else if (granularity == 'days') {
                      text = DateFormat('dd/MM').format(date);
                    } else { // months
                      text = DateFormat('MM/yyyy').format(date);
                    }
                  } else {
                    if (granularity == 'hours') {
                      text = DateFormat('HH:mm\ndd/MM').format(date);
                    } else if (granularity == 'days') {
                      text = DateFormat('dd/MM').format(date);
                    } else { // months
                      text = DateFormat('MM/yyyy').format(date);
                    }
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                yAxisTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              axisNameSize: 25,
              sideTitles: SideTitles(
                showTitles: true,
                interval: _calculateInterval(),
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: 0,
          maxX: data.length - 1,
          minY: _calculateMinY(),
          maxY: _calculateMaxY(),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final dataPoint = data[spot.x.toInt()];

                  // Formatta il tooltip in base alla granularità
                  final granularity = Provider.of<ThingSpeakService>(context, listen: false).granularity;
                  String dateFormat;

                  if (granularity == 'hours') {
                    dateFormat = 'dd/MM/yyyy HH:mm';
                  } else if (granularity == 'days') {
                    dateFormat = 'dd/MM/yyyy';
                  } else { // months
                    dateFormat = 'MM/yyyy';
                  }

                  return LineTooltipItem(
                    '${DateFormat(dateFormat).format(dataPoint.time)}\n${dataPoint.value.toStringAsFixed(1)} ',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(data.length, (index) {
                return FlSpot(index.toDouble(), data[index].value);
              }),
              isCurved: true,
              color: color,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: data.length < 15, // Mostra punti solo se ci sono pochi dati
              ),
              belowBarData: BarAreaData(
                show: true,
                color: color.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateMinY() {
    if (data.isEmpty) return 0;

    final minValue = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    // Arrotonda verso il basso e aggiungi un po' di margine
    return (minValue * 0.95).floorToDouble();
  }

  double _calculateMaxY() {
    if (data.isEmpty) return 10;

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    // Arrotonda verso l'alto e aggiungi un po' di margine
    return (maxValue * 1.05).ceilToDouble();
  }

  double _calculateInterval() {
    final minY = _calculateMinY();
    final maxY = _calculateMaxY();
    final range = maxY - minY;

    // Calcola un intervallo che dia circa 5-7 etichette sull'asse Y
    if (range <= 5) return 1;
    if (range <= 20) return 2;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    if (range <= 500) return 50;
    return 100;
  }
}