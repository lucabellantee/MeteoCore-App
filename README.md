# 📲 ThingSpeak App

MeteoCore App is a Flutter application that allows you to view data coming from a public channel on [ThingSpeak](https://thingspeak.com/), an IoT platform for collecting, visualizing, and analyzing sensor data. The app is designed to display real-time environmental parameters such as temperature, humidity, pressure, and rain condition, organized in charts and interactive widgets. This application represents a high-level extension of the embedded system work, available in the following ['Repository MeteoCore'](https://github.com/lucabellantee/MeteoCore).

---

## 🌐 Overview

The app connects to the configured ThingSpeak channel and displays:

- 📈 **Charts** for temperature, humidity, and pressure.
- 🌧️ **Circular widgets** visually indicating if it is raining.
- 🔄 **Automatic data refresh** every few seconds.
- ✅ **Cross-platform compatibility**:  Android, iOS, Web (limited support), macOS, Windows.

---

## 🧩 Funzionalità

- **Visualizzazione dati live** da ThingSpeak
- **Grafici dinamici** per monitoraggio di trend
- **Interfaccia reattiva** e ottimizzata per dispositivi mobili
- **Integrazione con API REST** di ThingSpeak
- **Supporto a più piattaforme** tramite Flutter

---


## 📦 Tech Stack

- **Flutter 3.x**
- **Dart**
- **HTTP** package per le richieste REST
- **fl_chart** per i grafici
- **Provider (opzionale)** per la gestione dello stato

---

## ⚙️ Installazione e Avvio

### Prerequisiti

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installato
- Un dispositivo/emulatore configurato (Android Studio o VS Code)
- Connessione a Internet

### Clona il repository

```bash
git clone https://github.com/lucabellantee/MeteoCore-App.git
cd thingspeak_app
```

### Installa le dipendenze

```bash
flutter pub get
```

### Avvia l'app

```bash
flutter run
```

---

## 🔍 Configurazione

Il codice punta a un canale ThingSpeak pubblico, quindi occorre eseguire la seguente procedura:

1. Crea il file `.env` all'altezza del file 'pubspec.yaml'
2. Modifica le variabili 'THINGSPEAK_CHANNEL_ID' e 'THINGSPEAK_API_KEY' (Per reperire questi dati potete scrivere ai contributors).

---

## 🗂️ Struttura del Progetto

```plaintext
thingspeak_app/
│
├── lib/
│   ├── main.dart                  # Punto di ingresso dell'app
│   ├── services/
│   │   └── thingspeak_service.dart  # Logica per recupero dati da ThingSpeak
│   ├── models/
│   │   └── channel_data.dart      # Modelli per rappresentare i dati JSON
│   ├── widgets/
│   │   ├── chart_widget.dart      # Grafici FLChart
│   │   └── indicator_widget.dart    # Widget circolare pioggia
|   |   └── status_widget.dart # Indica lo status
│   └── screens/
│       └── home_screen.dart       # Schermata principale
│
├── pubspec.yaml                   # File di configurazione Flutter
└── README.md                      # Documentazione
```

---

## 📊 API ThingSpeak

L'app utilizza il seguente endpoint ThingSpeak per recuperare i dati:

```
https://api.thingspeak.com/channels/{channel_id}/feeds.json?results=30
```

- `channel_id`: ID del canale ThingSpeak
- `results`: numero di letture da recuperare (es. 30 per gli ultimi 30 punti)

Esempio di risposta:
```json
{
  "feeds": [
    {
      "created_at": "2024-01-01T00:00:00Z",
      "field1": "22.5",
      "field2": "65",
      "field3": "1012",
      "field4": "1"
    },
    ...
  ]
}
```

---

## 🧪 Testing

Per eseguire i test:

```bash
flutter test
```

Attualmente sono inclusi test di base. È possibile espandere la copertura con test di widget e unitari per la logica dei dati.

---

## 👨‍💻 Contributor

Sviluppato con ❤️ da:

- [Luca Bellantee](https://github.com/lucabellantee)
- [Micol Zazzarini](https://github.com/MicolZazzarini)

---

## 📄 Licenza

Distribuito sotto licenza MIT. Vedi [LICENSE](LICENSE) per maggiori dettagli.

---

## 📬 Contatti

Hai feedback o vuoi collaborare?

- Apri una [Issue](https://github.com/lucabellantee/thingspeak_app/issues)
- Invia una Pull Request
- Oppure contatta direttamente i contributor via GitHub

---

## 🔮 To-Do / Futuri sviluppi

- [ ] Aggiungere supporto multi-canale
- [ ] Notifiche push in base a soglie configurabili
- [ ] Modalità dark/light
- [ ] Salvataggio offline temporaneo dei dati
