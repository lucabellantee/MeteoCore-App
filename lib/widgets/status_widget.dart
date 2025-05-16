import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/thingspeak_service.dart';

class StatusWidget extends StatefulWidget {
  final ThingSpeakService service;

  const StatusWidget({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    // Aggiorna l'ora ogni secondo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usiamo l'ora corrente locale per l'Italia (GMT+2)
    final currentTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(_now);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stato Connessione',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.service.isLoading
                            ? Colors.amber
                            : (widget.service.error.isNotEmpty ? Colors.red : Colors.green),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.service.isLoading
                          ? 'Aggiornamento...'
                          : (widget.service.error.isNotEmpty ? 'Errore' : 'Connesso'),
                      style: TextStyle(
                        color: widget.service.isLoading
                            ? Colors.amber
                            : (widget.service.error.isNotEmpty ? Colors.red : Colors.green),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ultimo aggiornamento:'),
                Text(
                  currentTime,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (widget.service.error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Dettaglio errore: ${widget.service.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 8),
            const Text('Refresh automatico: ogni minuto'),
          ],
        ),
      ),
    );
  }
}