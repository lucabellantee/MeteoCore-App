import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/thingspeak_service.dart';
import '../widgets/chart_widget.dart';
import '../widgets/indicator_widget.dart';
import '../widgets/status_widget.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final thingspeakService = Provider.of<ThingSpeakService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ThingSpeak Weather Station'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => thingspeakService.fetchData(),
            tooltip: 'Aggiorna dati',
          ),
        ],
      ),
      body: thingspeakService.isLoading && thingspeakService.field1Data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : thingspeakService.error.isNotEmpty && thingspeakService.field1Data.isEmpty
          ? Center(child: Text('Errore: ${thingspeakService.error}'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusWidget(service: thingspeakService),
            const SizedBox(height: 16),

            _buildFilterSection(thingspeakService),
            const SizedBox(height: 16),

            const Text(
              'Temperatura',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ChartWidget(
              data: thingspeakService.field1Data,
              color: Colors.red,
              yAxisTitle: 'Temperatura (°C)',
            ),
            const SizedBox(height: 24),

            const Text(
              'Pressione',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ChartWidget(
              data: thingspeakService.field2Data,
              color: Colors.blue,
              yAxisTitle: 'Pressione (hPa)',
            ),
            const SizedBox(height: 24),

            const Text(
              'Umidità',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ChartWidget(
              data: thingspeakService.field3Data,
              color: Colors.green,
              yAxisTitle: 'Umidità (%)',
            ),
            const SizedBox(height: 24),

            const Text(
              'Stato Meteo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IndicatorWidget(
                  isActive: thingspeakService.field4Value == 1,
                  color: Colors.lightBlue,
                  label: 'Pioggia in arrivo',
                ),
                IndicatorWidget(
                  isActive: thingspeakService.field4Value == 0,
                  color: Colors.green,
                  label: 'Bel tempo',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(ThingSpeakService service) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtri',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Granularità dei dati
            Row(
              children: [
                const Text('Granularità:'),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: service.granularity,
                  items: const [
                    DropdownMenuItem(value: 'hours', child: Text('Ore')),
                    DropdownMenuItem(value: 'days', child: Text('Giorni')),
                    DropdownMenuItem(value: 'months', child: Text('Mesi')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      service.setGranularity(value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filtro per intervallo di date
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(service.startDate != null
                        ? 'Da: ${dateFormat.format(service.startDate!)}'
                        : 'Seleziona data inizio'),
                    onPressed: () => _selectDate(context, true, service),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(service.endDate != null
                        ? 'A: ${dateFormat.format(service.endDate!)}'
                        : 'Seleziona data fine'),
                    onPressed: () => _selectDate(context, false, service),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pulsante di reset
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Filtri'),
                onPressed: () => service.resetFilters(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart, ThingSpeakService service) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = isStart
        ? service.startDate ?? now.subtract(const Duration(days: 7))
        : service.endDate ?? now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Apri il selettore dell'ora
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Usa la nuova versione della funzione setDateRange che ritorna un bool
        final DateTime? otherDate = isStart ? service.endDate : service.startDate;
        final bool success = await service.setDateRange(
          isStart ? pickedDateTime : otherDate,
          isStart ? otherDate : pickedDateTime,
        );

        if (!success) {
          // Mostra un messaggio di errore
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Intervallo di date non valido. La data di inizio deve essere precedente alla data di fine e l\'intervallo non può superare un anno.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    }
  }
}