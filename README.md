# 📲 ThingSpeak App

**ThingSpeak App** è un'applicazione sviluppata in Flutter che consente di visualizzare dati provenienti da un canale pubblico su [ThingSpeak](https://thingspeak.com/), una piattaforma IoT per la raccolta, visualizzazione e analisi di dati da sensori. L'app è pensata per mostrare in tempo reale parametri ambientali come temperatura, umidità, pressione e la condizione di pioggia, organizzati in grafici e widget interattivi.

---

## 🌐 Panoramica

L'app si connette al canale ThingSpeak configurato e visualizza:

- 📈 **Grafici** per temperatura, umidità e pressione.
- 🌧️ **Widget circolari** che indicano visivamente se sta piovendo.
- 🔄 **Aggiornamento automatico** dei dati ogni pochi secondi.
- ✅ **Compatibilità multipiattaforma**: Android, iOS, Web (supporto limitato), macOS, Windows.

---

## 🧩 Funzionalità

- **Visualizzazione dati live** da ThingSpeak
- **Grafici dinamici** per monitoraggio di trend
- **Interfaccia reattiva** e ottimizzata per dispositivi mobili
- **Integrazione con API REST** di ThingSpeak
- **Supporto a più piattaforme** tramite Flutter

---

## 📸 Screenshot

*Aggiungi qui screenshot della schermata principale, grafici e widget.*

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
git clone https://github.com/lucabellantee/thingspeak_app.git
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

Il codice punta a un canale ThingSpeak pubblico. Se desideri cambiare canale o chiave:

1. Apri `lib/services/thingspeak_service.dart`
2. Modifica l'URL con il tuo `channel_id` e la chiave (se necessaria):

```dart
final String channelId = "TUO_CHANNEL_ID";
final String readApiKey = "TUO_API_KEY"; // Solo se il canale è privato
```

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
│   │   └── rain_indicator.dart    # Widget circolare pioggia
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
