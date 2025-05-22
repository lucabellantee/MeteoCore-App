import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/chart_data.dart';
import 'package:intl/intl.dart';

class ThingSpeakService extends ChangeNotifier {

  String get channelId => dotenv.env['THINGSPEAK_CHANNEL_ID'] ?? '';
  String get apiKey => dotenv.env['THINGSPEAK_API_KEY'] ?? '';
  List<ChartData> field1Data = [];
  List<ChartData> field2Data = [];
  List<ChartData> field3Data = [];
  int field4Value = 0;

  DateTime? startDate;
  DateTime? endDate;
  String granularity = 'hours'; // 'hours', 'days', 'months'
  bool isLoading = false;
  String error = '';

  // Timer per refresh automatico ogni minuto
  Timer? _refreshTimer;
  DateTime lastUpdate = DateTime.now();

  ThingSpeakService() {
    fetchData();
    startAutoRefresh();
  }

  // Inizializza il timer di refresh
  void startAutoRefresh() {
    // Cancella eventuali timer esistenti
    stopAutoRefresh();

    // Crea un nuovo timer che esegue fetchData() ogni minuto
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchData();
    });
  }

  // Ferma il timer di refresh
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }

  Future<void> fetchData() async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      // Base URL (sempre lo stesso)
      String url = 'https://api.thingspeak.com/channels/$channelId/feeds.json';

      // Parametri in un Map per una costruzione più precisa
      Map<String, String> queryParams = {};

      // Aggiungi API key
      if (apiKey.isNotEmpty) {
        queryParams['api_key'] = apiKey;
      }

      // Parametri per granularità
      if (granularity == 'days') {
        queryParams['average'] = 'daily';
        queryParams['output'] = 'json'; // Specifica esplicitamente il formato
      } else if (granularity == 'months') {
        queryParams['average'] = 'monthly';
        queryParams['output'] = 'json'; // Specifica esplicitamente il formato
      }

      // Parametri per intervallo date
      if (startDate != null) {
        queryParams['start'] = startDate!.toUtc().toIso8601String();
      }
      if (endDate != null) {
        queryParams['end'] = endDate!.toUtc().toIso8601String();
      }

      // Costruisci URL con i parametri
      Uri uri = Uri.parse(url).replace(queryParameters: queryParams);
      print('Requesting URL: $uri'); // Debug

      // Headers specifici per evitare 406
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Debug per vedere la risposta
        print('Response status: ${response.statusCode}');

        final feed = ThingSpeakFeed.fromJson(data);

        if (feed.feeds.isEmpty) {
          error = 'Nessun dato disponibile per i filtri selezionati';
        } else {
          field1Data = feed.feeds
              .where((feed) => feed['field1'] != null && feed['field1'] != '')
              .map((feed) => ChartData.fromJson(feed, 'field1'))
              .toList();

          field2Data = feed.feeds
              .where((feed) => feed['field2'] != null && feed['field2'] != '')
              .map((feed) => ChartData.fromJson(feed, 'field2'))
              .toList();

          field3Data = feed.feeds
              .where((feed) => feed['field3'] != null && feed['field3'] != '')
              .map((feed) => ChartData.fromJson(feed, 'field3'))
              .toList();

          // Per il Field 4 (indicatore), prendiamo solo l'ultimo valore
          final lastEntry = feed.feeds.lastWhere(
                (feed) => feed['field4'] != null && feed['field4'] != '',
            orElse: () => {'field4': '0'},
          );

          try {
            field4Value = int.parse(lastEntry['field4'] ?? '0');
          } catch (e) {
            field4Value = 0;
            print('Error parsing field4: $e');
          }
        }

        // Aggiorna il timestamp dell'ultimo aggiornamento
        lastUpdate = DateTime.now();
      } else {
        print('Error status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        error = 'Errore nel caricamento dei dati: ${response.statusCode}';

        // Gestione specifica dell'errore 404 o 406
        if (response.statusCode == 404) {
          error = 'Canale ThingSpeak non trovato (404). Verifica ID canale e chiave API.';
        } else if (response.statusCode == 406) {
          error = 'Formato non accettabile (406). Problema con le impostazioni di granularità.';
        }
      }
    } catch (e) {
      print('Exception: $e');
      error = 'Errore nella connessione: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setGranularity(String newGranularity) {
    granularity = newGranularity;
    fetchData();
  }

  bool validateDateRange(DateTime? start, DateTime? end) {
    // Verifica se le date sono valide
    if (start != null && end != null) {
      if (start.isAfter(end)) {
        return false;
      }

      // Verifica che l'intervallo non sia troppo ampio (opzionale)
      if (end.difference(start).inDays > 365) {
        return false;
      }
    }

    return true;
  }

  Future<bool> setDateRange(DateTime? start, DateTime? end) {
    // Verifica la validità dell'intervallo di date
    if (!validateDateRange(start, end)) {
      return Future.value(false);
    }

    startDate = start;
    endDate = end;
    fetchData();
    return Future.value(true);
  }

  void resetFilters() {
    startDate = null;
    endDate = null;
    granularity = 'hours';
    fetchData();
  }
}