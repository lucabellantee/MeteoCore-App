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

## 🧩 Features

- **Live data visualization** from ThingSpeak
- **Dynamic charts** for trend monitoring
- **Responsive interface** optimized for mobile devices
- **Integration with ThingSpeak REST API**
- **Multi-platform support** via Flutter

---


## 📦 Tech Stack

- **Flutter 3.x**
- **Dart**
- **HTTP** package for REST requests
- **fl_chart** for charts
- **Provider (opzionale)** for state management

---

## ⚙️ Installation and Startup

### Prerequisiti

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- A configured device/emulator (Android Studio or VS Code)
- Internet connection

### Clone the repository

```bash
git clone https://github.com/lucabellantee/MeteoCore-App.git
cd thingspeak_app
```

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

---

## 🔍  Configuration

The code points to a public ThingSpeak channel, so follow these steps:

1. Create the `.env` file at the same level as 'pubspec.yaml'
2. Modify the variables THINGSPEAK_CHANNEL_ID and THINGSPEAK_API_KEY (to obtain these data you can contact the contributors).

---

## 🗂️  Project Structure

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

## 📊 ThingSpeak API

The app uses the following ThingSpeak endpoint to fetch data:

```
https://api.thingspeak.com/channels/{channel_id}/feeds.json?results=30
```

- `channel_id`: ThingSpeak channel ID
- `results`: number of readings to retrieve (e.g., 30 for the last 30 data points)

Example response:
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

To run tests:

```bash
flutter test
```

Currently, basic tests are included. You can expand coverage with widget and unit tests for data logic.

---

## 👨‍💻 Contributor

Developed with ❤️ by:

- [Luca Bellantee](https://github.com/lucabellantee)
- [Micol Zazzarini](https://github.com/MicolZazzarini)

---

## 📄 Licenza

Distributed under the MIT License. See [LICENSE](LICENSE) for details.

---

## 📬 Contacts

Have feedback or want to collaborate?

- Open an [Issue](https://github.com/lucabellantee/thingspeak_app/issues)
- Send a Pull Request
- Or contact the contributors directly via GitHub

---

## 🔮 To-Do / Future Developments

- [ ] Push notifications based on configurable thresholds
- [ ] Dark/light mode
- [ ] Temporary offline data saving
